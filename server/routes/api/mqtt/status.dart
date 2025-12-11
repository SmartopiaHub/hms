// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

// routes/signin.dart
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/logger.dart';
import 'package:smartopia_hms_server/mqtt.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _getStatus(context),
    HttpMethod.get => _getStatus(context), // Allow GET for testing purposes
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _getStatus(RequestContext context) async {
  try{
    final status = await MqttService.instance.connectionState;

    // Here you would typically fetch the MQTT status from your service
    // For demonstration, we return a mock status
    final mqttStatus = {
      'status': status.name,
      'timestamp': DateTime.now().toIso8601String(),
    };

    return Response.json(
      body: mqttStatus,
    );
  } catch (e, s) {
    logError(
      'Failed to retrieve MQTT status',
      e,
      s,
    );
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Failed to retrieve MQTT status: $e'},
    );
  }
}
