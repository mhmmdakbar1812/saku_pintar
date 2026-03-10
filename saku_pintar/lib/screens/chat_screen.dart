import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:uuid/uuid.dart';
import '../services/n8n_service.dart';
import '../services/voice_service.dart'; // Import service suara

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<MessageEntity> _messages = [];
  final N8NService _n8nService = N8NService();
  final VoiceService _voiceService = VoiceService(); // Inisialisasi service suara
  
  // Session ID unik agar Simple Memory di n8n tidak tertukar
  final String _sessionId = const Uuid().v4(); 
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _voiceService.initSpeech(); // Menyiapkan mikrofon saat layar dibuka
  }

  // Logika mengirim pesan teks ke n8n
  void _handleSend() async {
    if (_controller.text.isEmpty) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.add(MessageEntity(text: userMessage, isUser: true));
      _isLoading = true;
      _controller.clear();
    });

    // Mengirim pesan ke n8n Webhook
    final aiResponse = await _n8nService.sendMessage(userMessage, _sessionId);

    setState(() {
      _messages.add(MessageEntity(text: aiResponse, isUser: false));
      _isLoading = false;
    });
  }

  // Logika tombol mikrofon (Voice-to-Text)
  void _handleVoiceClick() {
    if (_voiceService.isListening) {
      _voiceService.stopListening();
      setState(() {});
    } else {
      _voiceService.startListening((text) {
        setState(() {
          _controller.text = text; // Hasil suara otomatis masuk ke kotak input
        });
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saku Pintar AI"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Area Chat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return BubbleSpecialThree(
                  text: msg.text,
                  color: msg.isUser ? const Color(0xFF1B97F3) : const Color(0xFFE8E8EE),
                  tail: true,
                  textStyle: TextStyle(
                    color: msg.isUser ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                  isSender: msg.isUser,
                );
              },
            ),
          ),
          
          // Indikator Loading saat AI sedang memproses
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Saku Pintar sedang berpikir...", 
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
            ),

          // Input Field (Barisan Bawah)
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.grey.shade300, blurRadius: 4)
            ]),
            child: Row(
              children: [
                // Tombol Mikrofon
                IconButton(
                  icon: Icon(
                    _voiceService.isListening ? Icons.stop_circle : Icons.mic, 
                    color: _voiceService.isListening ? Colors.red : Colors.teal
                  ),
                  onPressed: _handleVoiceClick,
                ),
                // Kotak Input Teks
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Tanya soal keuangan...",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
                // Tombol Kirim
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: _handleSend,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Model data pesan
class MessageEntity {
  final String text;
  final bool isUser;
  MessageEntity({required this.text, required this.isUser});
}