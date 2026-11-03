# Panduan Lengkap Build Aplikasi Android (APK/AAB) & iPhone (IPA)
## Elena Safe Exam Browser (SEB) STT Terpadu Nurul Fikri

Dokumen ini berisi panduan teknis langkah demi langkah untuk melakukan kompilasi (*build*) aplikasi menjadi berkas instalasi siap pakai:
- **Android**: Berkas `.apk` (instalasi langsung) & `.aab` (Google Play Store).
- **iOS / iPhone**: Berkas `.ipa` / arsip Xcode (TestFlight, Ad-Hoc, atau App Store).

---

## 🛠️ 1. Persiapan Lingkungan Pengembangan

### Kebutuhan Sistem:
- **Sistem Operasi**: Windows 10/11, macOS (diperlukan jika ingin mem-build iOS), atau Linux.
- **Flutter SDK**: Versi `>= 3.19.0`.
- **Java Development Kit (JDK)**: OpenJDK 17.
- **Android Studio** + Android SDK Tools (Platform SDK 34, Build Tools 34.0.0).
- **Xcode** (Khusus macOS untuk kompilasi iOS).

### Verifikasi Lingkungan:
Jalankan perintah berikut di terminal:
```bash
flutter doctor
```
Pastikan centang hijau pada Android toolchain (dan Xcode jika menggunakan Mac).

---

## 🤖 2. Cara Build untuk Android (APK & AAB)

Masuk ke folder proyek aplikasi:
```bash
cd seb_mobile_app
```

### Langkah 2.1: Mengunduh Dependensi
```bash
flutter pub get
```

### Langkah 2.2 (Opsional): Membuat Keystore Rilis untuk Penandatanganan Resmi
Jika ingin merilis APK resmi yang ditandatangani digital oleh kampus STT-NF:
1. Jalankan perintah pembuat keystore di terminal:
   ```bash
   keytool -genkey -v -keystore ./android/app/elena-seb-release.jks -alias elena-seb -keyalg RSA -keysize 2048 -validity 10000
   ```
2. Buat berkas `android/key.properties` berisi:
   ```properties
   storePassword=kata_sandi_keystore_anda
   keyPassword=kata_sandi_alias_anda
   keyAlias=elena-seb
   storeFile=elena-seb-release.jks
   ```

### Langkah 2.3: Membangun Berkas APK
Pilih salah satu dari metode berikut:

#### Opsi A: APK Standar Universal (Paling Mudah Dibagikan)
Satu berkas APK yang dapat diinstal pada semua jenis ponsel Android:
```bash
flutter build apk --release
```
📍 **Lokasi Berkas Output**:
`seb_mobile_app/build/app/outputs/flutter-apk/app-release.apk`

#### Opsi B: APK Split Per-ABI (Ukuran Berkas Jauh Lebih Ringan ~15MB)
Menghasilkan APK yang disesuaikan dengan arsitektur prosesor (arm64 untuk HP modern):
```bash
flutter build apk --split-per-abi --release
```
📍 **Lokasi Berkas Output**:
- `app-arm64-v8a-release.apk` (Mayoritas ponsel Android modern)
- `app-armeabi-v7a-release.apk` (Ponsel Android lawas 32-bit)

#### Opsi C: Android App Bundle (AAB untuk Publikasi Google Play)
```bash
flutter build appbundle --release
```
📍 **Lokasi Berkas Output**:
`seb_mobile_app/build/app/outputs/bundle/release/app-release.aab`

---

## 🍎 3. Cara Build untuk iPhone / iPad (iOS)

> [!NOTE]
> Menurut kebijakan resmi Apple, kompilasi berkas binary iOS (`.ipa`) wajib dilakukan pada komputer berbasis **macOS** yang menjalankan **Xcode**.

### Langkah 3.1: Persiapan di Mac
Salin folder proyek `seb_mobile_app` ke komputer Mac Anda.

1. Buka terminal di Mac, masuk ke direktori proyek:
   ```bash
   cd seb_mobile_app
   flutter pub get
   ```
2. Pasang dependensi CocoaPods:
   ```bash
   cd ios
   pod install
   cd ..
   ```

### Langkah 3.2: Konfigurasi Apple Developer di Xcode
1. Buka berkas workspace di Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
2. Klik proyek root **Runner** pada navigator sebelah kiri.
3. Buka tab **Signing & Capabilities**.
4. Pada dropdown **Team**, pilih akun Apple Developer kampus atau akun pribadi pengembang.
5. Pastikan Bundle Identifier unik (misal: `id.ac.nurulfikri.elena.seb`).

### Langkah 3.3: Kompilasi IPA
Jalankan perintah Flutter di terminal:
```bash
flutter build ipa --release
```

📍 **Lokasi Berkas Output**:
`seb_mobile_app/build/ios/archive/Runner.xcarchive` dan `build/ios/ipa/*.ipa`

### Opsi Distribusi iOS ke Mahasiswa:
1. **Apple TestFlight**: Unggah berkas archive dari Xcode Organizer ke App Store Connect, lalu undang email mahasiswa (@nurulfikri.ac.id) sebagai tester.
2. **Apple Developer Enterprise / Ad-Hoc**: Pasang langsung berkas `.ipa` melalui profil sertifikat MDM kampus atau Apple Configurator.
3. **Alternatif Terbaik untuk iPhone Tanpa Akun Developer Berbayar**:
   Gunakan **Aplikasi Resmi Safe Exam Browser dari App Store** (gratis) yang dikombinasikan dengan berkas konfigurasi `Elena_STTNF_Exam.seb` (lihat panduan di folder `seb_official_config/`).

