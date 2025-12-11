// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:convert';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/logger.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getConfig(context);
    case HttpMethod.put:
      return _updateConfig(context);
    default:
      return Response(statusCode: 405);
  }
}

Future<Response> _getConfig(RequestContext context) async {
  try {
    final configFile = File('data/config.json');
    
    if (!await configFile.exists()) {
      // Return default config if file doesn't exist
      return Response.json(
        body: {'pointSystemEnabled': true},
      );
    }

    final content = await configFile.readAsString();
    if (content.isEmpty) {
      return Response.json(
        body: {'pointSystemEnabled': true},
      );
    }

    final config = jsonDecode(content) as Map<String, dynamic>;
    return Response.json(body: config);
  } catch (e, st) {
    logError('Failed to get config', e, st);
    return Response(
      statusCode: 500,
      body: 'Failed to get configuration: $e',
    );
  }
}

Future<Response> _updateConfig(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final configFile = File('data/config.json');
    
    // Ensure the data directory exists
    if (!await configFile.parent.exists()) {
      await configFile.parent.create(recursive: true);
    }

    // Read existing config if it exists
    Map<String, dynamic> config = {};
    if (await configFile.exists()) {
      final content = await configFile.readAsString();
      if (content.isNotEmpty) {
        config = jsonDecode(content) as Map<String, dynamic>;
      }
    }

    // Update config with new values
    config.addAll(body);

    // Write back to file
    await configFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(config),
    );

    logInfo('Config updated: $config');

    return Response.json(body: config);
  } catch (e, st) {
    logError('Failed to update config', e, st);
    return Response(
      statusCode: 500,
      body: 'Failed to update configuration: $e',
    );
  }
}
