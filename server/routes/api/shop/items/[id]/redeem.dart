// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/model/database.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final itemId = int.tryParse(id);
  if (itemId == null) {
    return Response(statusCode: HttpStatus.badRequest, body: 'Invalid ID');
  }

  return _redeemItem(context, itemId);
}

Future<Response> _redeemItem(RequestContext context, int itemId) async {
  final user = context.read<User>();
  
  // 1. Get the item
  final item = await (database.select(database.shopItems)..where((t) => t.id.equals(itemId))).getSingleOrNull();

  if (item == null) {
    return Response(statusCode: HttpStatus.notFound, body: 'Item not found');
  }

  if (!item.isAvailable) {
    return Response(statusCode: HttpStatus.badRequest, body: 'Item is not available');
  }

  // 2. Check points
  final currentPoints = user.totalPoints - user.redeemedPoints;
  if (currentPoints < item.cost) {
    return Response(statusCode: HttpStatus.badRequest, body: 'Not enough points');
  }

  // 3. Update redeemedPoints
  // We need to fetch the user again to ensure we have the latest points (optimistic locking or transaction would be better but simple update is fine for now)
  // Actually, let's do it in a transaction to be safe.
  
  try {
    await database.transaction(() async {
      final dbUser = await (database.select(database.users)..where((u) => u.id.equals(user.id))).getSingle();
      
      if ((dbUser.totalPoints - dbUser.redeemedPoints) < item.cost) {
        throw Exception('Not enough points');
      }

      await (database.update(database.users)..where((u) => u.id.equals(user.id))).write(
        UsersCompanion(
          redeemedPoints: Value(dbUser.redeemedPoints + item.cost),
        ),
      );

      // Record redemption with item details snapshot
      await database.into(database.redemptions).insert(
        RedemptionsCompanion.insert(
          userId: user.id,
          itemTitle: item.title,
          itemImageUrl: Value(item.imageUrl),
          cost: item.cost,
        ),
      );
    });
  } catch (e) {
    if (e.toString().contains('Not enough points')) {
       return Response(statusCode: HttpStatus.badRequest, body: 'Not enough points');
    }
    rethrow;
  }

  // Return the updated user or success message
  final updatedUser = await (database.select(database.users)..where((u) => u.id.equals(user.id))).getSingle();
  return Response.json(body: updatedUser);
}
