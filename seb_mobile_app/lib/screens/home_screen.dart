import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../widgets/proctor_pin_dialog.dart';
import 'exam_screen.dart';
import 'qr_scanner_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _targetUrl = AppConstants.defaultExamUrl;

  @override
  void initState() {
    super.initState();
    _loadCustomUrl();
  }

  Future<void> _loadCustomUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final customUrl = prefs.getString(AppConstants.prefCustomUrlKey);
    if (customUrl != null && customUrl.isNotEmpty) {
      setState(() => _targetUrl = customUrl);
    }
  }

  void _launchExam([String? url]) {
    final finalUrl = url ?? _targetUrl;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ExamScreen(initialUrl: finalUrl),
      ),
    );
  }

  void _openQrScanner() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const QRScannerScreen(),
      ),
    );
  }

  void _openSupervisorSettings() {
    ProctorPinDialog.show(
      context,
      action: ProctorAction.openSettings,
      onSuccess: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const SettingsScreen(),
          ),
        ).then((_) => _loadCustomUrl());
      },
    );
  }

  void _showCustomUrlDialog() {
    final controller = TextEditingController(text: _targetUrl);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Masukkan Link Kuis Elena'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Jika pengawas memberikan tautan langsung ke kuis tertentu, tempelkan di bawah ini:',
              style: TextStyle(fontSize: 12, color: AppConstants.textMuted),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'https://elena.nurulfikri.ac.id/mod/quiz/...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryBlue,
            ),
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(ctx).pop();
                _launchExam(text);
              }
            },
            child: const Text('Buka Ujian', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryDark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: AppConstants.accentGold,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            AppConstants.appName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryDark,
                            ),
                          ),
                          Text(
                            AppConstants.institutionName,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppConstants.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_rounded, color: AppConstants.primaryBlue),
                    tooltip: 'Pengaturan Pengawas',
                    onPressed: _openSupervisorSettings,
                  ),
                ],
              ),
            ),

            // Main Content Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hero Banner Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppConstants.primaryDark, AppConstants.primaryBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.primaryBlue.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppConstants.accentGold,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'PORTAL UJIAN RESMI STT-NF',
                              style: TextStyle(
                                color: AppConstants.primaryDark,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Safe Exam Browser\nElena LMS Mobile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Browser ujian berkeamanan tinggi untuk Ujian Tengah Semester (UTS) & Ujian Akhir Semester (UAS).',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Primary Launch Button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.play_circle_fill_rounded, size: 24, color: AppConstants.accentGold),
                      label: const Text(
                        'MULAI UJIAN ELENA',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                      onPressed: () => _launchExam(),
                    ),
                    const SizedBox(height: 12),

                    // Secondary Action Buttons (QR Scanner & Custom URL)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppConstants.primaryDark,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.qr_code_scanner_rounded, size: 20, color: AppConstants.primaryBlue),
                            label: const Text(
                              'Scan QR Kuis',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            onPressed: _openQrScanner,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppConstants.primaryDark,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.link_rounded, size: 20, color: AppConstants.primaryBlue),
                            label: const Text(
                              'Input URL',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            onPressed: _showCustomUrlDialog,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Readiness Checklist
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.verified_user_rounded, color: AppConstants.successGreen, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Kesiapan Sistem Perangkat',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.textDark,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          _buildCheckItem(
                            icon: Icons.shield_rounded,
                            title: 'Proteksi Anti-Screenshot Aktif',
                            desc: 'Mencegah tangkapan layar & rekaman video',
                            isReady: true,
                          ),
                          _buildCheckItem(
                            icon: Icons.lock_clock_rounded,
                            title: 'Sistem Deteksi Pindah Aplikasi Aktif',
                            desc: 'Mencatat jika mahasiswa meminimalkan layar',
                            isReady: true,
                          ),
                          _buildCheckItem(
                            icon: Icons.wifi_rounded,
                            title: 'Koneksi Server Elena STT-NF',
                            desc: 'Tersambung ke https://elena.nurulfikri.ac.id',
                            isReady: true,
                          ),
                          _buildCheckItem(
                            icon: Icons.battery_charging_full_rounded,
                            title: 'Daya Baterai',
                            desc: 'Pastikan daya baterai mencukupi selama ujian',
                            isReady: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Exam Rules Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.rule_rounded, color: AppConstants.accentGold, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Tata Tertib Ujian Digital STT-NF',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.primaryDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '1. Dilarang menutup aplikasi atau beralih ke aplikasi lain selama ujian.\n'
                            '2. Setiap tindakan keluar dari layar ujian akan tercatat sebagai pelanggaran.\n'
                            '3. Jika pelanggaran mencapai batas maksimum, ujian akan otomatis terkunci.\n'
                            '4. Untuk keluar dari aplikasi setelah selesai, hubungi Pengawas Ruangan.',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppConstants.textDark,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Footer
                    Center(
                      child: Text(
                        '© 2026 STT Terpadu Nurul Fikri • Elena Safe Exam Browser v${AppConstants.appVersion}',
                        style: const TextStyle(fontSize: 11, color: AppConstants.textMuted),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem({
    required IconData icon,
    required String title,
    required String desc,
    required bool isReady,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isReady ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isReady ? AppConstants.successGreen : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textDark,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 11, color: AppConstants.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

