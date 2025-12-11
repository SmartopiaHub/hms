
// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

class ShopItem {
  final int id;
  final String title;
  final String? description;
  final String? imageUrl;
  final int cost;
  final bool isAvailable;
  final int creatorId;

  ShopItem({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.cost,
    required this.isAvailable,
    required this.creatorId,
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      cost: json['cost'] as int,
      isAvailable: json['isAvailable'] as bool,
      creatorId: json['creatorId'] as int,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'cost': cost,
      'isAvailable': isAvailable,
      'creatorId': creatorId,
    };
  }
}
