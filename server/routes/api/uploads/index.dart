// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/model/database.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  return _uploadFile(context);
}

Future<Response> _uploadFile(RequestContext context) async {
  final user = context.read<User>();
  if (!user.isParent) {
    return Response(statusCode: HttpStatus.forbidden, body: 'Only parents can upload files');
  }

  final contentType = context.request.headers['content-type'];
  if (contentType == null || !contentType.contains('multipart/form-data')) {
    return Response(statusCode: HttpStatus.badRequest, body: 'Content-Type must be multipart/form-data');
  }

  final formData = await context.request.formData();
  final file = formData.files['file'];

  if (file == null) {
    return Response(statusCode: HttpStatus.badRequest, body: 'No file uploaded');
  }

  final uploadDir = Directory('./data/uploads');
  if (!await uploadDir.exists()) {
    await uploadDir.create(recursive: true);
  }

  final extension = p.extension(file.name);
  final filename = '${const Uuid().v4()}$extension';
  final filePath = p.join(uploadDir.path, filename);

  await File(filePath).writeAsBytes(await file.readAsBytes());

  // Construct the URL. Assuming the server serves static files from /data/uploads mapped to /uploads
  // We need to ensure the server is configured to serve these files.
  // For now, let's assume a route or middleware handles this.
  // If not, we might need to create a route to serve files.
  
  // Let's assume we'll create a route /api/uploads/[filename] to serve it.
  final fileUrl = '/api/uploads/$filename';

  return Response.json(body: {'url': fileUrl});
}
