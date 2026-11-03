import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants/app_constants.dart';
import '../services/security_service.dart';
import '../widgets/proctor_pin_dialog.dart';

class ExamScreen extends StatefulWidget {
  final String initialUrl;

  const ExamScreen({
    super.key,
    required this.initialUrl,
  });

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> with WidgetsBindingObserver {
  late final WebViewController _webViewController;
  final SecurityService _securityService = SecurityService();
  
  bool _isLoading = true;
  double _loadingProgress = 0.0;
  int _maxViolations = AppConstants.defaultMaxViolations;
  bool _isHeaderVisible = true;
  String _pageTitle = 'Memuat Halaman...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initExamSecurity();
    _initWebViewController();
  }

  Future<void> _initExamSecurity() async {
    _maxViolations = await _securityService.getMaxViolations();
    await _securityService.enableExamSecurity();
  }

  void _initWebViewController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(AppConstants.customUserAgent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) {
              setState(() => _loadingProgress = progress / 100.0);
            }
          },
          onPageStarted: (url) {
            if (mounted) {
              setState(() => _isLoading = true);
            }
          },
          onPageFinished: (url) async {
            if (!mounted) return;
            
            // Inject security JS script (disable copy/paste, contextmenu, select)
            await _webViewController.runJavaScript(AppConstants.securityInjectionScript);
            
            final title = await _webViewController.getTitle();
            setState(() {
              _isLoading = false;
              _pageTitle = title ?? 'Elena LMS';
            });
          },
          onNavigationRequest: (request) {
            final isAllowed = _securityService.isUrlAllowed(request.url);
            if (!isAllowed) {
              _showBlockedUrlSnackbar(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            debugPrint('WebResourceError: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Detect when the user minimizes the app, pulls down notifications, or switches apps
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      debugPrint('App sent to background or split-screen');
    } else if (state == AppLifecycleState.resumed) {
      _handleAppResumed();
    }
  }

  void _handleAppResumed() {
    final isLocked = _securityService.registerViolation(
      'Meninggalkan aplikasi ujian atau membuka aplikasi lain',
      _maxViolations,
    );

    setState(() {});

    if (isLocked) {
      _showExamLockedDialog();
    } else {
      _showViolationWarningDialog();
    }
  }

  void _showViolationWarningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: AppConstants.dangerRed, size: 28),
            SizedBox(width: 8),
            Text('Peringatan Pelanggaran!', style: TextStyle(color: AppConstants.dangerRed)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anda terdeteksi meninggalkan layar ujian (${_securityService.violationCount}/$_maxViolations kali).',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'Perhatian: Dilarang beralih aplikasi, membuka notifikasi, split-screen, atau floating apps selama ujian berlangsung.',
              style: TextStyle(fontSize: 13, color: AppConstants.textMuted),
            ),
            if (_securityService.violationCount >= _maxViolations - 1) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.dangerRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'PERINGATAN TERAKHIR! Satu pelanggaran lagi akan mengunci ujian Anda.',
                  style: TextStyle(
                    color: AppConstants.dangerRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Saya Mengerti & Lanjutkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showExamLockedDialog() {
    ProctorPinDialog.show(
      context,
      action: ProctorAction.unlockSession,
      onSuccess: () {
        setState(() {
          _securityService.unlockExam();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi ujian berhasil dibuka oleh Pengawas.'),
            backgroundColor: AppConstants.successGreen,
          ),
        );
      },
    );
  }

  void _showBlockedUrlSnackbar(String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Akses ke URL eksternal diblokir: $url'),
        backgroundColor: AppConstants.dangerRed,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _requestExitExam() {
    ProctorPinDialog.show(
      context,
      action: ProctorAction.exitExam,
      onSuccess: () async {
        await _securityService.disableExamSecurity();
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _securityService.disableExamSecurity();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _requestExitExam();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Minimalist Exam Topbar
              if (_isHeaderVisible)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryDark,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // STT NF Logo Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppConstants.accentGold,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'SEB NF',
                          style: TextStyle(
                            color: AppConstants.primaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Page Title & Safe Lock
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.lock_rounded, color: Colors.greenAccent, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _pageTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Violation Counter Badge
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _securityService.violationCount > 0
                              ? AppConstants.dangerRed
                              : Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _securityService.violationCount > 0
                                  ? Icons.warning_rounded
                                  : Icons.shield_rounded,
                              color: Colors.white,
                              size: 13,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_securityService.violationCount}/$_maxViolations',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Reload Button
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                        tooltip: 'Muat Ulang Halaman',
                        onPressed: () => _webViewController.reload(),
                      ),
                      // Proctor Exit Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.dangerRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        icon: const Icon(Icons.logout_rounded, size: 14),
                        label: const Text('Keluar', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        onPressed: _requestExitExam,
                      ),
                      // Toggle Header Visibility
                      IconButton(
                        icon: const Icon(Icons.expand_less_rounded, color: Colors.white70, size: 18),
                        tooltip: 'Sembunyikan Header',
                        onPressed: () => setState(() => _isHeaderVisible = false),
                      ),
                    ],
                  ),
                ),

              // Re-expand bar when header is hidden
              if (!_isHeaderVisible)
                InkWell(
                  onTap: () => setState(() => _isHeaderVisible = true),
                  child: Container(
                    width: double.infinity,
                    color: AppConstants.primaryDark.withOpacity(0.85),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: const Center(
                      child: Icon(Icons.expand_more_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ),

              // Loading Progress Bar
              if (_isLoading)
                LinearProgressIndicator(
                  value: _loadingProgress > 0 ? _loadingProgress : null,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppConstants.accentGold),
                  minHeight: 2.5,
                ),

              // Fullscreen Protected WebView
              Expanded(
                child: WebViewWidget(controller: _webViewController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

