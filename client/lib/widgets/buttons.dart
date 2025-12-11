// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';

Widget buildElevatedButton({
  required BuildContext context,
  required String label,
  IconData? icon,
  VoidCallback? onPressed,
  Widget? child,
}) {
  if (icon == null) {
    return ElevatedButton(
      style: MyAppTheme.glassButtonStyle(),
      onPressed: onPressed,
      child: child ?? Text(label, style: const TextStyle(color: Colors.white70) ),
    );
  }
  return ElevatedButton.icon(
    style: MyAppTheme.glassButtonStyle(),
    label: Text(label, style: const TextStyle(color: Colors.white70) ),
    icon: Icon(icon, color: Colors.white70),
    onPressed: onPressed,
  );
}

Widget buildGoBackButton(BuildContext context, {VoidCallback? onPressed}) {
  final loc = AppLocalizations.of(context);
    return ElevatedButton.icon(
      style:  MyAppTheme.glassGoBackButtonStyle(),
      label: Text(loc?.goBackButtonText ?? 'Go Back', style: const TextStyle(color: MyAppTheme.buttonLabelColor) ),
      icon: const Icon(Icons.arrow_back, color: MyAppTheme.buttonLabelColor),
      onPressed: onPressed ?? () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          GoRouter.of(context).go('/');
        }
      },
    );
}