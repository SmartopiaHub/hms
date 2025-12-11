// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

// routes/upload.dart

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:mime/mime.dart';
import 'package:smartopia_hms_server/model/database.dart';
import 'package:smartopia_hms_server/notification.dart';

/// A helper that reads a multipart/form-data request, 
/// saves any uploaded files to `uploads/`, and returns a JSON list of saved filenames.
Future<Response> onRequest(RequestContext context, String id) async {
  final request = context.request;

  // 1) Ensure this is a POST.
  if (request.method != HttpMethod.post) {
    return Response(statusCode: 405, body: 'Method Not Allowed');
  }

  // 2) Check Content-Type header.
  final contentType = request.headers['content-type'];
  if (contentType == null || !contentType.startsWith('multipart/form-data')) {
    return Response(
      statusCode: 400,
      body: 'Expected a multipart/form-data request',
    );
  }

  final task = await database.managers.tasks.filter((t) => t.id.equals(int.parse(id))).getSingleOrNull();
  if (task == null) {
    return Response(
      statusCode: 404,
      body: 'Task not found',
    );
  }

  final user = context.read<User>();
  if (!task.assignedUsers.contains(user.username)) {
    return Response(
      statusCode: 403,
      body: 'You are not allowed to submit for this task',
    );
  }

  // 3) Extract boundary from contentType, e.g. "multipart/form-data; boundary=----WebKitFormBoundaryXYZ"
  final boundary = _parseBoundary(contentType);
  if (boundary == null) {
    return Response(
      statusCode: 400,
      body: 'Could not find boundary in Content-Type',
    );
  }

  // 4) Use MimeMultipartTransformer to split the raw body into parts.
  //    `request.read()` is a Stream<Uint8List> of the raw request body.
  final transformer = MimeMultipartTransformer(boundary);
  final parts = await transformer.bind(request.bytes()).toList();

  // 5) Prepare an upload directory (in this example, "./uploads").
  final uploadDir = Directory('data/uploads');
  if (!uploadDir.existsSync()) {
    uploadDir.createSync(recursive: true);
  }

  final savedFiles = <String>[];


  // 6) Loop through each MIME part
  for (final part in parts) {
    // Parse headers & content of this part:
      final cdHeader = part.headers['content-disposition'];
      if (cdHeader == null) continue; // or throw
      final disposition = HeaderValue.parse(
        cdHeader,
      );
      final filename  = disposition.parameters['filename'] ?? 'unknown';   // only present if this part is a file

      // save the filename for the response
      final f = UploadedFile(
          filename,
          ContentType.parse(part.headers['content-type'] ?? 'text/plain'),
          part,);
      final rectifiedFilename = '$id-${_sanitizeFilename(f.name)}';
      File('${uploadDir.path}/$rectifiedFilename')
      ..createSync(recursive: true)
      ..writeAsBytesSync(await f.readAsBytes());

      savedFiles.add(rectifiedFilename);
  }

  // update task record with the saved files
  final companion = TasksCompanion.insert(
      id: Value(task.id), // Use the provided ID for the update
      title: task.title,
      description: Value(task.description),
      templateId: task.templateId,
      assignedUsers: task.assignedUsers,
      startTime: task.startTime,
      dueTime: task.dueTime,
      submittedFiles: Value(savedFiles.isEmpty ? null : savedFiles),
      expectedCompletionTimeInMinutes: task.expectedCompletionTimeInMinutes,
      completionTime: Value(DateTime.now()),
    );

  // Update the task template
  final updated = await database.update(database.tasks).replace(companion);
  
  if (!updated) {
    return Response(statusCode: HttpStatus.notFound);
  }

  await notifyOnTaskCompleted(task, user);
  
  return Response();

}


/// Helper to extract the boundary= value from a Content-Type header.
String? _parseBoundary(String contentType) {
  // Content-Type will look like: "multipart/form-data; boundary=----XYZ"
  final parts = contentType.split(';');
  for (final part in parts) {
    final trimmed = part.trim();
    if (trimmed.startsWith('boundary=')) {
      return trimmed.substring(9); // drop "boundary="
    }
  }
  return null;
}

/// Very basic filename sanitizer (remove path segments). 
/// In production you may want a stricter check.
String _sanitizeFilename(String filename) {
  return filename.split(RegExp(r'[\/\\]')).last;
}
