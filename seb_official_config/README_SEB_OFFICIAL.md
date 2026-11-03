# Panduan Integrasi Resmi Safe Exam Browser (SEB) di Moodle Elena STT-NF

Berkas ini memandu Administrator LMS dan Dosen STT Terpadu Nurul Fikri dalam mengaktifkan integrasi **Safe Exam Browser (SEB)** resmi pada kuis di portal **Elena** (`https://elena.nurulfikri.ac.id`), serta cara membukanya di **iPhone (iOS)** dan **Android**.

---

## 📋 Metode 1: Mengunggah Berkas Konfigurasi `.seb` ke Moodle Elena

Jika Dosen ingin memastikan mahasiswa menggunakan konfigurasi yang sudah ditentukan kampus:

1. Masuk ke Elena (`https://elena.nurulfikri.ac.id`) menggunakan akun Dosen/Admin.
2. Buka mata kuliah dan pilih kuis ujian (UTS/UAS) yang ingin diamankan.
3. Klik **Edit settings** (Pengaturan Kuis).
4. Gulir ke bagian **Safe Exam Browser**.
5. Pada pilihan **Require the use of Safe Exam Browser**, pilih:
   👉 **`Yes – Upload my own config`**
6. Unggah berkas `Elena_STTNF_Exam.seb` yang ada di folder ini.
7. Di bagian **Quit password**, masukkan: `194500` (atau kata sandi pengawas yang disepakati).
8. Simpan pengaturan kuis (**Save and return to course**).

---

## ⚙️ Metode 2: Konfigurasi Manual Langsung di Moodle Elena (`Configure manually`)

Jika Dosen tidak ingin mengunggah berkas `.seb`, Moodle Elena memiliki generator konfigurasi bawaan:

1. Di Pengaturan Kuis -> **Safe Exam Browser**, pilih:
   👉 **`Yes – Configure manually`**
2. Atur parameter berikut:
   - **User confirm quitting**: *Yes*
   - **Quit password**: `194500`
   - **Show reload button**: *Yes* (Penting jika koneksi mahasiswa sempat terputus)
   - **Show time**: *Yes*
   - **Show SEB taskbar**: *Yes*
   - **Allow spell checking**: *No*
   - **Enable URL filtering**: *Yes*
   - **Filter expressions**: `https://elena.nurulfikri.ac.id/*`
3. Simpan kuis. Mahasiswa yang membuka kuis akan langsung melihat tombol:
   - **"Download Safe Exam Browser"**
   - **"Launch Safe Exam Browser"**

---

## 📱 Cara Mahasiswa Mengakses Menggunakan iPhone (iOS)

Aplikasi resmi Safe Exam Browser telah tersedia secara resmi dan gratis di **Apple App Store**.

### Langkah Mahasiswa iPhone:
1. Buka **App Store** di iPhone / iPad.
2. Cari dan pasang: **"Safe Exam Browser"** (oleh *ETH Zurich / SEB Alliance*).
3. Buka browser Safari di iPhone, lalu login ke `https://elena.nurulfikri.ac.id`.
4. Buka kuis ujian yang telah diset SEB.
5. Ketuk tombol **"Launch Safe Exam Browser"** (atau buka berkas `Elena_STTNF_Exam.seb` yang dikirim dosen/pengawas).
6. iPhone akan otomatis meminta konfirmasi untuk mengaktifkan **Guided Access / Single App Mode**:
   - Layar terkunci pada halaman ujian.
   - Mahasiswa tidak bisa keluar, berganti aplikasi, atau screenshot.
7. Setelah selesai ujian, pengawas memasukkan password keluar: `194500`.

---

## 🤖 Cara Mahasiswa Mengakses Menggunakan Android

Untuk platform Android, mahasiswa memiliki dua pilihan:

### Pilihan A: Menggunakan Aplikasi Custom "Elena SEB NF" (Sangat Disarankan)
- Gunakan aplikasi Flutter yang telah dibuild (`Elena SEB NF`).
- Aplikasi ini sudah dioptimalkan untuk perangkat Android lokal (Xiaomi, Samsung, Oppo, Vivo, Realme) yang sering bermasalah dengan kiosk background-service.
- Dilengkapi pemindai QR Code, penghitung pelanggaran otomatis, dan anti-screenshot langsung.

### Pilihan B: Menggunakan Aplikasi Resmi Safe Exam Browser di Google Play Store
1. Buka **Google Play Store**, pasang **"Safe Exam Browser"**.
2. Unduh dan buka berkas `Elena_STTNF_Exam.seb`.
3. SEB akan mengunci layar Android dan memuat Elena LMS.

---

## 🔑 Kredensial Pengawas Bawaan
- **Quit / Exit Password**: `194500`
- **Hash SHA-256**: `3e4845dc6ebf44c73aa2debab0f29e143ff9e5431354ea172d58a861ca4af331`

