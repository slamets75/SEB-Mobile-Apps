# PowerShell Script: Setup Flutter & Android SDK untuk Elena SEB Mobile
# STT Terpadu Nurul Fikri

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Pemeriksaan & Setup Lingkungan Build Elena SEB Mobile   " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Cek Git
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Git terdeteksi: $(git --version)" -ForegroundColor Green
} else {
    Write-Host "[X] Git belum terpasang. Mengunduh via Winget..." -ForegroundColor Yellow
    winget install --id Git.Git -e --source winget
}

# 2. Cek Java JDK 17
if (Get-Command java -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Java terdeteksi." -ForegroundColor Green
} else {
    Write-Host "[INFO] Memasang Microsoft OpenJDK 17..." -ForegroundColor Yellow
    winget install --id Microsoft.OpenJDK.17 -e --source winget
}

# 3. Cek Flutter
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    Write-Host "[OK] Flutter terdeteksi: $(flutter --version | Select-Object -First 1)" -ForegroundColor Green
} else {
    Write-Host "[PERINGATAN] Flutter SDK belum ada di PATH." -ForegroundColor Yellow
    Write-Host "Anda dapat memasang Flutter otomatis dengan perintah:" -ForegroundColor White
    Write-Host "  winget install --id Google.Flutter -e --source winget" -ForegroundColor Cyan
    Write-Host "Atau unduh manual dari: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor White
}

Write-Host "`nSetelah Flutter terpasang, jalankan:" -ForegroundColor Cyan
Write-Host "  cd seb_mobile_app" -ForegroundColor White
Write-Host "  flutter doctor" -ForegroundColor White
Write-Host "  flutter build apk --release" -ForegroundColor Green

