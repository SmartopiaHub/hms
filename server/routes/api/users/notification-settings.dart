// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/model/database.dart';
import 'package:smartopia_hms_shared/shared.dart';

Future<Response> onRequest(RequestContext context) async {
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
    
    await (database.update(database.users)
      ..where((u) => u.id.equals(user.id)))
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
