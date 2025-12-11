// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';

Widget buildCard(BuildContext context, {
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
  BorderRadius? borderRadius,
  required Widget child,
  double elevation = 8,
  double blur = 10,
  Color? color,
})
{
  final theme = Theme.of(context);
  final card = BlurryContainer(
    blur: blur,
    color: color ?? theme.colorScheme.surface.withAlpha(60),
    borderRadius: borderRadius ?? BorderRadius.circular(16),
    elevation: elevation,
    padding: padding ?? EdgeInsets.all(8),
    child: child,
  );

  if (margin != null) {
    return Padding(
      padding: margin,
      child: card,
    );
  }

  return card;
}