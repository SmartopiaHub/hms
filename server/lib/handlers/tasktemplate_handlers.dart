// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/model/database.dart';
import 'package:smartopia_hms_shared/shared.dart';

// --- IMPORT ---

Future<Response> importTaskTemplates(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final user = context.read<User>();
  if (!user.isParent) {
    return Response(
        statusCode: HttpStatus.forbidden,
        body: 'Only parents can import task templates');
  }

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final templatesList = body['templates'] as List;

    var importedCount = 0;
    final duplicates = <Map<String, dynamic>>[];

    for (final templateJson in templatesList) {
      try {
        final jsonBody = templateJson as Map<String, dynamic>;
        if (jsonBody['rewards'] is Map<String, dynamic>) {
          jsonBody['rewards'] =
              RewardInfo.fromJson(jsonBody['rewards'] as Map<String, dynamic>);
        }
        final template = TaskTemplate.fromJson(jsonBody);

        // Check for duplicates based on title and assignedUsers
        final existingTemplates = await (database.select(database.taskTemplates)
              ..where((t) => t.title.equals(template.title)))
            .get();

        // Check if any existing template has the same assigned users
        final isDuplicate = existingTemplates.any((existing) {
          final existingUsers = existing.assignedUsers.toSet();
          final newUsers = template.assignedUsers.toSet();
          return existingUsers.difference(newUsers).isEmpty &&
              newUsers.difference(existingUsers).isEmpty;
        });

        if (isDuplicate) {
          // Duplicate found, add to list
          duplicates.add({
            'title': template.title,
            'assignedUsers': template.assignedUsers,
          });
          continue;
        }

        // Create new template companion from parsed object
        final companion = TaskTemplatesCompanion.insert(
          title: template.title,
          creator: user.username,
          assignedUsers: template.assignedUsers,
          recurrence: template.recurrence,
          creationTime: DateTime.now(),
          expectedCompletionTimeInMinutes:
              template.expectedCompletionTimeInMinutes,
          tags: Value(template.tags),
          priority: Value(template.priority),
          remind: Value(template.remind),
          description: Value(template.description),
          rewards: Value(template.rewards),
          penalty: Value(template.penalty),
          attachmentRequired: Value(template.attachmentRequired),
          submissionRequired: Value(template.submissionRequired),
          notificationSetting: Value(template.notificationSetting),
        );

        await database.into(database.taskTemplates).insert(companion);
        importedCount++;
      } catch (e) {
        // Skip templates that fail to import
        continue;
      }
    }

    return Response.json(body: {
      'success': true,
      'importedCount': importedCount,
      'duplicates': duplicates,
    });
  } catch (e) {
    return Response(
        statusCode: HttpStatus.internalServerError,
        body: 'Failed to import task templates: $e');
  }
}

// --- EXPORT ---

Future<Response> exportTaskTemplates(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final user = context.read<User>();
  if (!user.isParent) {
    return Response(
        statusCode: HttpStatus.forbidden,
        body: 'Only parents can export task templates');
  }

  try {
    final templates = await database.select(database.taskTemplates).get();
    final jsonList = templates.map((t) => t.toJson()).toList();

    return Response.json(body: jsonList);
  } catch (e) {
    return Response(
        statusCode: HttpStatus.internalServerError,
        body: 'Failed to export task templates: $e');
  }
}

// --- PURGE ---

Future<Response> purgeTaskTemplates(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final user = context.read<User>();
  if (!user.isParent) {
    return Response(
        statusCode: HttpStatus.forbidden,
        body: 'Only parents can purge task templates');
  }

  try {
    // Delete all task templates
    final count = await database.delete(database.taskTemplates).go();

    return Response.json(body: {'success': true, 'deletedCount': count});
  } catch (e) {
    return Response(
        statusCode: HttpStatus.internalServerError,
        body: 'Failed to purge task templates: $e');
  }
}
