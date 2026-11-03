import 'package:flutter/material.dart';

class AppConstants {
  // --- Branding & Identity ---
  static const String appName = 'Elena SEB';
  static const String appFullName = 'Safe Exam Browser Elena STT-NF';
  static const String institutionName = 'STT Terpadu Nurul Fikri';
  static const String appVersion = '1.0.0';

  // --- LMS Configuration ---
  static const String defaultExamUrl = 'https://elena.nurulfikri.ac.id';
  static const String defaultLoginUrl = 'https://elena.nurulfikri.ac.id/login/index.php';
  
  // Whitelist hostnames allowed to load inside WebView
  static const List<String> allowedHosts = [
    'elena.nurulfikri.ac.id',
    'nurulfikri.ac.id',
    'accounts.google.com',     // If Google SSO is enabled on Elena
    'accounts.youtube.com',
  ];

  // Custom User-Agent to identify the official exam browser app to Moodle
  static const String customUserAgent =
      'Mozilla/5.0 (Linux; Android 14; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) '
      'Chrome/128.0.0.0 Safari/537.36 ElenaSEB/1.0 (STTNF-SecureExamBrowser; Mobile)';

  // --- Security & Exam Policy ---
  static const String defaultProctorPin = '194500';
  static const int defaultMaxViolations = 3;
  static const String prefProctorPinKey = 'elena_proctor_pin';
  static const String prefMaxViolationsKey = 'elena_max_violations';
  static const String prefCustomUrlKey = 'elena_custom_exam_url';

  // --- Theme Colors (STT NF Identity) ---
  static const Color primaryDark = Color(0xFF092540); // STT NF Dark Blue
  static const Color primaryBlue = Color(0xFF0D47A1); // Deep Navy
  static const Color accentGold = Color(0xFFF59E0B);  // Gold / Yellow
  static const Color accentCyan = Color(0xFF0284C7);  // Cyan
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color dangerRed = Color(0xFFDC2626);
  static const Color successGreen = Color(0xFF16A34A);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  // --- JavaScript Security Injection ---
  // Injected into WebView to disable text selection, right-click, copy, cut, paste, and inspect
  static const String securityInjectionScript = '''
    (function() {
      // 1. Disable text selection via CSS
      const style = document.createElement('style');
      style.type = 'text/css';
      style.innerHTML = `
        * {
          -webkit-touch-callout: none !important;
          -webkit-user-select: none !important;
          -khtml-user-select: none !important;
          -moz-user-select: none !important;
          -ms-user-select: none !important;
          user-select: none !important;
        }
        input, textarea, [contenteditable="true"] {
          -webkit-user-select: auto !important;
          user-select: auto !important;
        }
      `;
      document.head.appendChild(style);

      // 2. Disable context menu (right click & long press)
      document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
        return false;
      }, true);

      // 3. Disable copy, cut, paste events
      ['copy', 'cut', 'paste'].forEach(function(eventName) {
        document.addEventListener(eventName, function(e) {
          e.preventDefault();
          return false;
        }, true);
      });

      // 4. Disable keyboard shortcuts (Ctrl+C, Ctrl+V, Ctrl+U, Ctrl+S, Ctrl+P, F12)
      document.addEventListener('keydown', function(e) {
        if (e.ctrlKey || e.metaKey) {
          const blockedKeys = ['c', 'v', 'u', 's', 'p', 'a', 'x'];
          if (blockedKeys.includes(e.key.toLowerCase())) {
            e.preventDefault();
            return false;
          }
        }
        if (e.key === 'F12' || e.keyCode === 123) {
          e.preventDefault();
          return false;
        }
      }, true);

      // 5. Disable drag & drop
      document.addEventListener('dragstart', function(e) {
        e.preventDefault();
        return false;
      }, true);
    })();
  ''';
}

