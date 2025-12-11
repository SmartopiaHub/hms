// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';

class PointIconMapper {
  static IconData? getIcon(String iconName) {
    switch (iconName) {
      case 'star': return Icons.star;
      case 'auto_awesome': return Icons.auto_awesome;
      case 'blur_on': return Icons.blur_on;
      case 'diamond': return Icons.diamond;
      case 'nightlight_round': return Icons.nightlight_round;
      case 'grass': return Icons.grass;
      case 'lens': return Icons.lens;
      case 'sentiment_satisfied_alt': return Icons.sentiment_satisfied_alt;
      case 'monetization_on': return Icons.monetization_on;
      case 'bubble_chart': return Icons.bubble_chart;
      case 'palette': return Icons.palette;
      case 'sentiment_very_satisfied': return Icons.sentiment_very_satisfied;
      case 'pets': return Icons.pets;
      case 'catching_pokemon': return Icons.catching_pokemon;
      case 'cruelty_free': return Icons.cruelty_free;
      case 'eco': return Icons.eco;
      case 'landscape': return Icons.landscape;
      case 'inventory_2': return Icons.inventory_2;
      case 'explore': return Icons.explore;
      case 'terrain': return Icons.terrain;
      case 'anchor': return Icons.anchor;
      case 'military_tech': return Icons.military_tech;
      case 'cake': return Icons.cake;
      case 'cookie': return Icons.cookie;
      case 'nutrition': return Icons.local_dining;
      case 'water_drop': return Icons.water_drop;
      case 'local_drink': return Icons.local_drink;
      case 'favorite': return Icons.favorite;
      case 'cloud': return Icons.cloud;
      case 'wb_sunny': return Icons.wb_sunny;
      case 'volunteer_activism': return Icons.volunteer_activism;
      default: return null;
    }
  }
}
