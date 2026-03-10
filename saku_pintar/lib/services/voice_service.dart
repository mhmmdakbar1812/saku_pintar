import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  bool _isAvailable = false;

  // Inisialisasi awal
  Future<bool> initSpeech() async {
    _isAvailable = await _speech.initialize(
      onError: (val) => print('Error suara: $val'),
      onStatus: (val) => print('Status suara: $val'),
    );
    return _isAvailable;
  }

  // Mulai mendengarkan
  void startListening(Function(String) onResult) async {
    if (_isAvailable) {
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        localeId: "id_ID", // Mengatur agar mengenali Bahasa Indonesia
      );
    }
  }

  // Berhenti mendengarkan
  void stopListening() async {
    await _speech.stop();
  }

  bool get isListening => _speech.isListening;
}