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
    HttpMethod.get => _getUsers(context),
    HttpMethod.post => _createUser(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _getUsers(RequestContext context) async {
  final queryParams = context.request.uri.queryParameters;
  final userType = queryParams['type'];
  if (userType == 'children') {
    return _getChildUsers(context);
  } 
  final users = await database.users.select().get();
  return Response.json(body: users);
}

Future<Response> _getChildUsers(RequestContext context) async {
  final users = await (database.users.select()
        ..where((tbl) => tbl.isParent.equals(false)))
      .get();
  
  final usersWithPoints = <Map<String, dynamic>>[];

  for (final user in users) {
    final userMap = user.toJson();
    userMap['totalPoints'] = user.totalPoints;
    userMap['redeemedPoints'] = user.redeemedPoints;
    usersWithPoints.add(userMap);
  }

  return Response.json(body: usersWithPoints);
}

Future<Response> _createUser(RequestContext context) async {
  final body = await context.request.json();// as Map<String, dynamic>;
  // Validate and create a User from the request body.
  try {
    // Build your User object (for validation, hashing, etc)
    final jsonBody = body as Map<String, dynamic>;
    final user = User.fromJson(jsonBody);
    final hashed = hashPassword(user.password);

    // Create a companion that omits the 'id' column
    final companion = UsersCompanion.insert(
      username: user.username,
      // if nickname is nullable, wrap with Value(...)
      nickname: Value(user.nickname),
      password: hashed,
      isParent: Value(user.isParent),
    );

    // Insert and let the DB generate the id
    final id = await database.into(database.users).insert(companion);
    
    // Return the created resource (including the generated id)
    final result = <String, dynamic>{
      'id': id,
      'username': user.username,
      'nickname': user.nickname,
      'isParent': user.isParent,
    };
    return Response.json(statusCode: HttpStatus.created, body: result);
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: { 'error': e.toString() },
    );
  }
}
