@echo off
title Build Elena SEB Mobile APK - STT Terpadu Nurul Fikri
color 0b

echo ===============================================================
echo   Membangun Elena Safe Exam Browser (SEB) APK untuk Android
echo   LMS Moodle: elena.nurulfikri.ac.id
echo ===============================================================
echo.

cd /d "%~dp0..\seb_mobile_app"

echo [1/3] Mengunduh dependensi Flutter...
call flutter pub get
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Gagal menjalankan flutter pub get. Pastikan Flutter SDK sudah terpasang.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo [2/3] Membangun APK Rilis Android...
call flutter build apk --release
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Build APK gagal. Periksa log kesalahan di atas.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo [3/3] SELESAI! Berkas APK berhasil dibuat di:
echo %CD%\build\app\outputs\flutter-apk\app-release.apk
echo.
pause

