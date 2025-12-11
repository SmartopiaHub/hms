// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/authenticator.dart';
import 'package:smartopia_hms_server/model/database.dart';

// GET a user, PUT/PATCH for update, DELETE a user.
Future<Response> onRequest(RequestContext context, String id) async {
  return switch(context.request.method) {
    HttpMethod.get => _getUser(context, int.parse(id)),
    HttpMethod.put => _updateUser(context, id),
    HttpMethod.delete => _deleteUser(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _getUser(RequestContext context, int id) async {

  final user = await (database.select(database.users)
    ..where((u) => u.id.equals(id)))
      .getSingleOrNull();
  
  if (user == null) {
    return Response(statusCode: HttpStatus.notFound);
  }
  return Response.json(body: user.toJson());
}

Future<Response> _updateUser(RequestContext context, String userId) async {
  try{
    final body = await context.request.json();
    final jsonBody = body as Map<String, dynamic>;
    

    // Validate and create a User from the request body.
    final nickname = jsonBody['nickname'] as String?;
    final isParent = jsonBody['isParent'] as bool?;
    final password = jsonBody['password'] as String?;
    final username = jsonBody['username'] as String?;
    final allowSelfHomeworkManagement = jsonBody['allowSelfHomeworkManagement'] as bool?;
    
    if (username == null || username.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Username is required'},
      );
    }
    final user = await (database.select(database.users)
          ..where((u) => u.username.equals(username)))
        .getSingleOrNull();

    if (user == null) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'User not found'},
      );
    }    
    final id = user.id;
    
    if (isParent == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'isParent field is required'},
      );
    }

    late UsersCompanion companion;
    if (password != null) {
      // If password is provided, hash it
      final hashed = hashPassword(password);
      companion = UsersCompanion(
        nickname: Value(nickname),
        isParent: Value(isParent),
        allowSelfHomeworkManagement: allowSelfHomeworkManagement == null 
            ? const Value<bool>.absent() 
            : Value(allowSelfHomeworkManagement),
        password: Value(hashed),
      );
    } else {
      // If no password is provided, just update nickname and isParent
      companion = UsersCompanion(
        nickname: Value(nickname),
        isParent: Value(isParent),
        allowSelfHomeworkManagement: allowSelfHomeworkManagement == null 
            ? const Value<bool>.absent() 
            : Value(allowSelfHomeworkManagement),
      );
    }

    // update the task status to cancelled
    final updatedCount = await (database.update(database.users)
          ..where((t) => t.id.equals(id)))
        .write(companion);
    if (updatedCount > 0) {
      return Response.json(
        body: {'message': 'User $userId updated successfully'},
      );
    } else {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'User $userId not found'},
      );
    }
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid request body: $e'},
    );
  }
  
}

Future<Response> _deleteUser(RequestContext context, String id) async {
  final userId = int.tryParse(id);
  if (userId == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid user ID'},
    );
  }

  final user = await (database.select(database.users)
        ..where((u) => u.id.equals(userId)))
      .getSingleOrNull();
  if (user == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': 'User not found'},
    );
  }

  // A user cannot delete themselves or if they are not a parent
  final currentUser = context.read<User>();
  if (currentUser.id == userId || !currentUser.isParent) {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {'error': 'You do not have permission to delete this user'},
    );
  }

  if (!user.isParent){
    final childrens = await (database.select(database.users)
          ..where((u) => u.isParent.equals(false)))
        .get();
    if (childrens.length <=1) {
      return Response.json(
        statusCode: HttpStatus.forbidden,
        body: {'error': 'You cannot delete the last child user'},
      );
    }
  }

  // cannot delete a user if they have tasks assigned
  final tasks = await (database.select(database.tasks)
        ..where((t) => t.assignedUsers.contains(user.username)))
      .get();
  if (tasks.isNotEmpty) {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {'error': 'Cannot delete user with assigned tasks'},
    );
  }

  // cannot delete if they are in some task templates
  final taskTemplates = await (database.select(database.taskTemplates)
        ..where((t) => t.assignedUsers.contains(user.username)))
      .get();
  if (taskTemplates.isNotEmpty) {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {'error': 'Cannot delete user with assigned task templates'},
    );
  }

  final deletedCount = await (database.delete(database.users)
        ..where((u) => u.id.equals(userId)))
      .go();

  if (deletedCount > 0) {
    return Response.json(body: {'message': 'User deleted successfully'});
  } else {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': 'User not found'},
    );
  }
}

