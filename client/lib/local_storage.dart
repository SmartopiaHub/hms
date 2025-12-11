
// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:shared_preferences/shared_preferences.dart';

Future<void> save({required String key, required String? value}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value);
    }
  } catch (e) {
    print('Error saving to storage: $e');
  }
}

Future<String?> read(String key) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  } catch (e) {
    print('Error reading from storage: $e');
    return null;
  }
}

Future<void> delete(String key) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  } catch (e) {
    print('Error deleting from storage: $e');
  }
}

Future<void> clear() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  } catch (e) {
    print('Error clearing storage: $e');
  }
}
