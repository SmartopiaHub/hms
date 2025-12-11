// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

// routes/signin.dart
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/logger.dart';
import 'package:smartopia_hms_server/mqtt.dart';
import 'package:smartopia_hms_shared/shared.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _setConfig(context),
    HttpMethod.get => _getConfig(context), // Allow GET for testing purposes
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _getConfig(RequestContext context) async {
  try {
    // Retrieve the MQTT configuration
    final config = MqttService.instance.loadConfig();
    logInfo('MQTT configuration retrieved: $config');
    if (config == null) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'MQTT configuration not found'},
      );
    }

    return Response.json(
      body: config.toJson(),
    );
  } catch (e, s) {
    logError(
      'Failed to retrieve MQTT configuration',
      e,
      s,
    );
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Failed to retrieve MQTT configuration: $e'},
    );
  }
}

Future<Response> _setConfig(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final config = MqttConfig.fromJson(body);

    // Set the MQTT configuration
    MqttService.instance.saveConfig(config);
    logInfo('MQTT configuration set/updated: $config');

    return Response.json(
      body: {'message': 'MQTT configuration set/updated successfully'},
    );
  } catch (e, s) {
    logError(
      'Failed to set/update MQTT configuration',
      e,
      s,
    );
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Failed to set/update MQTT configuration: $e'},
    );
  }
}