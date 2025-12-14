// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/logger.dart';
import 'package:smartopia_hms_server/model/database.dart';
import 'package:smartopia_hms_shared/shared.dart';

// --- SEARCH ---

// get tasks based on query parameters (in json format)
Future<Response> searchTasks(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.request.json();
    final jsonBody = body as Map<String, dynamic>;
    final page = int.tryParse(jsonBody['page']?.toString() ?? '1') ?? 1;
    final limit = int.tryParse(jsonBody['limit']?.toString() ?? '20') ?? 20;
    final filter = jsonBody['filter'] as Map<String, dynamic>? ?? {};
    final sort = jsonBody['sort']?.toString() ?? 'startTime';
    final order = jsonBody['order']?.toString() ?? 'desc';
    final statuses = (filter['statuses'] as List<dynamic>)
        .map((e) => TaskStatus.values.firstWhere(
              (s) => s.name == e.toString(),
            ))
        .toList();
    final assignedUsers = (filter['assignedUsers'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList();
    final start = filter['start'] != null
        ? DateTime.tryParse(filter['start'].toString())
        : null;
    final end = filter['end'] != null
        ? DateTime.tryParse(filter['end'].toString())
        : null;
    final status = (filter['statuses'] as List<dynamic>?)
        ?.map((e) => TaskStatus.values.firstWhere(
              (s) => s.name == e.toString(),
            ))
        .toList();

    // first, get all tasks satisfying the filters from database
    final query = database.select(database.tasks);

    var tasks = await query.get();

    final now = DateTime.now();

    if (!statuses.contains(TaskStatus.overdue)) {
      tasks = tasks.where((t) => !t.isOverdue).toList();
    }

    if (!statuses.contains(TaskStatus.inProgress)) {
      tasks = tasks.where((t) => t.status != TaskStatus.inProgress).toList();
    }

    if (!statuses.contains(TaskStatus.graded)) {
      tasks = tasks.where((t) => t.status != TaskStatus.graded).toList();
    }

    if (!statuses.contains(TaskStatus.completed)) {
      tasks = tasks.where((t) => t.status != TaskStatus.completed).toList();
    }

    if (!statuses.contains(TaskStatus.cancelled)) {
      tasks = tasks.where((task) => !task.cancelled).toList();
    }

    // include tasks that are
    //   - not completed and due after the start time
    //   - overdue, not completed, and the start time is before or on [start] and not after [end]
    //   - all occurrences starting from [start] to [end] for templates

    tasks = tasks
        .where((task) =>
            ((start == null || task.startTime.isAfter(start)) &&
                (end == null || !task.startTime.isAfter(end))) ||
            ((start == null || task.dueTime.isAfter(start))) ||
            (start == null ||
                    (task.isOverdue && task.startTime.isBefore(start))) &&
                (end == null || (task.isOverdue && task.dueTime.isBefore(end))))
        .toList();

    // if included not started tasks, we need to include future occurrences of task templates within [start] and [end]
    if (statuses.contains(TaskStatus.notStarted) &&
        end != null &&
        end.isAfter(now)) {
      final templates = await database.select(database.taskTemplates).get();
      for (final template in templates) {
        final futureOccurrences = template.recurrence.occurrences(
          after: start ?? now,
          beforeOrOn: end,
        );
        for (final occurrence in futureOccurrences) {
          if (occurrence.isAfter(end)) continue;
          // check if a task instance already exists for this template and occurrence
          final existingTask = tasks.indexWhere(
            (task) =>
                task.templateId == template.id && task.startTime == occurrence,
          );
          if (existingTask == -1) {
            // if not, check whether it is a cancellled occurrence
            final cancelledTask = await (database.select(database.tasks)
                  ..where(
                    (t) =>
                        t.templateId.equals(template.id) &
                        t.startTime.equals(occurrence) &
                        t.cancelled.equals(true),
                  ))
                .getSingleOrNull();
            if (cancelledTask == null) {
              // not cancelled, create a new task instance
              final newTask = template.createTaskInstance(occurrence);
              tasks.add(newTask);
              // insert the new task into the database if it not due yet but started
              if (newTask.dueTime.isAfter(now) &&
                  newTask.startTime.isBefore(now)) {
                //logError('Task ${newTask.title} has started but not due yet, inserting into database');
                final companion = template
                    .createTaskInstance(occurrence)
                    .toCompanion(true)
                    .copyWith(id: const Value.absent());
                await database.into(database.tasks).insert(companion);
              }
            }
          } else {
            final t = tasks[existingTask];
            if (t.dueTime.isBefore(t.startTime) || t.startTime.isAfter(now)) {
              logError(
                  'Task ${t.id} has due time before start time, deleting it');
            }
          }
        }
      }
    }

    if (!statuses.contains(TaskStatus.cancelled)) {
      tasks = tasks.where((task) => !task.cancelled).toList();
    }

    if (assignedUsers != null && assignedUsers.isNotEmpty) {
      tasks = tasks
          .where((task) => task.assignedUsers.any(
                assignedUsers.contains,
              ))
          .toList();
    }
    if (status != null && status.isNotEmpty) {
      tasks = tasks.where((task) => status.contains(task.status)).toList();
    }

    // then, sort the tasks
    if (sort == 'dueTime') {
      tasks.sort((a, b) => order == 'desc'
          ? b.dueTime.compareTo(a.dueTime)
          : a.dueTime.compareTo(b.dueTime));
    } else if (sort == 'title') {
      tasks.sort((a, b) => order == 'desc'
          ? b.title.compareTo(a.title)
          : a.title.compareTo(b.title));
    } else if (sort == 'status') {
      tasks.sort((a, b) => order == 'desc'
          ? b.status.index.compareTo(a.status.index)
          : a.status.index.compareTo(b.status.index));
    } else {
      // default sort by startTime
      tasks.sort((a, b) => order == 'desc'
          ? b.startTime.compareTo(a.startTime)
          : a.startTime.compareTo(b.startTime));
    }

    // then, paginate the tasks
    final offset = (page - 1) * limit;
    final paginatedTasks = tasks.skip(offset).take(limit).toList();
    return Response.json(body: paginatedTasks);
  } catch (e, st) {
    logError('Error parsing JSON body: $e', e, st);
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid JSON format'},
    );
  }
}

