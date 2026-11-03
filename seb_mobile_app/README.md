# Elena Safe Exam Browser (SEB) Mobile - STT Terpadu Nurul Fikri

Aplikasi Mobile Safe Exam Browser (SEB) resmi untuk portal LMS Elena STT-NF (`https://elena.nurulfikri.ac.id`), dirancang khusus untuk platform **Android** dan **iOS (iPhone/iPad)** guna menjamin integritas dan keamanan pelaksanaan ujian daring (UTS/UAS/Kuis).

---

## 🛡️ Fitur Keamanan & Anti-Kecurangan

1. **Anti-Screenshot & Screen Recording**:
   - **Android**: Mengaktifkan `WindowManager.LayoutParams.FLAG_SECURE` sehingga tangkapan layar, perekam layar pihak ketiga, dan preview di recent apps switcher otomatis menjadi hitam/terblokir.
   - **iOS**: Overlay otomatis saat aplikasi beralih ke App Switcher dan deteksi `UIScreen.capturedDidChangeNotification` saat screen recording atau mirroring aktif.

2. **Deteksi Perpindahan Aplikasi (Violation Counter)**:
   - Mendeteksi saat mahasiswa meminimalkan aplikasi, membuka split-screen, floating apps, atau menarik panel notifikasi.
   - Menghitung jumlah pelanggaran (`x/3`).
   - Memberikan pop-up peringatan keras. Jika mencapai batas maksimal (default 3x), ujian otomatis terkunci dan hanya bisa dibuka kembali oleh Pengawas.

3. **Kiosk Immersive Mode**:
   - Status bar dan tombol navigasi sistem (Back, Home, Recent) disembunyikan menggunakan mode `immersiveSticky`.
   - Tombol *Back* diintersepsi agar mahasiswa tidak bisa keluar tanpa sengaja.

4. **PIN Pengawas (Proctor Authorization)**:
   - Keluar dari sesi ujian wajib memasukkan 6-digit PIN Pengawas (Default: `194500`).
   - Menu pengaturan konfigurasi dilindungi dengan PIN Pengawas.

5. **Anti-Copy & Paste (JavaScript Injection)**:
   - Blokir seleksi teks (`user-select: none`).
   - Blokir menu konteks klik kanan / *long-press*.
   - Blokir shortcut keyboard (Ctrl+C, Ctrl+V, dsb).
   - Blokir *drag-and-drop*.

6. **Domain Whitelist Lockdown**:
   - Hanya mengizinkan navigasi di domain `*.elena.nurulfikri.ac.id` dan OAuth SSO yang sah. Tautan eksternal otomatis dicegah.

7. **Pemindai QR Code Ujian**:
   - Mahasiswa dapat memindai QR Code kuis langsung di papan tulis kelas untuk membuka soal ujian tanpa mengetik URL panjang.

---

## 📱 Panduan Menjalankan & Membangun Aplikasi

### Prasyarat
1. **Flutter SDK**: Versi 3.19.0 ke atas.
2. **Java JDK**: JDK 17.
3. **Android Studio** (untuk build Android APK/AAB).
4. **Xcode & macOS** (khusus untuk build iOS/iPhone).

### 1. Persiapan Dependensi
Masuk ke direktori `seb_mobile_app`:
```bash
cd seb_mobile_app
flutter pub get
```

### 2. Menjalankan di Mode Debug
- **Android Device / Emulator**:
  ```bash
  flutter run -d android
  ```
- **iPhone Simulator / Device**:
  ```bash
  flutter run -d ios
  ```

### 3. Membangun Berkas Rilis Android (APK & AAB)
- **Membangun APK Rilis Langsung (Siap Dibagikan ke Mahasiswa)**:
  ```bash
  flutter build apk --release
  ```
  *File APK akan berada di:* `build/app/outputs/flutter-apk/app-release.apk`

- **Membangun Split Per-ABI APK (Ukuran lebih kecil: arm64-v8a, armeabi-v7a)**:
  ```bash
  flutter build apk --split-per-abi --release
  ```

- **Membangun App Bundle (AAB untuk Google Play Store)**:
  ```bash
  flutter build appbundle --release
  ```

### 4. Membangun Berkas Rilis iOS (iPhone/iPad)
1. Buka folder `ios` di Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
2. Pilih akun Apple Developer pada tab **Signing & Capabilities**.
3. Di terminal:
   ```bash
   flutter build ipa --release
   ```
4. Atau gunakan menu **Product > Archive** di Xcode untuk mendistribusikan melalui TestFlight atau Ad-Hoc / Enterprise.

---

## ⚙️ Kredensial Default Pengawas
- **Default PIN Pengawas**: `194500`
- **Batas Toleransi Pelanggaran**: `3 kali`
- *Dapat diubah kapan saja melalui ikon roda gigi di pojok kanan atas layar utama.*

