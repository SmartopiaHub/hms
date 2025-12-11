// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:path/path.dart' as p;

Future<Response> onRequest(RequestContext context, String filename) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  // Sanitize filename to prevent directory traversal
  final sanitizedFilename = p.basename(filename);
  final filePath = p.join('./data/uploads', sanitizedFilename);
  final file = File(filePath);

  if (!await file.exists()) {
    return Response(statusCode: HttpStatus.notFound);
  }

  final bytes = await file.readAsBytes();
  
  // Determine content type based on extension
  final extension = p.extension(filename).toLowerCase();
  String contentType;
  switch (extension) {
    case '.jpg':
    case '.jpeg':
      contentType = 'image/jpeg';
      break;
    case '.png':
      contentType = 'image/png';
      break;
    case '.gif':
      contentType = 'image/gif';
      break;
    case '.webp':
      contentType = 'image/webp';
      break;
    default:
      contentType = 'application/octet-stream';
  }

  return Response.bytes(
    body: bytes,
    headers: {
      'Content-Type': contentType,
      'Cache-Control': 'public, max-age=31536000',
    },
  );
}
