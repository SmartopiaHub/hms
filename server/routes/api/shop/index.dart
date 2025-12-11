// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/model/database.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getShopItems(context),
    HttpMethod.post => _createShopItem(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _getShopItems(RequestContext context) async {
  final request = context.request;
  final page = int.tryParse(request.uri.queryParameters['page'] ?? '1') ?? 1;
  final limit = int.tryParse(request.uri.queryParameters['limit'] ?? '20') ?? 20;
  final offset = (page - 1) * limit;

  // Only show available items by default, unless 'all' is specified
  final showAll = request.uri.queryParameters['all'] == 'true';

  final query = database.select(database.shopItems);
  if (!showAll) {
    query.where((t) => t.isAvailable.equals(true));
  }
  
  final items = await (query
      ..limit(limit, offset: offset)
      ..orderBy([
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
      ]))
      .get();

  return Response.json(body: items);
}

Future<Response> _createShopItem(RequestContext context) async {
  final user = context.read<User>();
  
  // Only parents can create shop items
  if (!user.isParent) {
    return Response(statusCode: HttpStatus.forbidden, body: 'Only parents can create shop items');
  }

  final body = await context.request.json();
  final jsonBody = body as Map<String, dynamic>;

  // Validate required fields
  if (jsonBody['title'] == null || jsonBody['cost'] == null) {
    return Response(statusCode: HttpStatus.badRequest, body: 'Title and cost are required');
  }

  final companion = ShopItemsCompanion.insert(
    title: jsonBody['title'] as String,
    cost: jsonBody['cost'] as int,
    description: Value(jsonBody['description'] as String?),
    imageUrl: Value(jsonBody['imageUrl'] as String?),
    isAvailable: Value(jsonBody['isAvailable'] as bool? ?? true),
    creatorId: user.id,
  );

  final item = await database.into(database.shopItems).insertReturning(companion);

  return Response.json(body: item);
}
