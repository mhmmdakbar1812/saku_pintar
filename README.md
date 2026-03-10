# saku_pintar
A new Flutter project.


# 🚀 Saku Pintar - Self-Hosted Setup Guide
Saku Pintar adalah aplikasi asisten keuangan cerdas berbasis AI yang dilengkapi dengan fitur prediksi saham IHSG menggunakan model *Deep Learning* (LSTM). Sistem ini dibangun menggunakan Flutter (Frontend), n8n (AI Agent/Workflow Automation), dan Python/FastAPI (AI Prediction Engine).

---
## 📋 Prasyarat Sistem
Pastikan perangkat kamu sudah terinstal:
1. [Docker Desktop](https://www.docker.com/) atau Docker Engine (untuk menjalankan n8n).
2. [Python 3.9+](https://www.python.org/downloads/) (untuk *engine* AI).
3. [Flutter SDK](https://docs.flutter.dev/get-started/install) (untuk *build* aplikasi *mobile*).
4. [Ngrok](https://ngrok.com/download) (untuk membuka jalur publik n8n ke aplikasi Flutter).
---

## 🛠️ Tahapan Menjalankan Program (Self-Host)

### Tahap 1: Menjalankan n8n (AI Agent Workflow)
Kita menggunakan Docker untuk menjalankan n8n agar terisolasi dan stabil.
1. Buka terminal dan arahkan ke folder yang berisi `docker-compose.yml` milik n8n.
2. Jalankan perintah berikut untuk mengangkat *container* n8n di *background*:
   ```bash
   docker-compose up -d
3. Buka browser dan akses n8n di http://localhost:5678
4. Import file JSON workflow Saku Pintar (jika kamu baru pertama kali setup di device ini).

### Tahap 2: Integrasi Ngrok ke n8n
Agar aplikasi Flutter di HP kamu bisa "berbicara" dengan n8n yang ada di laptop/server lokal, kita perlu membuka terowongan (tunnel) menggunakan ngrok.

1. Buka terminal baru.
2. Jalankan perintah berikut untuk mengekspos port 5678 (port default n8n):
    ```bash
    ngrok http 5678
3. Copy URL publik yang diberikan oleh ngrok (contoh: https://xxxx-xxxx.ngrok-free.app) dan akses port 5678 dengan URL publik sendiri:
    ```bash
    ngrok http --domain=xxxx-xxxx.ngrok-free.app 5678
4. Penting: Jika kamu menggunakan node Webhook di n8n, update URL di dalam kode Flutter kamu menggunakan link ngrok ini

### Tahap 3: Menjalankan Engine AI Python (FastAPI + LSTM)
Sistem prediksi saham berjalan di server Python lokal.
1. terminal baru dan arahkan ke folder Python (misal: cd ai_api/).
2. (Opsional tapi disarankan) Buat dan aktifkan Virtual Environment:
    ```bash
    # Windows
    python -m venv venv
    venv\Scripts\activate
    # Mac/Linux
    python3 -m venv venv
    source venv/bin/activate
3. Instal semua dependensi library AI:
    ```bash
    pip install -r requirements.txt
    pip install jupyter
4. Jalankan Jupyter Notebook melalui terminal:
    ```bash
    jupyter notebook
5. Browser kamu akan otomatis terbuka. Cari dan buka file notebook kamu (misalnya: engine_saham.ipynb).
    - Eksekusi Kode: Jalankan semua sel (Run All) dari atas ke bawah.
    - Biarkan proses training LSTM berjalan di awal (bisa memakan waktu beberapa menit).
6. Pastikan sel terakhir yang berisi kode nest_asyncio dan uvicorn dieksekusi, hingga muncul log:
   Your quick Tunnel has been created! Visit it at (it may take some time to be reachable):
   https://xxxxxxx-xxxxxxxx-xxxxx-xxxx.trycloudflare.com
7. Konfigurasi n8n: Pastikan URL di node HTTP Request n8n kamu diarahkan ke API lokal ini dengan 
   URL https://xxxxxxx-xxxxxxxx-xxxxx-xxxx.trycloudflare.com/predict-top-10

### Tahap 4: Menjalankan Aplikasi Mobile (Flutter)
Setelah backend dan AI siap, saatnya menyalakan aplikasinya.
1. Buka terminal baru dan arahkan ke folder project Flutter (misal: cd saku_pintar_flutter/)
2. Unduh semua package yang dibutuhkan:
   ```bash
   flutter pub get
3. Pastikan link API/Webhook di dalam kode Dart kamu sudah mengarah ke link ngrok terbaru.
4. Sambungkan HP (via USB/Wireless Debugging) atau nyalakan Emulator.
5. Jalankan aplikasi:
   ```bash
   flutter run


### Tahap 5: Cara Mematikan Sistem
Jika sudah selesai development, matikan sistem dengan rapi:
1. n8n: Jalankan docker-compose down di folder n8n.
2. Python & Ngrok: Tekan Ctrl + C di masing-masing terminal.