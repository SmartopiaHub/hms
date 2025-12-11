// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/model/database.dart';
import 'package:smartopia_hms_server/scheduler.dart';
import 'package:smartopia_hms_shared/shared.dart';

// GET a user, PUT/PATCH for update, DELETE a user.
Future<Response> onRequest(RequestContext context, String id) async {
  // Check if id is a valid integer, if not return 404
  final parsedId = int.tryParse(id);
  if (parsedId == null) {
    return Response(statusCode: HttpStatus.notFound, body: 'Invalid ID format');
  }
  
  return switch (context.request.method) {
    HttpMethod.get => _getTaskTemplate(context, parsedId),
    HttpMethod.put => _updateTaskTemplate(context, parsedId),
    HttpMethod.delete => _deleteTaskTemplate(context, parsedId),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _getTaskTemplate(RequestContext context, int id) async {
  final taskTemplate = await (database.select(database.taskTemplates)
        ..where((t) => t.id.equals(id)))
      .getSingleOrNull();

  if (taskTemplate == null) {
    return Response(statusCode: HttpStatus.notFound);
  }
  return Response.json(body: taskTemplate.toJson());
}

Future<Response> _updateTaskTemplate(RequestContext context, int id) async {
  final body = await context.request.json();
  final jsonBody = body as Map<String, dynamic>;
  if (jsonBody['rewards'] is Map<String, dynamic>) {
    jsonBody['rewards'] = RewardInfo.fromJson(jsonBody['rewards'] as Map<String, dynamic>);
  }
  final template = TaskTemplate.fromJson(jsonBody);

  //TODO: check assigned users and creator

  final companion = TaskTemplatesCompanion.insert(
      id: Value(id), // Use the provided ID for the update
      title: template.title,
      description: Value(template.description),
      tags: Value<List<String>?>(template.tags),
      assignedUsers: template.assignedUsers,
      creator: template.creator,
      recurrence: template.recurrence,
      remind: Value(template.remind),
      expectedCompletionTimeInMinutes: template.expectedCompletionTimeInMinutes,
      priority: Value(template.priority),
      rewards: Value(template.rewards),
      penalty: Value(template.penalty),
      attachmentRequired: Value(template.attachmentRequired),
      submissionRequired: Value(template.submissionRequired),
      creationTime: DateTime.now(),
      notificationSetting: Value(template.notificationSetting),
    );

  // Update the task template
  final updated = await database.update(database.taskTemplates).replace(companion);
  
  if (!updated) {
    return Response(statusCode: HttpStatus.notFound);
  }
  final tpl = await database.managers.taskTemplates.filter((t) => t.id.equals(id)).getSingle();
  scheduleNextInstance(tpl);
  return Response();
}


Future<Response> _deleteTaskTemplate(RequestContext context, int id) async {
  final deletedCount = await (database.delete(database.taskTemplates)
        ..where((t) => t.id.equals(id)))
      .go();

  if (deletedCount == 0) {
    return Response(statusCode: HttpStatus.notFound);
  }
  
  cancelScheduledInstance(id);
  return Response();
}