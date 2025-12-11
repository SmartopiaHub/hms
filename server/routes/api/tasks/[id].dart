// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/model/database.dart';

// GET a user, PUT/PATCH for update, DELETE a user.
Future<Response> onRequest(RequestContext context, String id) async {
  // Check if id is a valid integer, if not return 404
  final parsedId = int.tryParse(id);
  if (parsedId == null) {
    return Response(statusCode: HttpStatus.notFound, body: 'Invalid ID format');
  }
  
  return switch (context.request.method) {
    HttpMethod.get => _getTask(context, parsedId),
    //HttpMethod.put => _updateTaskTemplate(context, parsedId),
    HttpMethod.delete => _deleteTask(context, parsedId),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _getTask(RequestContext context, int id) async {
  final task = await (database.select(database.tasks)
        ..where((t) => t.id.equals(id)))
      .getSingleOrNull();

  if (task == null) {
    return Response(statusCode: HttpStatus.notFound);
  }
  return Response.json(body: task.toJson());
}



Future<Response> _deleteTask(RequestContext context, int id) async {
  final deletedCount = await (database.delete(database.tasks)
        ..where((t) => t.id.equals(id)))
      .go();

  if (deletedCount == 0) {
    return Response(statusCode: HttpStatus.notFound);
  }
  
  return Response();
}