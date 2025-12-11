// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'local_storage.dart';

/// Returns the base URL for your backend:
///  • On Web: uses the current origin (scheme://host[:port])
///  • On Mobile/Desktop: reads the URL from secure storage under 'server_url'
/// Returns null if no value is stored on non-Web platforms.
Future<String?> getServerUrl() async {

  if (kIsWeb) {
    final uri = Uri.base;
    final portSegment = uri.hasPort ? ':${uri.port}' : '';
    return '${uri.scheme}://${uri.host}$portSegment';
  }
  
  final host = await read('server_host');
  final port = await read('server_port');
  
  if (host != null && port != null) {
    String? scheme = await read('server_scheme');
    if (scheme == null) {
      try {
        final configStr = await rootBundle.loadString('assets/app_config.json');
        final config = jsonDecode(configStr);
        scheme = config['scheme'];
      } catch (e) {
        // Fallback to http if config fails to load
        debugPrint('Error loading app_config.json: $e');
      }
    }
    scheme ??= 'http';
    return '$scheme://$host:$port';
  }
  
  return null;
}

class ServerErrorNotifier extends ChangeNotifier {
  String? _error;
  String? get error => _error;

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clear() => setError(null);
}