# Safe Exam Browser (SEB) Elena Mobile - STT Terpadu Nurul Fikri
**Platform: Android & iOS (iPhone/iPad)**  
**Target LMS: [elena.nurulfikri.ac.id](https://elena.nurulfikri.ac.id)**

Repository ini berisi solusi lengkap Safe Exam Browser (SEB) untuk pelaksanaan ujian digital terpadu (UTS, UAS, dan Kuis) di lingkungan STT Terpadu Nurul Fikri:
1. **Aplikasi Mobile Custom (Flutter)** untuk Android & iOS dengan proteksi anti-kecurangan lengkap.
2. **Berkas Konfigurasi Resmi SEB (`.seb`)** untuk integrasi langsung dengan modul Moodle Quiz Elena dan aplikasi resmi Safe Exam Browser di App Store & Play Store.
3. **Dokumentasi Lengkap** untuk Dosen, Pengawas, dan Mahasiswa.

---

## 📁 Struktur Repositori

```
SEB Mobile Elena/
├── scripts/                          # Skrip Otomasi Build & Setup Windows
│   ├── build_android.bat             # Skrip satu klik build APK release Android
│   ├── setup_flutter_windows.ps1     # Skrip deteksi & panduan pasang Flutter
│   └── open_simulator.bat            # Skrip satu klik buka simulator interaktif
│
├── web_preview/                      # Simulator Interaktif Web (Demo & Testing)
│   └── index.html                    # Mockup smartphone & simulasi fitur keamanan
│
├── seb_mobile_app/                   # Source Code Lengkap Aplikasi Mobile (Flutter)
│   ├── android/                      # Konfigurasi Native Android (FLAG_SECURE, Kiosk)
│   ├── ios/                          # Konfigurasi Native iOS (Privacy Overlay, ATS)
│   ├── lib/
│   │   ├── constants/                # Tema STT NF, URL Whitelist, Script Injeksi JS
│   │   ├── services/                 # Manajemen Pelanggaran, PIN Pengawas, Keamanan
│   │   ├── screens/                  # Home, Exam WebView, QR Scanner, Settings
│   │   └── widgets/                  # Modal Dialog PIN Pengawas
│   ├── assets/                       # Aset Grafis & Logo STT NF
│   ├── pubspec.yaml                  # Dependensi Flutter
│   └── README.md                     # Panduan Teknis Aplikasi Mobile
│
├── seb_official_config/              # Konfigurasi Resmi Safe Exam Browser Moodle
│   ├── Elena_STTNF_Exam.seb          # Berkas XML/Plist SEB siap pakai untuk Elena
│   └── README_SEB_OFFICIAL.md        # Panduan Dosen/Admin untuk Kuis Moodle SEB
│
├── docs/                             # Panduan Operasional & Dokumentasi
│   ├── CARA_BUILD_APK_DAN_IPA.md     # Panduan Kompilasi APK (Android) & IPA (iOS)
│   ├── PANDUAN_MAHASISWA_ANDROID_IOS.md # Tata Cara Ujian Mahasiswa
│   └── PANDUAN_PENGGUNAAN_DOSEN.md   # Prosedur Dosen & Pengawas Ruangan
│
└── README.md                         # Dokumen Ringkasan Ini
```

---

## 🔒 Fitur Keamanan Aplikasi Mobile

| Fitur Keamanan | Implementasi di Android | Implementasi di iOS (iPhone) |
|---|---|---|
| **Anti-Screenshot & Recording** | `FLAG_SECURE` di Window Manager (Layar otomatis hitam pekat) | Overlay Privacy saat App Switcher + Notifikasi screen capture |
| **Kiosk & Fullscreen Mode** | `immersiveSticky` (Status bar & Nav bar tersembunyi) | Kiosk UI + Dukungan Guided Access / ASAM |
| **Deteksi Pindah Aplikasi** | `WidgetsBindingObserver` menghitung pelanggaran (`x/3`) | Menghitung pelanggaran saat berpindah layar / multi-window |
| **Otomatis Kunci Ujian** | Terkunci jika pelanggaran mencapai batas (butuh PIN) | Terkunci jika pelanggaran mencapai batas (butuh PIN) |
| **Anti-Copy Paste** | Injeksi JavaScript: Nonaktifkan seleksi teks, klik kanan, copy | Injeksi JavaScript: Nonaktifkan seleksi teks, menu pop-up |
| **Domain Whitelist** | Terkunci ke `elena.nurulfikri.ac.id`, blokir tautan luar | Terkunci ke `elena.nurulfikri.ac.id`, blokir tautan luar |
| **PIN Pengawas Ruangan** | Wajib memasukkan PIN untuk keluar atau membuka ujian terkunci | Wajib memasukkan PIN untuk keluar atau membuka ujian terkunci |
| **Pemindai QR Code** | Terintegrasi kamera untuk langsung membuka URL kuis spesifik | Terintegrasi kamera untuk langsung membuka URL kuis spesifik |

---

## 🔑 Kredensial Pengawas Bawaan
- **PIN Pengawas Default**: `194500`
- **Batas Toleransi Pelanggaran**: `3 kali`
- *PIN dapat diubah oleh pengawas/admin melalui menu pengaturan berlogo roda gigi di layar utama.*

---

## 🚀 Ringkasan Cara Memulai Cepat

### 1. Untuk Administrator / Pengembang (Build APK / IPA)
```bash
cd seb_mobile_app
flutter pub get

# Build APK Android:
flutter build apk --release

# Build iOS (di macOS):
flutter build ipa --release
```
Panduan detail pembuatan keystore dan signing dapat dilihat di [docs/CARA_BUILD_APK_DAN_IPA.md](file:///d:/Documents/Project/STTNF/SEB%20Mobile%20Elena/docs/CARA_BUILD_APK_DAN_IPA.md).

### 2. Untuk Dosen Pengampu Ujian
1. Buat kuis di [elena.nurulfikri.ac.id](https://elena.nurulfikri.ac.id).
2. Di bagian **Safe Exam Browser**, aktifkan opsi `Yes – Configure manually` atau unggah berkas [Elena_STTNF_Exam.seb](file:///d:/Documents/Project/STTNF/SEB%20Mobile%20Elena/seb_official_config/Elena_STTNF_Exam.seb).
3. Bagikan QR Code kuis di papan tulis kelas untuk dipindai mahasiswa melalui tombol **"Scan QR Kuis"**.
4. Baca panduan lengkap di [docs/PANDUAN_PENGGUNAAN_DOSEN.md](file:///d:/Documents/Project/STTNF/SEB%20Mobile%20Elena/docs/PANDUAN_PENGGUNAAN_DOSEN.md).

### 3. Untuk Mahasiswa Ujian
1. **Pengguna Android**: Pasang berkas `Elena-SEB-NF.apk` yang dibagikan panitia ujian.
2. **Pengguna iPhone**: Pasang aplikasi **Safe Exam Browser** resmi dari App Store, lalu buka kuis di Safari dan tekan **Launch Safe Exam Browser**.
3. Baca panduan lengkap di [docs/PANDUAN_MAHASISWA_ANDROID_IOS.md](file:///d:/Documents/Project/STTNF/SEB%20Mobile%20Elena/docs/PANDUAN_MAHASISWA_ANDROID_IOS.md).

