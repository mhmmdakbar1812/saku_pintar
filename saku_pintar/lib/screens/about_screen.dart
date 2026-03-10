import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang Aplikasi"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ikon/Logo Aplikasi
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance_wallet, size: 80, color: Colors.teal),
              ),
              const SizedBox(height: 24),
              
              // Nama & Versi
              const Text(
                "Saku Pintar",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Versi 1.0.0",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 32),
              
              // Deskripsi
              const Text(
                "Smart Financial Tracker dengan integrasi AI (RAG & LLM & n8n). "
                "Catat pemasukan dan pengeluaran Anda cukup dengan perintah suara atau teks, "
                "serta dapatkan konsultasi keuangan instan kapan saja.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 20),
              
              // Info Developer
              const Text(
                "Dikembangkan oleh:",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                "Muhammad Akbar Ramadhan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "LLM + RAG + n8n System",
                style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}