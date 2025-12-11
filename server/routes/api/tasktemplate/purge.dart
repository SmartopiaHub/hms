// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/model/database.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _purgeTaskTemplates(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _purgeTaskTemplates(RequestContext context) async {
  final user = context.read<User>();
  if (!user.isParent) {
    return Response(statusCode: HttpStatus.forbidden, body: 'Only parents can purge task templates');
  }

  try {
    // Delete all task templates
    final count = await database.delete(database.taskTemplates).go();
    
    return Response.json(body: {'success': true, 'deletedCount': count});
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError, body: 'Failed to purge task templates: $e');
  }
}
