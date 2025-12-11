// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/model/database.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final itemId = int.tryParse(id);
  if (itemId == null) {
    return Response(statusCode: HttpStatus.badRequest, body: 'Invalid ID');
  }

  return switch (context.request.method) {
    HttpMethod.get => _getShopItem(context, itemId),
    HttpMethod.put => _updateShopItem(context, itemId),
    HttpMethod.delete => _deleteShopItem(context, itemId),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _getShopItem(RequestContext context, int id) async {
  final item = await (database.select(database.shopItems)..where((t) => t.id.equals(id))).getSingleOrNull();

  if (item == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  return Response.json(body: item);
}

Future<Response> _updateShopItem(RequestContext context, int id) async {
  final user = context.read<User>();
  
  if (!user.isParent) {
    return Response(statusCode: HttpStatus.forbidden, body: 'Only parents can update shop items');
  }

  final body = await context.request.json();
  final jsonBody = body as Map<String, dynamic>;

  final companion = ShopItemsCompanion(
    title: jsonBody['title'] != null ? Value(jsonBody['title'] as String) : const Value.absent(),
    cost: jsonBody['cost'] != null ? Value(jsonBody['cost'] as int) : const Value.absent(),
    description: jsonBody.containsKey('description') ? Value(jsonBody['description'] as String?) : const Value.absent(),
    imageUrl: jsonBody.containsKey('imageUrl') ? Value(jsonBody['imageUrl'] as String?) : const Value.absent(),
    isAvailable: jsonBody['isAvailable'] != null ? Value(jsonBody['isAvailable'] as bool) : const Value.absent(),
  );

  final updated = await (database.update(database.shopItems)..where((t) => t.id.equals(id))).writeReturning(companion);

  if (updated.isEmpty) {
    return Response(statusCode: HttpStatus.notFound);
  }

  return Response.json(body: updated.first);
}

Future<Response> _deleteShopItem(RequestContext context, int id) async {
  final user = context.read<User>();
  
  if (!user.isParent) {
    return Response(statusCode: HttpStatus.forbidden, body: 'Only parents can delete shop items');
  }

  final rowsAffected = await (database.delete(database.shopItems)..where((t) => t.id.equals(id))).go();

  if (rowsAffected == 0) {
    return Response(statusCode: HttpStatus.notFound);
  }

  return Response(statusCode: HttpStatus.noContent);
}
