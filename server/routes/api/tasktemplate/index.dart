// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/logger.dart';
import 'package:smartopia_hms_server/model/database.dart';
import 'package:smartopia_hms_server/notification.dart';
import 'package:smartopia_hms_server/scheduler.dart';
import 'package:smartopia_hms_shared/shared.dart';

// GET all users or POST to create a new user
Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getTaskTemplates(context);
    case HttpMethod.post:
      return _createTaskTemplate(context);
    // ignore: no_default_cases
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getTaskTemplates(RequestContext context) async {
  final request = context.request;
  final page = int.tryParse(request.uri.queryParameters['page'] ?? '1') ?? 1;
  final limit = int.tryParse(request.uri.queryParameters['limit'] ?? '20') ?? 20;
  final offset = (page - 1) * limit;

  final tasks = await database.managers.taskTemplates.limit(limit, offset:offset).get();

  return Response.json(body: tasks);
}

Future<Response> _createTaskTemplate(RequestContext context) async {
  final body = await context.request.json();
  try {
    
    final jsonBody = body as Map<String, dynamic>;
    if (jsonBody['rewards'] is Map<String, dynamic>) {
      jsonBody['rewards'] = RewardInfo.fromJson(jsonBody['rewards'] as Map<String, dynamic>);
    }
    final template = TaskTemplate.fromJson(jsonBody);

    //final auth = context.read<Authenticator>();
    //final user = await auth.verifyToken(context.request.headers['Authorization'] ?? '');
    final user = context.read<User>();

    if (!user.isParent && !user.allowSelfHomeworkManagement) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {'error': 'Unauthorized'},
      );
    }

    //final user = context.read<User>();

    // Create a companion that omits the 'id' column
    final companion = TaskTemplatesCompanion.insert(
      title: template.title,
      description: Value(template.description),
      tags: Value<List<String>?>(template.tags),
      creator: user.username,
      assignedUsers: template.assignedUsers,
      recurrence: template.recurrence,
      remind: Value(template.remind),
      expectedCompletionTimeInMinutes: template.expectedCompletionTimeInMinutes,
      rewards: Value(template.rewards),
      priority: Value(template.priority),
      attachmentRequired: Value(template.attachmentRequired),
      submissionRequired: Value(template.submissionRequired),
      creationTime: DateTime.now(),
      notificationSetting: Value(template.notificationSetting),
    );

    // Insert and let the DB generate the id
    final id = await database.into(database.taskTemplates).insert(companion);
    
    // Return the created resource (including the generated id)
    final result = <String, dynamic>{
      'id': id,
    };
    final tpl = await database.managers.taskTemplates.filter((t) => t.id.equals(id)).getSingle();
    scheduleNextInstance(tpl);
    notifyOnTaskAssigned(tpl);
    return Response.json(statusCode: HttpStatus.created, body: result);
  } catch (e, st) {
    logError('Error creating task template', e, st);
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: { 'error': e.toString() },
    );
  }
}
