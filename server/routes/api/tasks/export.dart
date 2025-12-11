// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/model/database.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _exportTasks(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _exportTasks(RequestContext context) async {
  final user = context.read<User>();
  if (!user.isParent) {
    return Response(statusCode: HttpStatus.forbidden, body: 'Only parents can export tasks');
  }

  try {
    final tasks = await database.select(database.tasks).get();
    final jsonList = tasks.map((t) => t.toJson()).toList();
    
    return Response.json(body: jsonList);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError, body: 'Failed to export tasks: $e');
  }
}
