@echo off
title Build Elena SEB Mobile APK via Docker (Tanpa Android Studio)
color 0a

echo ======================================================================
echo   Build Elena Safe Exam Browser APK Menggunakan Docker
echo   (Solusi Otomatis Tanpa Perlu Memasang Android Studio)
echo ======================================================================
echo.

:: Cek apakah Docker berjalan
docker ps >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Docker Desktop belum berjalan!
    echo Harap buka aplikasi Docker Desktop di Windows terlebih dahulu.
    pause
    exit /b 1
)

echo [1/3] Docker Desktop terdeteksi aktif.
echo [2/3] Menjalankan container Flutter untuk kompilasi APK...
echo       (Proses unduh image container Flutter dilakukan otomatis pada build pertama)
echo.

cd /d "%~dp0..\seb_mobile_app"

docker run --rm -v "%CD%:/app" -w /app ghcr.io/cirruslabs/flutter:stable bash -c "git config --global --add safe.directory /app && flutter pub get && flutter build apk --release"

if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERROR] Proses kompilasi APK via Docker mengalami kendala.
    echo Periksa pesan log di atas.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo ======================================================================
echo [3/3] BERHASIL! Berkas APK rilis telah selesai dibuat di:
echo %CD%\build\app\outputs\flutter-apk\app-release.apk
echo ======================================================================
echo.
pause

