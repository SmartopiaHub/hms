// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

import 'package:smartopia_hms_server/handlers/client_handlers.dart';

Future<Response> onRequest(RequestContext context, String filename) async {
  if (filename == 'windows') return latestWindows(context);
  if (filename == 'macos') return latestMacos(context);
  if (filename == 'android') return latestAndroid(context);

  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    // Validate filename format to prevent directory traversal
    if (filename.contains('..') ||
        filename.contains('/') ||
        filename.contains('\\')) {
      return Response(
          statusCode: HttpStatus.badRequest, body: 'Invalid filename');
    }

    // Check if filename matches expected pattern
    final validPattern = RegExp(
        r'^smartopia_learning_(android|macos|windows)_\d+\.\d+\.\d+\.(apk|dmg|zip)$');
    if (!validPattern.hasMatch(filename)) {
      return Response(
          statusCode: HttpStatus.badRequest, body: 'Invalid filename format');
    }

    final file = File('data/clients/$filename');

    if (!file.existsSync()) {
      return Response(statusCode: HttpStatus.notFound, body: 'File not found');
    }

    // Determine content type based on file extension
    String contentType;
    if (filename.endsWith('.dmg')) {
      contentType = 'application/x-apple-diskimage';
    } else if (filename.endsWith('.apk')) {
      contentType = 'application/vnd.android.package-archive';
    } else if (filename.endsWith('.zip')) {
      contentType = 'application/zip';
    } else {
      contentType = 'application/octet-stream';
    }

    final bytes = await file.readAsBytes();

    return Response.bytes(
      body: bytes,
      headers: {
        HttpHeaders.contentTypeHeader: contentType,
        'content-disposition': 'attachment; filename="$filename"',
        HttpHeaders.contentLengthHeader: bytes.length.toString(),
      },
    );
  } catch (e) {
    return Response(
        statusCode: HttpStatus.internalServerError, body: 'Error: $e');
  }
}
