// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

// routes/sse.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/logger.dart';
import 'package:smartopia_hms_server/model/database.dart';

/// Helper function to encode JSON to SSE format
List<int> encodeJsonToIntList(Map<String, dynamic> data) {
  final jsonString = jsonEncode(data);
  return utf8.encode('$jsonString\n\n');
}

/// One StreamController per username
final _controllers = <String, StreamController<List<int>>>{};

StreamController<List<int>> _controllerFor(String user) {
  return _controllers.putIfAbsent(
    user,
    StreamController<List<int>>.broadcast,
  );
}

/// Called by your scheduler to push an event
void pushNotification(String user, Map<String, dynamic> data) {
  final ctrl = _controllerFor(user);
  if (!ctrl.isClosed) {
    ctrl.add(encodeJsonToIntList(data));
    print('Pushed notification to $user: ${data['type']}');
  }
}

/// Used by your SSE handler to get the stream
Stream<List<int>> notificationsFor(String user) {
  return _controllerFor(user).stream;
}

// Timer? _testtimer;

/// Route handler for GET /sse
Response onRequest(RequestContext context) {
  /*_testtimer?.cancel();
  _testtimer = Timer.periodic(const Duration(seconds: 10), (timer) {
    final user = context.read<User>();
    pushNotification(user.username, {
      'type': 'test',
      'title': 'Test Notification',
      'body': 'This is a test notification at ${DateTime.now()}',
    });
  });*/
  try {
    final user = context.read<User>();
    final controller = _controllerFor(user.username);
    final resp = Response.stream(
      // Pipe our SSE payload stream into the HTTP response body
      body: controller.stream,
      headers: {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache, no-store, must-revalidate, max-age=0',
        'Pragma': 'no-cache',
        'Expires': '0',
        'Connection': 'keep-alive',
        // Prevent proxies from buffering
        'X-Accel-Buffering': 'no',
      },
      bufferOutput: false, // Disable buffering to ensure real-time updates
    );

    // Send initial connection message to flush headers
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!controller.isClosed) {
        final message = jsonEncode({
          'type': 'connected',
          'timestamp': DateTime.now().toIso8601String(),
        });
        controller.add(utf8.encode('$message\n\n'));
      }
    });
    return resp;
  } catch (e) {
    logError('sse onRequest error: $e');
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Internal server error: $e'},
    );
  }
}
