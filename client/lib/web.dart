// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

Future<void> setRefreshOrCloseEventFlag() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('refresh_or_close_event', true);
}

Future<bool> getRefreshOrCloseEventFlag() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool('refresh_or_close_event') ?? false;
}

Future<void> resetRefreshOrCloseEventFlag() async {
  var prefs = await SharedPreferences.getInstance();
  await prefs.setBool('refresh_or_close_event', false);
}

Future<void> _saveCurrentPage(String? routeName) async {
    if (routeName == null) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('current_page_time', DateTime.now().toIso8601String());
    prefs.setString('current_page', routeName);
    debugPrint('Saved current page: $routeName');
}

Future<void> initIfWeb() async {
  // only on the web
  if (kIsWeb) {
    // Listen for the refresh or close event
    html.window.onBeforeUnload.listen((event) async {
      event.preventDefault();
      debugPrint('Event $event');
      final url = html.window.location.href;
      final path = html.window.location.pathname;
      await _saveCurrentPage(path);
      debugPrint('URL: $url, Path: $path');
      await setRefreshOrCloseEventFlag();
      //debugPrint('Page refresh or close detected');
      // Handle the refresh or close event
    });
  }
}