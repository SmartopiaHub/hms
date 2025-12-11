// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/authenticator.dart';
import 'package:smartopia_hms_server/model/database.dart';

// GET all users or POST to create a new user
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _changePassword(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _changePassword(RequestContext context) async {
  final body = await context.request.json();
  final jsonBody = body as Map<String, dynamic>;
  
  final userId = int.tryParse(jsonBody['userId']?.toString() ?? '');
  final newPassword = jsonBody['newPassword']?.toString();

  if (userId == null || newPassword == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid request parameters'},
    );
  }

  // Hash the new password
  final hashedPassword = hashPassword(newPassword);

  // Update the user's password in the database
  final updatedCount = await (database.update(database.users)
        ..where((u) => u.id.equals(userId)))
      .write(UsersCompanion(password: Value(hashedPassword)));

  if (updatedCount > 0) {
    return Response.json(
      body: {'message': 'Password changed successfully'},
    );
  } else {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': 'User not found'},
    );
  }
}