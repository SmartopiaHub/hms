// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../base.dart';
import 'package:provider/provider.dart';
import '../../authenticator.dart';
import '../../api.dart';
import '../../widgets/point_badge.dart';

class RedemptionHistoryPage extends StatefulWidget {
  const RedemptionHistoryPage({super.key});

  @override
  State<RedemptionHistoryPage> createState() => _RedemptionHistoryPageState();
}

class _RedemptionHistoryPageState extends PageBaseState<RedemptionHistoryPage> {
  late Future<List<Map<String, dynamic>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = apiService.getRedemptions();
  }

  @override
  String get pageTitle => localizations.redemptionHistory;

  @override
  bool get goBackButtonInAppBar => true;

  @override
  Widget buildContent(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final isParent = auth.isParent;
    
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Center(child: Text(localizations.noRedemptions));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
              final item = items[index];
              final redeemedAt = DateTime.parse(item['redeemedAt']);
              final imageUrl = item['itemImageUrl'] as String?;
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          headers: auth.token != null ? {'Authorization': 'Bearer ${auth.token}'} : null,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag),
                        )
                      : const Icon(Icons.shopping_bag),
                  title: Text(item['itemTitle'] ?? localizations.unknownItem),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat.yMMMd().add_jm().format(redeemedAt)),
                      if (isParent && item['userName'] != null)
                        Text(
                          item['userName'],
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                    ],
                  ),
                  trailing: PointBadge(
                    points: item['cost'],
                    pointSystemId: auth.pointSystemId,
                    textColor: Colors.black87,
                  ),
                ),
              );
            },
          );
        },
      );
  }
}
