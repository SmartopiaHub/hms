// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/model/database.dart';

// GET all users or POST to create a new user
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _cancelTask(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _cancelTask(RequestContext context) async {
  final body = await context.request.json();
  final jsonBody = body as Map<String, dynamic>;
  final taskId = int.tryParse(jsonBody['taskId']?.toString() ?? '');
  final templateId = int.tryParse(jsonBody['templateId']?.toString() ?? '');
  final startTime = DateTime.tryParse(jsonBody['startTime']?.toString() ?? '');

  if (taskId != null) {
    // If taskId is provided, cancel the specific task
    var task = await (database.select(database.tasks)
          ..where((t) => t.id.equals(taskId)))
        .getSingleOrNull();
    if (task != null) {
      return _cancelSpecificTask(taskId);
    }
  } 
  
  if (templateId != null && startTime != null) {
    // If templateId and startTime are provided, cancel all tasks for that template at that time
    return _cancelTasksByTemplateAndStart(templateId, startTime);
  } else {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid request parameters'},
    );
  }
}

Future<Response> _cancelSpecificTask(int taskId) async {
  // update the task status to cancelled
  final updatedCount = await (database.update(database.tasks)
        ..where((t) => t.id.equals(taskId)))
      .write(
        const TasksCompanion(
          cancelled: Value(true),
        ),
      );
  if (updatedCount > 0) {
    return Response.json(
      body: {'message': 'Task $taskId cancelled successfully'},
    );
  } else {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': 'Task $taskId not found'},
    );
  }
}

Future<Response> _cancelTasksByTemplateAndStart(int templateId, DateTime startTime) async {
  // start a transaction to ensure atomicity
  // assume you have a top‐level `database` instance of AppDatabase
  final task = await (database.select(database.tasks)
        ..where((t) =>
          t.templateId.equals(templateId) &
          t.startTime.equals(startTime) &
          t.cancelled.equals(false),
        ))
      .getSingleOrNull();
  if (task != null) {
    return _cancelSpecificTask(task.id);
  }
  return  database.transaction(() async {
    // 1) check if the template exists
    final template = await (database.select(database.taskTemplates)
          ..where((t) => t.id.equals(templateId)))
        .getSingleOrNull();

    if (template == null) {
      throw Exception('Template with id $templateId not found');
    }

    // check whether the task already exists
    final existingTask = await (database.select(database.tasks)
          ..where((t) =>
            t.templateId.equals(templateId) &
            t.startTime.equals(startTime),
          ))
        .getSingleOrNull();
    if (existingTask != null) {
      return _cancelSpecificTask(existingTask.id);
    }

    // create a new task instance if it doesn't exist
    final newTask = template.createTaskInstance(startTime, cancelled: true);
    final taskId = await database.into(database.tasks).insert(
      newTask.toCompanion(true).copyWith(id: const Value.absent()),
    );
    return Response.json(
      body: {'message': 'Cancelled task $taskId for template $templateId at $startTime'},
    );
  });

}


