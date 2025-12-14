// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../base.dart';
import '../../api.dart';
import '../../model/database.dart';
import '../../widgets/point_badge.dart';
import '../../authenticator.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'shop_admin_page.dart';
import 'shop_item_detail_page.dart';

class ShopListPage extends StatefulWidget {
  const ShopListPage({super.key});

  @override
  State<ShopListPage> createState() => _ShopListPageState();
}

class _ShopListPageState extends PageBaseState<ShopListPage> {
  late Future<List<ShopItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = apiService.getShopItems();
  }

  @override
  String get pageTitle => AppLocalizations.of(context)!.rewardsShop;

  @override
  Widget buildFloatingActionButton(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (auth.isParent)
            Builder(
              builder: (ctx) {
                return FloatingActionButton(
                  heroTag: 'adminFab',
                  mini: true,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShopAdminPage(),
                      ),
                    ).then((_) {
                      setState(() {
                        _itemsFuture = apiService.getShopItems();
                      });
                    });
                  },
                  child: const Icon(Icons.edit),
                );
              },
            ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'historyFab',
            mini: true,
            onPressed: () {
              GoRouter.of(context).push('/shop/history');
            },
            child: const Icon(Icons.history),
          ),
        ],
      ),
    );
  }

  @override
  List<Widget> buildActionsForWideScreen(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final isParent = auth.isParent;
    return [
      IconButton(
        icon: const Icon(Icons.history),
        onPressed: () {
          GoRouter.of(context).push('/shop/history');
        },
      ),
      if (isParent)
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ShopAdminPage()),
            ).then((_) {
              setState(() {
                _itemsFuture = apiService.getShopItems();
              });
            });
          },
        ),
    ];
  }

  @override
  Widget buildContent(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: FutureBuilder<List<ShopItem>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Center(child: Text(localizations.noItemsAvailable));
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShopItemDetailPage(item: item),
                    ),
                  ).then((redeemed) {
                    if (redeemed == true) {
                      auth.refreshPoints();
                    }
                  });
                },
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child:
                            item.imageUrl != null && item.imageUrl!.isNotEmpty
                                ? Image.network(
                                  item.imageUrl!,
                                  fit: BoxFit.contain,
                                  headers:
                                      auth.token != null
                                          ? {
                                            'Authorization':
                                                'Bearer ${auth.token}',
                                          }
                                          : null,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.shopping_bag,
                                            size: 48,
                                          ),
                                )
                                : const Icon(Icons.shopping_bag, size: 48),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.title,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            PointBadge(
                              points: item.cost,
                              pointSystemId: auth.pointSystemId,
                              textColor: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/*
appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.rewardsShop),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              GoRouter.of(context).push('/shop/history');
            },
          ),
          if (isParent)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopAdminPage()),
                ).then((_) {
                  setState(() {
                    _itemsFuture = apiService.getShopItems();
                  });
                });
              },
            ),
        ],
      ),
      */
