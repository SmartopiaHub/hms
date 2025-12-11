// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mime/mime.dart';

Future<Response> onRequest(RequestContext context, String id) async {

  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  // get filename from query parameters
  final queryParams = context.request.uri.queryParameters;
  if (!queryParams.containsKey('filename')) {
    return Response(statusCode: HttpStatus.badRequest, body: 'Filename is required');
  }
  final filename = queryParams['filename'];
  if (filename == null || filename.isEmpty) {
    return Response(statusCode: HttpStatus.badRequest, body: 'Filename is required');
  }

  // get the filename from the request body
  /*final body = await context.request.json() as Map<String, dynamic>;
  final filename = body['filename'] as String?;
  if (filename == null || filename.isEmpty) {
    return Response(statusCode: HttpStatus.badRequest, body: 'Filename is required');
  }*/

  final file = File('data/uploads/$filename');
  if (!file.existsSync()) {
    return Response(statusCode: HttpStatus.notFound, body: 'File not found');
  }

  // figure out a mime-type (fallback to binary)
  final contentType = lookupMimeType(file.path) ?? 'application/octet-stream';
  final length = await file.length();

  return Response.stream(
    headers: {
      HttpHeaders.contentTypeHeader: contentType,
      HttpHeaders.contentLengthHeader: '$length',
      // this header makes the browser pop a “Save as…” dialog
      HttpHeaders.contentDisposition:
          'attachment; filename="${Uri.encodeComponent(filename)}"',
    },
    // stream the file directly
    body: file.readAsBytes().asStream(),
  );
}