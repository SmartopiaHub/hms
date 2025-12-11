// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;

  const ResponsiveLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: ResponsiveValue<double>(context, defaultValue: 800, conditionalValues: [
        Condition.between(start: 0, end: 450, value: 400),
        Condition.between(start: 451, end: 1000, value: 600),
        Condition.between(start: 1001, end: 1300, value: 800),
        Condition.between(start: 1301, end: 1600, value: 1100),
        Condition.between(start: 1600, end: 2000, value: 1400),
        Condition.largerThan(breakpoint: 2000, value: 1800),
      ]).value,
      child: child,
    );
  }
}