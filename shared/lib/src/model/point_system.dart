// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:convert';

class PointIdentity {
  final String id;
  final String nameEn;
  final String nameZh;
  final String icon;

  PointIdentity({
    required this.id,
    required this.nameEn,
    required this.nameZh,
    required this.icon,
  });

  factory PointIdentity.fromJson(Map<String, dynamic> json) {
    return PointIdentity(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameZh: json['nameZh'] as String,
      icon: json['icon'] as String? ?? 'star',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameZh': nameZh,
      'icon': icon,
    };
  }
}

class PointSystem {
  final List<PointIdentity> points;

  PointSystem(this.points);

  factory PointSystem.fromJson(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    final points = jsonList.map((e) => PointIdentity.fromJson(e as Map<String, dynamic>)).toList();
    return PointSystem(points);
  }

  PointIdentity getPointIdentity(String? id) {
    if (id == null) return points.first;
    return points.firstWhere((element) => element.id == id, orElse: () => points.first);
  }
  
  static const String defaultJsonData = '''
[
  {
    "id": "stars",
    "nameEn": "Star Points",
    "nameZh": "星星点数 / 小星星",
    "icon": "⭐"
  },
  {
    "id": "magic_sparks",
    "nameEn": "Magic Sparks",
    "nameZh": "魔法火花",
    "icon": "✨"
  },
  {
    "id": "dream_dust",
    "nameEn": "Dream Dust",
    "nameZh": "梦幻小尘",
    "icon": "🎇"
  },
  {
    "id": "wonder_gems",
    "nameEn": "Wonder Gems",
    "nameZh": "奇迹宝石",
    "icon": "💎"
  },
  {
    "id": "moon_coins",
    "nameEn": "Moon Coins",
    "nameZh": "月亮币",
    "icon": "🌙"
  },
  {
    "id": "fairy_seeds",
    "nameEn": "Fairy Seeds",
    "nameZh": "仙子种子",
    "icon": "🌱"
  },
  {
    "id": "gold_beans",
    "nameEn": "Gold Beans",
    "nameZh": "金豆豆",
    "icon": "🟡"
  },
  {
    "id": "happy_beans",
    "nameEn": "Happy Beans",
    "nameZh": "快乐豆",
    "icon": "😄"
  },
  {
    "id": "sparkle_coins",
    "nameEn": "Sparkle Coins",
    "nameZh": "闪闪币",
    "icon": "🪙"
  },
  {
    "id": "joy_bubbles",
    "nameEn": "Joy Bubbles",
    "nameZh": "欢乐泡泡",
    "icon": "🫧"
  },
  {
    "id": "rainbow_drops",
    "nameEn": "Rainbow Drops",
    "nameZh": "彩虹滴",
    "icon": "🌈"
  },
  {
    "id": "smile_tokens",
    "nameEn": "Smile Tokens",
    "nameZh": "笑笑币",
    "icon": "😊"
  },
  {
    "id": "paw_points",
    "nameEn": "Paw Points",
    "nameZh": "爪爪点",
    "icon": "🐾"
  },
  {
    "id": "cub_coins",
    "nameEn": "Cub Coins",
    "nameZh": "小熊币",
    "icon": "🐻"
  },
  {
    "id": "kitty_stars",
    "nameEn": "Kitty Stars",
    "nameZh": "小猫星",
    "icon": "🐱"
  },
  {
    "id": "bunny_carrots",
    "nameEn": "Bunny Carrots",
    "nameZh": "小兔胡萝卜",
    "icon": "🥕"
  },
  {
    "id": "penguin_pebbles",
    "nameEn": "Penguin Pebbles",
    "nameZh": "企鹅小石",
    "icon": "🐧"
  },
  {
    "id": "treasure_tokens",
    "nameEn": "Treasure Tokens",
    "nameZh": "宝藏币",
    "icon": "💰"
  },
  {
    "id": "explorer_points",
    "nameEn": "Explorer Points",
    "nameZh": "探险点数",
    "icon": "🧭"
  },
  {
    "id": "adventure_gems",
    "nameEn": "Adventure Gems",
    "nameZh": "冒险宝石",
    "icon": "💎"
  },
  {
    "id": "captain_coins",
    "nameEn": "Captain Coins",
    "nameZh": "船长币",
    "icon": "⚓"
  },
  {
    "id": "quest_stars",
    "nameEn": "Quest Stars",
    "nameZh": "任务星",
    "icon": "🎖️"
  },
  {
    "id": "candy_points",
    "nameEn": "Candy Points",
    "nameZh": "糖果点点",
    "icon": "🍬"
  },
  {
    "id": "cookie_coins",
    "nameEn": "Cookie Coins",
    "nameZh": "曲奇币",
    "icon": "🍪"
  },
  {
    "id": "fruit_gems",
    "nameEn": "Fruit Gems",
    "nameZh": "果果宝石",
    "icon": "🍎"
  },
  {
    "id": "honey_drops",
    "nameEn": "Honey Drops",
    "nameZh": "蜜糖滴",
    "icon": "🍯"
  },
  {
    "id": "milk_stars",
    "nameEn": "Milk Stars",
    "nameZh": "牛奶星",
    "icon": "🥛"
  },
  {
    "id": "cuddle_points",
    "nameEn": "Cuddle Points",
    "nameZh": "抱抱点",
    "icon": "🫂"
  },
  {
    "id": "dream_beans",
    "nameEn": "Dream Beans",
    "nameZh": "梦豆豆",
    "icon": "🫘"
  },
  {
    "id": "warm_stars",
    "nameEn": "Warm Stars",
    "nameZh": "暖星星",
    "icon": "🌟"
  },
  {
    "id": "hug_tokens",
    "nameEn": "Hug Tokens",
    "nameZh": "拥抱币",
    "icon": "🤗"
  }
]
''';
}
