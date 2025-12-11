// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/model/database.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _purgeTasks(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _purgeTasks(RequestContext context) async {
  final user = context.read<User>();
  if (!user.isParent) {
    return Response(statusCode: HttpStatus.forbidden, body: 'Only parents can purge tasks');
  }

  try {
    // 1. Get all children usernames
    final children = await (database.select(database.users)
      ..where((u) => u.isParent.equals(false)))
      .get();
    final childrenUsernames = children.map((u) => u.username).toSet();

    if (childrenUsernames.isEmpty) {
       return Response.json(body: {'success': true, 'message': 'No children found'});
    }

    // 2. Get all tasks
    final allTasks = await database.select(database.tasks).get();

    // 3. Filter tasks assigned to any child
    final tasksToDelete = allTasks.where((task) {
      // task.assignedUsers is List<String>
      return task.assignedUsers.any(childrenUsernames.contains);
    }).map((t) => t.id).toList();

    if (tasksToDelete.isEmpty) {
      return Response.json(body: {'success': true, 'message': 'No tasks to delete'});
    }

    // 4. Delete tasks
    await (database.delete(database.tasks)
      ..where((t) => t.id.isIn(tasksToDelete)))
      .go();

    return Response.json(body: {'success': true, 'deletedCount': tasksToDelete.length});
  } catch (e) {
    return Response.json(statusCode: 500, body: {'error': e.toString()});
  }
}
