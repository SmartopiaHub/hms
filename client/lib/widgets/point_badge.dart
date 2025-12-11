// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartopia_hms_shared/shared.dart';
import '../config.dart';
import '../utils/point_icon_mapper.dart';
import '../themes/theme.dart';

class PointBadge extends StatelessWidget {
  final int points;
  final String? pointSystemId;
  final double iconSize;
  final double fontSize;
  final Color? color;
  final int? maxPoints;
  final Color? textColor;

  const PointBadge({
    super.key,
    required this.points,
    this.pointSystemId,
    this.iconSize = 20,
    this.fontSize = 14,
    this.color,
    this.maxPoints,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final configProvider = context.watch<AppConfig>();
    
    // Don't show the badge if point system is disabled
    if (!configProvider.pointSystemEnabled) {
      return const SizedBox.shrink();
    }

    final system = PointSystem.fromJson(PointSystem.defaultJsonData);
    final identity = system.getPointIdentity(pointSystemId);
    final iconData = PointIconMapper.getIcon(identity.icon);
    final displayColor = color ?? Colors.amber;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: displayColor.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: displayColor.withAlpha(77)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconData != null)
            Icon(iconData, size: iconSize, color: displayColor)
          else
            Text(identity.icon, style: TextStyle(fontSize: iconSize)),
          const SizedBox(width: 4),
          Text(
            '$points',
            style: theme.textTheme.taskCardBody.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          if (maxPoints != null) ...[
            Text(
              ' / ',
              style: theme.textTheme.taskCardBody.copyWith(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              '$maxPoints',
              style: theme.textTheme.taskCardBody.copyWith(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
