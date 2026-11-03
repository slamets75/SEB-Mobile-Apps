import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../constants/app_constants.dart';

class ViolationRecord {
  final DateTime timestamp;
  final String reason;

  ViolationRecord({required this.timestamp, required this.reason});
}

class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  int _violationCount = 0;
  final List<ViolationRecord> _violationHistory = [];
  bool _isExamLocked = false;

  int get violationCount => _violationCount;
  List<ViolationRecord> get violationHistory => List.unmodifiable(_violationHistory);
  bool get isExamLocked => _isExamLocked;

  /// Initialize security measures when starting an exam
  Future<void> enableExamSecurity() async {
    try {
      // 1. Keep screen on (prevent device sleeping during quiz)
      await WakelockPlus.enable();
      // Note: FLAG_SECURE (anti-screenshot) is hard-enforced in MainActivity.kt
    } catch (e) {
      debugPrint('Error enabling exam security: $e');
    }
  }

  /// Disable security measures when exiting exam
  Future<void> disableExamSecurity() async {
    try {
      await WakelockPlus.disable();
    } catch (e) {
      debugPrint('Error disabling exam security: $e');
    }
  }

  /// Reset session violation state
  void resetExamSession() {
    _violationCount = 0;
    _violationHistory.clear();
    _isExamLocked = false;
  }

  /// Register a detected violation (e.g. app sent to background, floating app)
  /// Returns true if violation threshold has been reached and exam is now locked.
  bool registerViolation(String reason, int maxAllowed) {
    _violationCount++;
    _violationHistory.add(
      ViolationRecord(timestamp: DateTime.now(), reason: reason),
    );

    if (_violationCount >= maxAllowed) {
      _isExamLocked = true;
    }
    return _isExamLocked;
  }

  /// Unlock exam after supervisor enters valid PIN
  void unlockExam() {
    _isExamLocked = false;
  }

  /// Verify entered supervisor PIN
  Future<bool> verifyProctorPin(String enteredPin) async {
    final prefs = await SharedPreferences.getInstance();
    final storedPin = prefs.getString(AppConstants.prefProctorPinKey) ?? AppConstants.defaultProctorPin;
    return enteredPin.trim() == storedPin.trim();
  }

  /// Update supervisor PIN
  Future<bool> updateProctorPin(String newPin) async {
    if (newPin.trim().length < 4) return false;
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(AppConstants.prefProctorPinKey, newPin.trim());
  }

  /// Get max allowed violations
  Future<int> getMaxViolations() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConstants.prefMaxViolationsKey) ?? AppConstants.defaultMaxViolations;
  }

  /// Set max allowed violations
  Future<void> setMaxViolations(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefMaxViolationsKey, value);
  }

  /// Check whether a given URL is allowed to open inside the exam browser
  bool isUrlAllowed(String url) {
    try {
      final uri = Uri.parse(url);
      
      // Allow about:blank and data: URIs
      if (uri.scheme == 'about' || uri.scheme == 'data') {
        return true;
      }

      final host = uri.host.toLowerCase();
      if (host.isEmpty) return false;

      // Check against whitelisted hosts
      for (final allowed in AppConstants.allowedHosts) {
        if (host == allowed || host.endsWith('.$allowed')) {
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}

