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
    HttpMethod.get => _getTasks(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _getTasks(RequestContext context) async {
  final request = context.request;
  final page = int.tryParse(request.uri.queryParameters['page'] ?? '1') ?? 1;
  final limit = int.tryParse(request.uri.queryParameters['limit'] ?? '20') ?? 20;
  final offset = (page - 1) * limit;

  final tasks = await (database.select(database.tasks)
      ..orderBy([
        // order by startTime ascending
        (t) => OrderingTerm(
          expression: t.startTime,
          mode: OrderingMode.desc,
        ),
      ])
      ..limit(limit, offset: offset))
    .get();

  return Response.json(body: tasks);
}


