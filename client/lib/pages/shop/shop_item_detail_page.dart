// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../api.dart';
import '../../model/database.dart';
import '../../widgets/point_badge.dart';
import '../../authenticator.dart';
import 'package:provider/provider.dart';

class ShopItemDetailPage extends StatefulWidget {
  final ShopItem item;

  const ShopItemDetailPage({super.key, required this.item});

  @override
  State<ShopItemDetailPage> createState() => _ShopItemDetailPageState();
}

class _ShopItemDetailPageState extends State<ShopItemDetailPage> {
  bool _isRedeeming = false;

  Future<void> _redeemItem() async {
    final localizations = AppLocalizations.of(context)!;
    setState(() {
      _isRedeeming = true;
    });

    try {
      final user = await apiService.redeemShopItem(widget.item.id);
      if (mounted) {
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.redeemedSuccessfully)),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to redeem item')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to redeem item: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRedeeming = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final canRedeem =
        (auth.rewardPointInfo.availablePoints) >= widget.item.cost;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.item.title),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  if (widget.item.imageUrl != null &&
                      widget.item.imageUrl!.isNotEmpty)
                    Image.network(
                      widget.item.imageUrl!,
                      height: 300,
                      fit: BoxFit.contain,
                      headers:
                          auth.token != null
                              ? {'Authorization': 'Bearer ${auth.token}'}
                              : null,
                      errorBuilder:
                          (context, error, stackTrace) => const SizedBox(
                            height: 300,
                            child: Icon(Icons.shopping_bag, size: 100),
                          ),
                    )
                  else
                    const SizedBox(
                      height: 300,
                      child: Icon(Icons.shopping_bag, size: 100),
                    ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.item.title,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            PointBadge(
                              points: widget.item.cost,
                              pointSystemId: auth.pointSystemId,
                              textColor: Colors.black54,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (widget.item.description != null &&
                            widget.item.description!.isNotEmpty) ...[
                          /*Text(
                      localizations.description,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),*/
                          Text(widget.item.description!),
                          const SizedBox(height: 24),
                        ],
                        if (!auth.isParent)
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed:
                                  _isRedeeming ||
                                          !canRedeem ||
                                          !widget.item.isAvailable
                                      ? null
                                      : _redeemItem,
                              child:
                                  _isRedeeming
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : Text(
                                        widget.item.isAvailable
                                            ? (canRedeem
                                                ? localizations.redeem
                                                : localizations.notEnoughPoints)
                                            : localizations.unavailable,
                                      ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
