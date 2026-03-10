import 'package:dio/dio.dart';

class N8NService {
  final Dio _dio = Dio();
  // Pastikan IP ini sama dengan IP di browser kamu
  final String _webhookUrl = 'https://gawkiest-thurman-sternmost.ngrok-free.dev/webhook/chat-keuangan'; 

  Future<String> sendMessage(String message, String sessionId) async {
    try {
        print("MENGIRIM PESAN KE: $_webhookUrl");
        final response = await _dio.post(
          _webhookUrl,
          data: {'chatInput': message, 'sessionId': sessionId},
        );
        print("BALASAN N8N: ${response.data}"); 
        // SABUK PENGAMAN: Jika balasan kosong
        if (response.data == null || response.data == '') {
          return "Pesan terkirim, tapi AI membalas dengan format kosong. Cek pengaturan Respond n8n kamu.";
        }
        // SABUK PENGAMAN: Jika balasan berupa teks biasa (String), bukan JSON
        if (response.data is String) {
          return response.data;
        }
        // Jika bentuknya JSON (Map), ambil isinya
        return response.data['output'] ?? response.data.toString();
      } catch (e) {
      print("ERROR KONEKSI N8N: $e"); // Ini akan menunjukkan tipe error aslinya (Timeout/Refused)
      return "Error: Gagal terhubung ke AI.";
    }
  }
}