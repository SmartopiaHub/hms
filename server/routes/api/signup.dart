// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

// routes/signup.dart
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/authenticator.dart';
import 'package:smartopia_hms_server/model/database.dart';


/// This function handles the signup route.
/// It allows users to check if signup is allowed and to create a new user.
/// The signup is allowed if there are no users in the database. In this case, the signed-up user is a parent.
/// If there are users in the database, signup is not allowed.
/// Additional users can only be created by a parent account.


Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    HttpMethod.post => _onPost(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<bool> _isEmptyDatabase() async {
  final n = await database.users.count().getSingle();
  return n == 0;
}

// check if signup is allowed
// if there are no users in the database, signup is allowed
// if there are users in the database, signup is not allowed
// additional users can only be created by a parent account
Future<Response> _onGet(RequestContext context) async {
  return Response.json(
    body: {
      'allow': await _isEmptyDatabase(),
    },
  );
}

Future<Response> _onPost(RequestContext context) async {

  if (! await _isEmptyDatabase()) {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {
        'error': 'signup is not allowed',
      },
    );
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final username = body['username'] as String?;
  final password = body['password'] as String?;

  if (username == null || password == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'error': 'username and password are required',
      },
    );
  }

  if (password.length < 8) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'error': 'password must be at least 8 characters long',
      },
    );
  }

  final user = await database.managers.users
      .filter((t) => t.username.equals(username))
      .getSingleOrNull();
  if (user != null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'error': 'username already exists',
      },
    );
  }

  final hashed = hashPassword(password);

  // Create a companion that omits the 'id' column
  final companion = UsersCompanion.insert(
    username: username,
    // if nickname is nullable, wrap with Value(...)
    nickname: Value(body['nickname'] as String?),
    password: hashed,
    isParent: const Value(true),
  );

  // Insert and let the DB generate the id
  final id = await database.into(database.users).insert(companion);
  
  // Return the created resource (including the generated id)
  final result = <String, dynamic>{
    'id': id,
  };
  return Response.json(statusCode: HttpStatus.created, body: result);
}
