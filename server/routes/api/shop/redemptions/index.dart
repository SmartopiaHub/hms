// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/model/database.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  return _getRedemptions(context);
}

Future<Response> _getRedemptions(RequestContext context) async {
  final user = context.read<User>();
  
  final request = context.request;
  final page = int.tryParse(request.uri.queryParameters['page'] ?? '1') ?? 1;
  final limit = int.tryParse(request.uri.queryParameters['limit'] ?? '20') ?? 20;
  final offset = (page - 1) * limit;

  // Query redemptions directly (item details are now stored in the table)
  // Parents can see all redemptions, children only see their own
  final query = database.select(database.redemptions);
  if (!user.isParent) {
    query.where((r) => r.userId.equals(user.id));
  }
  query
    ..orderBy([(r) => OrderingTerm(expression: r.redeemedAt, mode: OrderingMode.desc)])
    ..limit(limit, offset: offset);

  final redemptions = await query.get();

  // For parents, also include user information
  final results = await Future.wait(redemptions.map((redemption) async {
    final result = {
      'id': redemption.id,
      'userId': redemption.userId,
      'cost': redemption.cost,
      'redeemedAt': redemption.redeemedAt.toIso8601String(),
      'itemTitle': redemption.itemTitle,
      'itemImageUrl': redemption.itemImageUrl,
    };
    
    // If parent, include the child's name
    if (user.isParent) {
      final redeemer = await (database.select(database.users)..where((u) => u.id.equals(redemption.userId))).getSingleOrNull();
      if (redeemer != null) {
        result['userName'] = redeemer.nickname ?? redeemer.username;
      }
    }
    
    return result;
  }));

  return Response.json(body: results);
}
