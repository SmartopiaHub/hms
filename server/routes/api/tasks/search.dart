// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/logger.dart';
import 'package:smartopia_hms_server/model/database.dart';

// GET all users or POST to create a new user
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _getTasks(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

// get tasks based on query parameters (in json format)
// json body should contain a map with the following keys:
// - page: the page number to retrieve (default: 1)
// - limit: the number of tasks to retrieve per page (default: 20)
// - sort: the field to sort by (default: startTime)
// - order: the order to sort by (default: desc)
// - filter: a map of filters to apply to the tasks (optional)
//   - filter can contain the following keys:
//     - start: a DateTime to filter tasks by start time
//     - end: a DateTime to filter tasks by end time
//     - assignedUsers: a list of usernames to filter tasks by assigned users
//     - status: a list of task statuses to filter tasks by status
Future<Response> _getTasks(RequestContext context) async {

  try {

    /*
    final canceled = (await database.select(database.tasks).get()).where((task) => task.cancelled).toList();
    for (final task in canceled) {
      await database.delete(database.tasks).delete(task);
    }

    final futures = (await database.select(database.tasks).get()).where((task) => !task.isStarted).toList();
    for (final task in futures) {
      if (task.startTime.isAfter(DateTime.now())) {
        logError('Task ${task.id} has start time after now, deleting it');
        await database.delete(database.tasks).delete(task);
      }
    }*/

    final body = await context.request.json();
    final jsonBody = body as Map<String, dynamic>;
    final page = int.tryParse(jsonBody['page']?.toString() ?? '1') ?? 1;
    final limit = int.tryParse(jsonBody['limit']?.toString() ?? '20') ?? 20;
    final filter = jsonBody['filter'] as Map<String, dynamic>? ?? {};
    final sort = jsonBody['sort']?.toString() ?? 'startTime';
    final order = jsonBody['order']?.toString() ?? 'desc';
    final statuses = (filter['statuses'] as List<dynamic>).map((e) => TaskStatus.values.firstWhere(
          (s) => s.name == e.toString(),
        )).toList();
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
    /*
    if (start != null && end != null) {
      query.where((t) => (t.startTime.isBiggerOrEqualValue(start) | 
        t.dueTime.isSmallerOrEqualValue(end)) & t.startTime.isSmallerOrEqualValue(end));
    }
    else if (end != null) {
      query.where((t) => t.startTime.isSmallerOrEqualValue(end));
    }
    else if (start != null) {
      query.where((t) => t.startTime.isBiggerOrEqualValue(start));
    }*/
    var tasks = await query.get();

    final now = DateTime.now();

    if (!statuses.contains(TaskStatus.overdue)){
      tasks = tasks.where((t)=>!t.isOverdue).toList();
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
    
    tasks = tasks.where(
        (task) => ((start == null || task.startTime.isAfter(start)) && (end == null || !task.startTime.isAfter(end))) || 
          ((start == null || task.dueTime.isAfter(start))) ||
          (start == null || (task.isOverdue && task.startTime.isBefore(start))) && (end == null || (task.isOverdue && task.dueTime.isBefore(end)))
    ).toList();
    
    // if included not started tasks, we need to include future occurrences of task templates within [start] and [end]
    if (statuses.contains(TaskStatus.notStarted) && end!=null && end.isAfter(now)) {
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
                task.templateId == template.id &&
                task.startTime == occurrence,
          );
          if (existingTask == -1) {
            // if not, check whether it is a cancellled occurrence
            final cancelledTask = await (database.select(database.tasks)
                  ..where((t) =>
                    t.templateId.equals(template.id) &
                    t.startTime.equals(occurrence) &
                    t.cancelled.equals(true),
                  ))
                .getSingleOrNull();
            if (cancelledTask == null) { // not cancelled, create a new task instance
              final newTask = template.createTaskInstance(occurrence);
              tasks.add(newTask);
              // insert the new task into the database if it not due yet but started
              if (newTask.dueTime.isAfter(now) && newTask.startTime.isBefore(now)) {
                //logError('Task ${newTask.title} has started but not due yet, inserting into database');
                final companion = template.createTaskInstance(occurrence).toCompanion(true).copyWith(id: const Value.absent());
                await database.into(database.tasks).insert(companion);
              }
            }
          } 
          else{
            final t = tasks[existingTask];
            if (t.dueTime.isBefore(t.startTime) || t.startTime.isAfter(now)){
              logError('Task ${t.id} has due time before start time, deleting it');
            }
          }
        }
      }
    }

    if (!statuses.contains(TaskStatus.cancelled)) {
      tasks = tasks.where((task) => !task.cancelled).toList();
    }


    if (assignedUsers != null && assignedUsers.isNotEmpty) {
      tasks = tasks.where((task) => task.assignedUsers.any(
        assignedUsers.contains,
      )).toList();
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
  }
  catch (e, st) {
    logError('Error parsing JSON body: $e', e, st);
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid JSON format'},
    );
  }
}


