// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/model/database.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getPointSystem(context),
    HttpMethod.put => _updatePointSystem(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _getPointSystem(RequestContext context) async {
  final user = context.read<User>();
  
  return Response.json(body: {
    'pointSystemId': user.pointSystemId,
  });
}

Future<Response> _updatePointSystem(RequestContext context) async {
  //final user = context.read<User>();
  final body = await context.request.json() as Map<String, dynamic>;
  
  try {
    final pointSystemId = body['pointSystemId'] as String?;

    //TODO: Validate pointSystemId if necessary and to support multiple families
    await database.update(database.users)
      .write(UsersCompanion(
        pointSystemId: Value(pointSystemId),
      ));
    
    return Response.json(body: {'success': true});
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': e.toString()},
    );
  }
}
