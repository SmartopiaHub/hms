// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/authenticator.dart';
import 'package:smartopia_hms_server/model/database.dart';
import 'package:smartopia_hms_shared/shared.dart';

// --- POINTS ---

Future<Response> getPoints(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
  final user = context.read<User>();
  return Response.json(body: user.rewardPointInfo.toJson());
}

// --- POINT SYSTEM ---

Future<Response> pointSystemHandler(RequestContext context) async {
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
    await database.update(database.users).write(UsersCompanion(
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

// --- PASSWORD ---

Future<Response> changePassword(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

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

// --- NOTIFICATION SETTINGS ---

Future<Response> notificationSettingsHandler(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getNotificationSettings(context),
    HttpMethod.put => _updateNotificationSettings(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _getNotificationSettings(RequestContext context) async {
  final user = context.read<User>();

  return Response.json(body: {
    'notificationSettings': user.notificationSettings?.toJson(),
  });
}

Future<Response> _updateNotificationSettings(RequestContext context) async {
  final user = context.read<User>();
  final body = await context.request.json() as Map<String, dynamic>;

  try {
    final settingsJson = body['notificationSettings'] as Map<String, dynamic>?;
    final settings = settingsJson != null
        ? NotificationSetting.fromJson(settingsJson)
        : null;

    await (database.update(database.users)..where((u) => u.id.equals(user.id)))
        .write(UsersCompanion(
      notificationSettings: Value(settings),
    ));

    return Response.json(body: {'success': true});
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': e.toString()},
    );
  }
}
