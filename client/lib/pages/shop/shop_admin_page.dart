// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../base.dart';
import '../../authenticator.dart';
import '../../api.dart';
import '../../model/shop_item.dart';
import 'shop_item_edit_page.dart';

class ShopAdminPage extends StatefulWidget {
  const ShopAdminPage({super.key});

  @override
  State<ShopAdminPage> createState() => _ShopAdminPageState();
}

class _ShopAdminPageState extends PageBaseState<ShopAdminPage> {
  late Future<List<ShopItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = apiService.getShopItems(showAll: true);
  }

  @override
  String get pageTitle => AppLocalizations.of(context)!.manageShopItems;

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ShopItemEditPage(),
          ),
        );
        if (result == true && mounted) {
          setState(() {
            _itemsFuture = apiService.getShopItems(showAll: true);
          });
        }
      },
      child: const Icon(Icons.add),
    );
  }

  Future<void> _deleteItem(int id) async {
    try {
      await apiService.deleteShopItem(id);
      setState(() {
        _itemsFuture = apiService.getShopItems(showAll: true);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete item: $e')),
        );
      }
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final auth = context.read<AuthProvider>();
    
    return FutureBuilder<List<ShopItem>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(
                        item.imageUrl!, 
                        width: 50, 
                        height: 50, 
                        fit: BoxFit.cover, 
                        headers: auth.token != null ? {'Authorization': 'Bearer ${auth.token}'} : null,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag)
                      )
                    : const Icon(Icons.shopping_bag),
                title: Text(item.title),
                subtitle: Text('${item.cost} points - ${item.isAvailable ? localizations.available : localizations.unavailable}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShopItemEditPage(item: item),
                          ),
                        );
                        if (result == true && mounted) {
                          setState(() {
                            _itemsFuture = apiService.getShopItems(showAll: true);
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteItem(item.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
    );
  }


}

/*
Scaffold(
      appBar: AppBar(
        title: Text(localizations.manageShopItems),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEditDialog(context, auth);
        },
        child: const Icon(Icons.add),
      ),
      body: 
      */