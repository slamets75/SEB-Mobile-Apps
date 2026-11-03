import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants/app_constants.dart';
import '../services/security_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SecurityService _securityService = SecurityService();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  int _maxViolations = AppConstants.defaultMaxViolations;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString(AppConstants.prefProctorPinKey) ?? AppConstants.defaultProctorPin;
    final violations = prefs.getInt(AppConstants.prefMaxViolationsKey) ?? AppConstants.defaultMaxViolations;
    final url = prefs.getString(AppConstants.prefCustomUrlKey) ?? AppConstants.defaultExamUrl;

    setState(() {
      _pinController.text = pin;
      _maxViolations = violations;
      _urlController.text = url;
      _isLoading = false;
    });
  }

  Future<void> _savePin() async {
    final newPin = _pinController.text.trim();
    if (newPin.length < 4) {
      _showMessage('PIN minimal 4 digit angka!', isError: true);
      return;
    }
    final success = await _securityService.updateProctorPin(newPin);
    if (success) {
      _showMessage('PIN Pengawas berhasil diperbarui!');
    } else {
      _showMessage('Gagal menyimpan PIN.', isError: true);
    }
  }

  Future<void> _saveViolations(int value) async {
    setState(() => _maxViolations = value);
    await _securityService.setMaxViolations(value);
    _showMessage('Toleransi pelanggaran diatur ke $value kali.');
  }

  Future<void> _saveCustomUrl() async {
    final url = _urlController.text.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefCustomUrlKey, url.isEmpty ? AppConstants.defaultExamUrl : url);
    _showMessage('URL default berhasil diperbarui.');
  }

  Future<void> _clearBrowserCache() async {
    final controller = WebViewController();
    await controller.clearCache();
    await controller.clearLocalStorage();
    _showMessage('Cache dan sesi browser Elena berhasil dibersihkan.');
  }

  void _showMessage(String text, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: isError ? AppConstants.dangerRed : AppConstants.successGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppConstants.primaryBlue)),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Pengaturan Pengawas & Ujian',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppConstants.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Security PIN Section
          _buildCard(
            title: 'Keamanan PIN Pengawas',
            icon: Icons.pin_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PIN ini digunakan pengawas untuk mengizinkan mahasiswa keluar ujian atau membuka sesi yang terkunci.',
                  style: TextStyle(fontSize: 12, color: AppConstants.textMuted),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        decoration: InputDecoration(
                          labelText: 'PIN Pengawas',
                          counterText: '',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _savePin,
                      child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Violation Settings
          _buildCard(
            title: 'Toleransi Pelanggaran (Violation Limit)',
            icon: Icons.shield_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Batas toleransi mahasiswa beralih aplikasi sebelum ujian otomatis dikunci: $_maxViolations kali.',
                  style: const TextStyle(fontSize: 12, color: AppConstants.textMuted),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _maxViolations.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: '$_maxViolations kali',
                  activeColor: AppConstants.primaryBlue,
                  onChanged: (val) => _saveViolations(val.toInt()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('1x (Sangat Ketat)', style: TextStyle(fontSize: 11, color: AppConstants.textMuted)),
                    Text('3x (Standar NF)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppConstants.primaryBlue)),
                    Text('5x (Longgar)', style: TextStyle(fontSize: 11, color: AppConstants.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // URL Configuration
          _buildCard(
            title: 'URL Utama LMS Elena',
            icon: Icons.link_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tautan dasar Elena Moodle yang akan dimuat saat tombol "Mulai Ujian" ditekan.',
                  style: TextStyle(fontSize: 12, color: AppConstants.textMuted),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          labelText: 'URL Server Elena',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _saveCustomUrl,
                      child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Maintenance & Clear Data
          _buildCard(
            title: 'Pembersihan Data Sesi',
            icon: Icons.cleaning_services_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hapus cookie dan sesi login Elena jika mahasiswa sebelumnya belum logout atau terjadi kendala cache halaman.',
                  style: TextStyle(fontSize: 12, color: AppConstants.textMuted),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppConstants.dangerRed,
                    side: const BorderSide(color: AppConstants.dangerRed),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                  label: const Text('Bersihkan Cache & Cookie Elena'),
                  onPressed: _clearBrowserCache,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // System Info Card
          _buildCard(
            title: 'Informasi Status Aplikasi',
            icon: Icons.info_outline_rounded,
            child: Column(
              children: [
                _buildInfoRow('Versi Aplikasi', AppConstants.appVersion),
                _buildInfoRow('Institusi', AppConstants.institutionName),
                _buildInfoRow('Target LMS', 'https://elena.nurulfikri.ac.id'),
                _buildInfoRow('FLAG_SECURE', 'Aktif (Anti Screenshot/Record)'),
                _buildInfoRow('Wakelock', 'Aktif (Layar Tidak Redup)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppConstants.primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textDark,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppConstants.textMuted)),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppConstants.textDark),
          ),
        ],
      ),
    );
  }
}

