import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/security_service.dart';

enum ProctorAction { exitExam, unlockSession, openSettings }

class ProctorPinDialog extends StatefulWidget {
  final ProctorAction action;
  final VoidCallback onSuccess;

  const ProctorPinDialog({
    super.key,
    required this.action,
    required this.onSuccess,
  });

  static Future<bool?> show(
    BuildContext context, {
    required ProctorAction action,
    required VoidCallback onSuccess,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ProctorPinDialog(action: action, onSuccess: onSuccess),
    );
  }

  @override
  State<ProctorPinDialog> createState() => _ProctorPinDialogState();
}

class _ProctorPinDialogState extends State<ProctorPinDialog> {
  final TextEditingController _pinController = TextEditingController();
  final SecurityService _securityService = SecurityService();
  bool _isObscure = true;
  String? _errorMessage;
  bool _isVerifying = false;

  String get _dialogTitle {
    switch (widget.action) {
      case ProctorAction.exitExam:
        return 'Keluar dari Ujian';
      case ProctorAction.unlockSession:
        return 'Buka Kunci Ujian';
      case ProctorAction.openSettings:
        return 'Pengaturan Pengawas';
    }
  }

  String get _dialogSubtitle {
    switch (widget.action) {
      case ProctorAction.exitExam:
        return 'Masukkan PIN Pengawas untuk mengakhiri sesi ujian mahasiswa.';
      case ProctorAction.unlockSession:
        return 'Ujian terkunci karena mencapai batas pelanggaran. Diperlukan PIN Pengawas untuk melanjutkan.';
      case ProctorAction.openSettings:
        return 'Masukkan PIN Pengawas untuk mengakses pengaturan aplikasi.';
    }
  }

  Future<void> _handleVerify() async {
    final pin = _pinController.text.trim();
    if (pin.isEmpty) {
      setState(() => _errorMessage = 'Harap masukkan PIN Pengawas.');
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    final isValid = await _securityService.verifyProctorPin(pin);

    if (!mounted) return;

    if (isValid) {
      Navigator.of(context).pop(true);
      widget.onSuccess();
    } else {
      setState(() {
        _isVerifying = false;
        _errorMessage = 'PIN Pengawas salah! Silakan periksa kembali.';
        _pinController.clear();
      });
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 10,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: AppConstants.primaryBlue,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _dialogTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textDark,
                        ),
                      ),
                      const Text(
                        'Otorisasi Pengawas',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _dialogSubtitle,
              style: const TextStyle(fontSize: 13, color: AppConstants.textMuted, height: 1.4),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: _isObscure,
              maxLength: 8,
              textAlign: TextAlign.center,
              autofocus: true,
              style: const TextStyle(
                fontSize: 22,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryDark,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: '••••••',
                hintStyle: TextStyle(
                  letterSpacing: 8,
                  color: Colors.grey.shade400,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppConstants.primaryBlue, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                    color: AppConstants.textMuted,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _isObscure = !_isObscure),
                ),
              ),
              onSubmitted: (_) => _handleVerify(),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppConstants.dangerRed,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                if (widget.action != ProctorAction.unlockSession)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Batal', style: TextStyle(color: AppConstants.textMuted)),
                    ),
                  ),
                if (widget.action != ProctorAction.unlockSession)
                  const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isVerifying ? null : _handleVerify,
                    child: _isVerifying
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Verifikasi',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Default PIN: 194500 (dapat diubah di Pengaturan)',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

