// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'utility.dart';

class AppConfig extends ChangeNotifier {
  ThemeMode _themeMode;
  Locale _locale;

  AppConfig({
    ThemeMode themeMode = ThemeMode.light,
    Locale locale = const Locale('en', 'US'),
  }) : _themeMode = themeMode,
       _locale = locale;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', mode == ThemeMode.dark);
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.toString());
  }

  static Future<AppConfig> load() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    final localeStr = prefs.getString('locale') ?? 'en';
    final parts = localeStr.split('_');
    final locale = Locale(parts[0], parts.length > 1 ? parts[1] : null);
    return AppConfig(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      locale: locale,
    );
  }

  bool _pointSystemEnabled = true;
  bool _isLoading = false;

  bool get pointSystemEnabled => _pointSystemEnabled;
  bool get isLoading => _isLoading;

  Future<void> loadConfig() async {
    _isLoading = true;
    notifyListeners();

    try {
      final config = await apiService.getConfig();
      if (config != null) {
        _pointSystemEnabled = config['pointSystemEnabled'] as bool? ?? true;

        // Set global server time zone
        if (config['serverTimeZone'] != null) {
          serverTimeZone = config['serverTimeZone'] as String;
        }
      }
    } catch (e) {
      // Default to enabled if error
      _pointSystemEnabled = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updatePointSystemEnabled(bool enabled) async {
    try {
      final success = await apiService.updateConfig({
        'pointSystemEnabled': enabled,
      });

      if (success) {
        _pointSystemEnabled = enabled;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