// --- CANCEL ---

Future<Response> cancelTask(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

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

Future<Response> _cancelTasksByTemplateAndStart(
    int templateId, DateTime startTime) async {
  // start a transaction to ensure atomicity
  final task = await (database.select(database.tasks)
        ..where(
          (t) =>
              t.templateId.equals(templateId) &
              t.startTime.equals(startTime) &
              t.cancelled.equals(false),
        ))
      .getSingleOrNull();
  if (task != null) {
    return _cancelSpecificTask(task.id);
  }
  return database.transaction(() async {
    // 1) check if the template exists
    final template = await (database.select(database.taskTemplates)
          ..where((t) => t.id.equals(templateId)))
        .getSingleOrNull();

    if (template == null) {
      throw Exception('Template with id $templateId not found');
    }

    // check whether the task already exists
    final existingTask = await (database.select(database.tasks)
          ..where(
            (t) =>
                t.templateId.equals(templateId) & t.startTime.equals(startTime),
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
      body: {
        'message':
            'Cancelled task $taskId for template $templateId at $startTime'
      },
    );
  });
}

// --- IMPORT ---

Future<Response> importTasks(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final user = context.read<User>();
  if (!user.isParent) {
    return Response(
        statusCode: HttpStatus.forbidden,
        body: 'Only parents can import tasks');
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
          jsonBody['rewards'] =
              RewardInfo.fromJson(jsonBody['rewards'] as Map<String, dynamic>);
        }
        final task = Task.fromJson(jsonBody);

        // Check for duplicates based on title, assignedUsers, and startTime
        final existingTasks = await (database.select(database.tasks)
              ..where((t) =>
                  t.title.equals(task.title) &
                  t.startTime.equals(task.startTime)))
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
    return Response(
        statusCode: HttpStatus.internalServerError,
        body: 'Failed to import tasks: $e');
  }
}

// --- EXPORT ---

Future<Response> exportTasks(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final user = context.read<User>();
  if (!user.isParent) {
    return Response(
        statusCode: HttpStatus.forbidden,
        body: 'Only parents can export tasks');
  }

  try {
    final tasks = await database.select(database.tasks).get();
    final jsonList = tasks.map((t) => t.toJson()).toList();

    return Response.json(body: jsonList);
  } catch (e) {
    return Response(
        statusCode: HttpStatus.internalServerError,
        body: 'Failed to export tasks: $e');
  }
}

// --- PURGE ---

Future<Response> purgeTasks(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final user = context.read<User>();
  if (!user.isParent) {
    return Response(
        statusCode: HttpStatus.forbidden, body: 'Only parents can purge tasks');
  }

  try {
    // 1. Get all children usernames
    final children = await (database.select(database.users)
          ..where((u) => u.isParent.equals(false)))
        .get();
    final childrenUsernames = children.map((u) => u.username).toSet();

    if (childrenUsernames.isEmpty) {
      return Response.json(
          body: {'success': true, 'message': 'No children found'});
    }

    // 2. Get all tasks
    final allTasks = await database.select(database.tasks).get();

    // 3. Filter tasks assigned to any child
    final tasksToDelete = allTasks
        .where((task) {
          // task.assignedUsers is List<String>
          return task.assignedUsers.any(childrenUsernames.contains);
        })
        .map((t) => t.id)
        .toList();

    if (tasksToDelete.isEmpty) {
      return Response.json(
          body: {'success': true, 'message': 'No tasks to delete'});
    }

    // 4. Delete tasks
    await (database.delete(database.tasks)
          ..where((t) => t.id.isIn(tasksToDelete)))
        .go();

    return Response.json(
        body: {'success': true, 'deletedCount': tasksToDelete.length});
  } catch (e) {
    return Response.json(statusCode: 500, body: {'error': e.toString()});
  }
}
