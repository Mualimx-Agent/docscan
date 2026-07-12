import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  AppLanguage _appLanguage = AppLanguage.english;
  bool _darkMode = false;
  bool _hasSeenOnboarding = false;

  AppLanguage get appLanguage => _appLanguage;
  bool get darkMode => _darkMode;
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  String get localeCode {
    switch (_appLanguage) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.german:
        return 'de';
      case AppLanguage.arabic:
        return 'ar';
    }
  }

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('appLanguage') ?? 'en';
    _appLanguage = _parseLanguage(lang);
    _darkMode = prefs.getBool('darkMode') ?? false;
    _hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    _appLanguage = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appLanguage', _languageCode(lang));
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _hasSeenOnboarding = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    notifyListeners();
  }

  AppLanguage _parseLanguage(String code) {
    switch (code) {
      case 'de':
        return AppLanguage.german;
      case 'ar':
        return AppLanguage.arabic;
      default:
        return AppLanguage.english;
    }
  }

  String _languageCode(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.german:
        return 'de';
      case AppLanguage.arabic:
        return 'ar';
    }
  }
}

enum AppLanguage { english, german, arabic }