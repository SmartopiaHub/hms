// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:async';
import 'dart:convert';

import 'api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

class NotificationService extends ChangeNotifier {
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  StreamSubscription<List<int>>? _subscription;
  bool _isConnected = false;
  String? _currentToken;

  bool get isConnected => _isConnected;

  /// Refresh the SSE connection
  Future<void> refresh() async {
    if (_currentToken != null) {
      await init(_currentToken!, true);
    }
  }

  /// Call once at app startup.
  Future<void> init(String bearerToken, [bool restart = true]) async {
    if (_subscription != null && !restart) return;
    _subscription?.cancel(); // Cancel any existing subscription

    _currentToken = bearerToken;
    _isConnected = false;
    notifyListeners();

    try {
      final client = http.Client();
      final baseUrl = await apiService.apiUrl;
      final request = http.Request('GET', Uri.parse('$baseUrl/notifications'));
      request.headers['Authorization'] = 'Bearer $bearerToken';
      request.headers['Accept'] = 'text/event-stream';
      request.headers['Cache-Control'] =
          'no-cache, no-store, must-revalidate, max-age=0';
      request.headers['Connection'] = 'keep-alive';
      request.headers['Pragma'] = 'no-cache';
      request.headers['Expires'] = '0';
      request.headers['X-Accel-Buffering'] = 'no';

      // Send the request without awaiting - this returns immediately
      final streamedResponse = await client
          .send(request)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('SSE connection timeout');
            },
          );

      if (streamedResponse.statusCode == 200) {
        _isConnected = true;
        notifyListeners();

        // Listen to raw byte chunks and store the subscription
        _subscription = streamedResponse.stream.listen(
          (bytes) {
            // Print raw bytes (UTF-8) as soon as they arrive.
            final chunkStr = utf8.decode(bytes, allowMalformed: true);
            final msg = jsonDecode(chunkStr);
            final type = msg['type'] ?? 'unknown';
            String title = 'Notification';
            String? description;
            Duration? autoCloseDuration;
            if (type == 'connected') {
              title = 'Connected to Notification Service';
              autoCloseDuration = const Duration(seconds: 3);
            } else {
              title = 'Notification: $title';
              description = msg['body'];
            }
            toastification.show(
              title: Text(title),
              description: description != null ? Text(description) : null,
              type: ToastificationType.info,
              autoCloseDuration: autoCloseDuration,
            );
          },
          onError: (error) {
            _isConnected = false;
            notifyListeners();
            toastification.show(
              type: ToastificationType.error,
              title: const Text('Error in SSE stream'),
              description: Text('$error'),
            );
          },
          onDone: () {
            _isConnected = false;
            notifyListeners();
          },
          cancelOnError: false,
        );
      } else {
        _isConnected = false;
        notifyListeners();
      }
    } catch (e) {
      _isConnected = false;
      notifyListeners();
    }
  }
}
