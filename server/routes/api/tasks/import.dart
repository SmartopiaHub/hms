// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/model/database.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_shared/shared.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _importTasks(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _importTasks(RequestContext context) async {
  final user = context.read<User>();
  if (!user.isParent) {
    return Response(statusCode: HttpStatus.forbidden, body: 'Only parents can import tasks');
  }

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final tasksList = body['tasks'] as List;
    
    int importedCount = 0;
    final duplicates = <Map<String, dynamic>>[];
    
    for (final taskJson in tasksList) {
      try {
        final jsonBody = taskJson as Map<String, dynamic>;
        if (jsonBody['rewards'] is Map<String, dynamic>) {
          jsonBody['rewards'] = RewardInfo.fromJson(jsonBody['rewards'] as Map<String, dynamic>);
        }
        final task = Task.fromJson(jsonBody);
        
        // Check for duplicates based on title, assignedUsers, and startTime
        final existingTasks = await (database.select(database.tasks)
          ..where((t) => t.title.equals(task.title) & t.startTime.equals(task.startTime)))
          .get();
        
        // Check if any existing task has the same assigned users
        final isDuplicate = existingTasks.any((existing) {
          final existingUsers = existing.assignedUsers.toSet();
          final newUsers = task.assignedUsers.toSet();
          return existingUsers.difference(newUsers).isEmpty && 
                 newUsers.difference(existingUsers).isEmpty;
        });
        
        if (isDuplicate) {
          // Duplicate found, add to list
          duplicates.add({
            'title': task.title,
            'assignedUsers': task.assignedUsers,
            'startTime': task.startTime.toIso8601String(),
          });
          continue;
        }
        
        // Create new task companion from parsed object
        final companion = TasksCompanion.insert(
          templateId: task.templateId,
          title: task.title,
          assignedUsers: task.assignedUsers,
          startTime: task.startTime,
          dueTime: task.dueTime,
          expectedCompletionTimeInMinutes: task.expectedCompletionTimeInMinutes,
          tags: Value(task.tags),
          remind: Value(task.remind),
          description: Value(task.description),
          rewards: Value(task.rewards),
          penalty: Value(task.penalty),
          attachmentRequired: Value(task.attachmentRequired),
          submissionRequired: Value(task.submissionRequired),
          notificationSetting: Value(task.notificationSetting),
          submittedFiles: Value(task.submittedFiles),
          completionTime: Value(task.completionTime),
          evaluationTime: Value(task.evaluationTime),
          evaluator: Value(task.evaluator),
          cancelled: Value(task.cancelled),
          notificationHistory: Value(task.notificationHistory),
        );
        
        await database.into(database.tasks).insert(companion);
        importedCount++;
      } catch (e) {
        // Skip tasks that fail to import
        continue;
      }
    }
    
    return Response.json(body: {
      'success': true, 
      'importedCount': importedCount,
      'duplicates': duplicates,
    });
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError, body: 'Failed to import tasks: $e');
  }
}
