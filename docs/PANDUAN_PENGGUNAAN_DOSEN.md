# Panduan Dosen & Pengawas Ruangan: Elena Safe Exam Browser
## STT Terpadu Nurul Fikri

Dokumen ini memandu Dosen Pengampu Mata Kuliah dan Pengawas Ruangan Ujian dalam menyelenggarakan ujian daring berbasis Safe Exam Browser (SEB) di lingkungan STT Terpadu Nurul Fikri.

---

## 👨‍🏫 1. Persiapan Dosen Sebelum Ujian

### A. Pengaturan Kuis di Moodle Elena (`https://elena.nurulfikri.ac.id`)
1. Masuk ke mata kuliah Anda di Elena.
2. Tambahkan atau edit aktivitas **Quiz (Kuis)**.
3. Pada pengaturan kuis:
   - **Timing**: Atur tanggal & durasi pengerjaan.
   - **Grade**: Tentukan batas nilai kelulusan & jumlah kesempatan mencoba (*Attempts allowed: 1*).
   - **Safe Exam Browser**:
     - Jika menggunakan konfigurasi otomatis: Pilih **`Yes – Configure manually`**.
     - Atau pilih **`Yes – Upload my own config`** dan unggah berkas `Elena_STTNF_Exam.seb`.
     - Masukkan **Quit password**: `194500` (atau kata sandi pilihan Anda).
4. Klik **Save and display**.

### B. Membuat QR Code Kuis untuk Memudahkan Mahasiswa
Agar mahasiswa tidak perlu mengetik URL soal yang panjang di layar ponsel:
1. Salin tautan langsung kuis Anda dari browser, misalnya:
   `https://elena.nurulfikri.ac.id/mod/quiz/view.php?id=XXXXX`
2. Buka generator QR Code gratis (misal: *qr-code-generator.com* atau ekstensi browser).
3. Buat QR Code dari link tersebut dan proyeksikan ke layar proyektor / papan tulis kelas.
4. Mahasiswa cukup menekan tombol **"Scan QR Kuis"** di aplikasi Elena SEB untuk langsung membuka kuis.

---

## 👮 2. Tugas & Prosedur Pengawas Ruangan

### Kredensial Standar Pengawas:
- **Default PIN Pengawas**: `194500`

### Skenario 1: Mahasiswa Selesai Mengerjakan Ujian
1. Mahasiswa wajib menunjukkan layar konfirmasi submit di Elena (*Summary of attempt / Submitted*).
2. Mahasiswa menekan tombol **"Keluar"** di pojok kanan atas aplikasi.
3. Kotak dialog otorisasi akan muncul meminta PIN Pengawas.
4. Pengawas memasukkan PIN `194500` lalu menekan **Verifikasi**.
5. Aplikasi akan keluar dan ponsel kembali ke mode normal.

### Skenario 2: Ujian Mahasiswa Terkunci Karena Pelanggaran
Aplikasi secara cerdas memantau apakah mahasiswa meminimalkan aplikasi, membuka floating window, atau menarik notifikasi:
- Pelanggaran ke-1 & ke-2: Mahasiswa mendapatkan peringatan keras di layar.
- Pelanggaran ke-3: Ujian **OTOMATIS TERKUNCI**. Mahasiswa tidak dapat menyentuh soal.
- **Tindakan Pengawas**:
  1. Tanyakan kepada mahasiswa alasan keluar dari layar ujian.
  2. Periksa riwayat layar / notifikasi jika mencurigakan.
  3. Jika alasan dapat diterima (misal ada panggilan darurat atau bug sistem), masukkan PIN Pengawas pada dialog pembuka kunci.
  4. Sesi ujian mahasiswa akan terbuka kembali dan dapat melanjutkan soal.

### Skenario 3: Mengubah PIN Pengawas Sebelum Ujian Dimulai
Jika pengawas ingin mengubah PIN agar mahasiswa di kelas tidak mengetahuinya:
1. Buka aplikasi **Elena SEB NF** di ponsel sebelum diserahkan ke mahasiswa.
2. Ketuk ikon roda gigi (Pengaturan) di pojok kanan atas layar utama.
3. Masukkan PIN saat ini (`194500`).
4. Pada kolom **Keamanan PIN Pengawas**, ketik PIN baru (minimal 4 digit angka).
5. Klik **Simpan**.

---

## 🛠️ 3. Penanganan Masalah Saat Ujian (Troubleshooting)

1. **Koneksi Internet Putus Sementara**:
   - Moodle Elena secara otomatis menyimpan draft jawaban radio button / esai setiap beberapa menit.
   - Sambungkan kembali ke Wi-Fi, lalu tekan tombol **Reload** di status bar atas aplikasi.
   
2. **Mahasiswa Menggunakan HP iPhone**:
   - Jika mahasiswa belum memiliki aplikasi APK custom, minta mahasiswa membuka **App Store**, pasang **Safe Exam Browser** resmi, lalu buka kuis di Safari dan tekan tombol **Launch Safe Exam Browser**.

