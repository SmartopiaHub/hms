// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

// routes/upload.dart

import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/model/database.dart';
import 'package:smartopia_hms_server/notification.dart';
import 'package:smartopia_hms_shared/shared.dart';

/// A helper that reads a multipart/form-data request, 
/// saves any uploaded files to `uploads/`, and returns a JSON list of saved filenames.
Future<Response> onRequest(RequestContext context, String id) async {
  final request = context.request;

  // 1) Ensure this is a POST.
  if (request.method != HttpMethod.post) {
    return Response(statusCode: 405, body: 'Method Not Allowed');
  }

  
  final task = await database.managers.tasks.filter((t) => t.id.equals(int.parse(id))).getSingleOrNull();
  if (task == null) {
    return Response(
      statusCode: 404,
      body: 'Task not found',
    );
  }

  if (task.rewards?.pointsAwarded != null) {
    return Response(
      statusCode: 403,
      body: 'Task already graded',
    );
  }

  final evaluator = context.read<User>();
  if (!evaluator.isParent) {
    return Response(
      statusCode: 403,
      body: 'Only parents can grade tasks',
    );
  }

  final body = await context.request.json();
  final jsonBody = body as Map<String, dynamic>;
  final stars = jsonBody['stars'] as int?;
  if (stars == null || stars < 0 || stars > 5) {
    return Response(
      statusCode: 400,
      body: 'Invalid stars value. Must be between 0 and 5.',
    );
  }
  return _updateTask(context, task, evaluator, stars);
  
}

Future<Response> _updateTask(RequestContext context, Task task, User evaluator, int stars) async {
  

  //TODO: check assigned users and creator

  // Check if point system is enabled
  final configFile = File('data/config.json');
  bool pointSystemEnabled = true; // Default to enabled
  
  if (await configFile.exists()) {
    try {
      final content = await configFile.readAsString();
      if (content.isNotEmpty) {
        final config = jsonDecode(content) as Map<String, dynamic>;
        pointSystemEnabled = config['pointSystemEnabled'] as bool? ?? true;
      }
    } catch (e) {
      // If there's an error reading config, default to enabled
    }
  }

  final maxPoints = task.rewards?.maxPoints ?? 0;
  final points = pointSystemEnabled ? (maxPoints * stars / 5).round() : 0;

  final newRewards = (task.rewards ?? const RewardInfo()).copyWith(pointsAwarded: points);

  final companion = TasksCompanion.insert(
      id: Value(task.id), // Use the provided ID for the update
      title: task.title,
      description: Value(task.description),
      templateId: task.templateId,
      assignedUsers: task.assignedUsers,
      startTime: task.startTime,
      dueTime: task.dueTime,
      submittedFiles: Value(task.submittedFiles),
      rewards: Value(newRewards),
      evaluationTime: Value(DateTime.now()),
      evaluator: Value(evaluator.username),
      completionTime: Value(task.completionTime),
      expectedCompletionTimeInMinutes: task.expectedCompletionTimeInMinutes,
    );

  // Update the task template
  final updated = await database.update(database.tasks).replace(companion);
  
  if (!updated) {
    return Response(statusCode: HttpStatus.notFound);
  }

  // update child's total points only if point system is enabled
  if (pointSystemEnabled && points > 0) {
    for (final username in task.assignedUsers) {
      final user = await database.managers.users.filter((u) => u.username.equals(username)).getSingleOrNull();
      if (user != null) {
        final currentPoints = user.totalPoints;
        await database.update(database.users).replace(
          user.copyWith(totalPoints: currentPoints + points)
        );
      }
    }
  }

  // TODO: notify the parents about the update
  await notifyOnTaskGraded(task);
  return Response();
}
