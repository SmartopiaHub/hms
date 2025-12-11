// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

// routes/signin.dart
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/authenticator.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final username = body['username'] as String?;
  final password = body['password'] as String?;

  if (username == null || password == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final authenticator = context.read<Authenticator>();

  final user = await authenticator.findByUsernameAndPassword(
    username: username,
    password: password,
  );

  if (user == null) {
    return Response(statusCode: HttpStatus.unauthorized);
  } else {
    return Response.json(
      body: {
        'token': authenticator.generateToken(
          user: user,
        ),
        'user': {
          'id': user.id,
          'username': user.username,
          'isParent': user.isParent,
          'allowSelfHomeworkManagement': user.allowSelfHomeworkManagement,
          'pointSystemId': user.pointSystemId,
          'totalPoints': user.totalPoints,
          'redeemedPoints': user.redeemedPoints,
        },
      },
    );
  }
}
