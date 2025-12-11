// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  // Construct the path to the client file
  const fileName = 'smartopia_learning_macos_latest.dmg';
  const filePath = 'data/clients/$fileName';
  final file = File(filePath);

  // Check if file exists
  if (!file.existsSync()) {
    return Response(statusCode: HttpStatus.notFound, body: 'File not found');
  }

  // Read file as bytes
  final bytes = await file.readAsBytes();

  // Determine content type based on file extension
  const contentType = 'application/zip';

  // Return file with appropriate headers
  return Response.bytes(
    body: bytes,
    headers: {
      'Content-Type': contentType,
      'Content-Disposition': 'attachment; filename="$fileName"',
      'Content-Length': bytes.length.toString(),
    },
  );
}
