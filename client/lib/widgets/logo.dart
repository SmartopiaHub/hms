// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class LogoWidget extends StatelessWidget {
  final double width;
  final double height;
  final double column1WidthPercent; // e.g., 0.3 for 30%
  final double column2Row1HeightPercent; // e.g., 0.6 for 60%

  const LogoWidget({
    super.key,
    this.width = 200,
    this.height = 50,
    this.column1WidthPercent = 0.25,
    this.column2Row1HeightPercent = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    double languageScaleFactor = 1.0;
    // Adjust scale factor based on locale if needed
    if (Localizations.localeOf(context).languageCode == 'zh') {
      languageScaleFactor = 0.8;
    }
    
    // Use primary color for the logo to match the theme
    final logoColor = theme.colorScheme.primary;

    return SizedBox(
      width: width,
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Column 1: Logo Image
          SizedBox(
            width: width * column1WidthPercent,
            height: height,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                'assets/images/smartopia_logo_nobg.png',
                fit: BoxFit.contain,
                color: logoColor,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),
          
          // Column 2: Text
          SizedBox(
            width: width * (1 - column1WidthPercent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Row 1: Smartopia
                Align(
                    alignment: Alignment.bottomLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        localizations.smartopia,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                          height: 1.0,
                          fontSize: height * column1WidthPercent * 1.1,
                        ),
                      ),
                    ),
                  ),
     

                SizedBox(height: 2),
                
                // Row 2: Homework Manager
                Align(
                    alignment: Alignment.topLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: Text(
                        localizations.homeworkManager,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          height: 1.2,
                          letterSpacing: 0.5,
                          fontSize: height * (1 - column2Row1HeightPercent) * languageScaleFactor,
                        ),
                      ),
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
