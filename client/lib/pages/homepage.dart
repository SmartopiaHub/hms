// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../authenticator.dart';
import 'base.dart';
import 'package:flutter/material.dart';
import '../web.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends PageBaseState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final refreshed = await _doIfReloadAfterWebRefresh();
      if (refreshed) return;

      if (mounted) {
        final auth = context.read<AuthProvider>();
        // Only redirect children to tasks automatically
        if (auth.isAuthenticated && !auth.isParent) {
          go('/tasks');
        }
      }
    });
  }

  Future<String> _getCurrentPage() async {
    var prefs = await SharedPreferences.getInstance();
    var time = prefs.getString('current_page_time');
    if (time != null) {
      var lastTime = DateTime.parse(time);
      if (DateTime.now().difference(lastTime).inMinutes > 10) {
        return prefs.getString('current_page') ?? '/';
      }
    }
    var page = prefs.getString('current_page');
    if (page == null || page == 'unknown') {
      return '/';
    }
    if (page.startsWith('/')) {
      return page;
    }
    return '/$page';
  }

  Future<bool> _doIfReloadAfterWebRefresh() async {
    final refresh = await getRefreshOrCloseEventFlag();
    var currentPage = await _getCurrentPage();
    debugPrint('Current page: $currentPage');
    
    if (refresh) {
      resetRefreshOrCloseEventFlag();
      if (currentPage != '/') {
        go(currentPage);
      }
      return true;
    }
    return false;
  }

  @override
  Widget buildContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    final features = [
      _FeatureCardData(
        icon: Icons.assignment_turned_in,
        title: l10n.feature1Title,
        description: l10n.feature1Desc,
        color: Colors.blueAccent,
      ),
      _FeatureCardData(
        icon: Icons.emoji_events,
        title: l10n.feature2Title,
        description: l10n.feature2Desc,
        color: Colors.orangeAccent,
      ),
      _FeatureCardData(
        icon: Icons.insights,
        title: l10n.feature3Title,
        description: l10n.feature3Desc,
        color: Colors.purpleAccent,
      ),
      _FeatureCardData(
        icon: Icons.family_restroom,
        title: l10n.feature4Title,
        description: l10n.feature4Desc,
        color: Colors.green,
      ),
    ];

    // Calculate max heights
    double maxTitleHeight = 0;
    double maxDescHeight = 0;
    const cardWidth = 280.0;
    const padding = 48.0; // 24 * 2
    const contentWidth = cardWidth - padding;

    for (final feature in features) {
      final titleHeight = _measureTextHeight(
        feature.title,
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        contentWidth,
      );
      final descHeight = _measureTextHeight(
        feature.description,
        const TextStyle(fontSize: 14, height: 1.5),
        contentWidth,
      );
      if (titleHeight > maxTitleHeight) maxTitleHeight = titleHeight;
      if (descHeight > maxDescHeight) maxDescHeight = descHeight;
    }

    return SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(context, l10n, isSmallScreen),
            
            // Features Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 30,
                    runSpacing: 30,
                    alignment: WrapAlignment.center,
                    children: features.map((feature) => _buildFeatureCard(
                      context,
                      data: feature,
                      titleHeight: maxTitleHeight,
                      descHeight: maxDescHeight,
                    )).toList(),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
    );
  }

  double _measureTextHeight(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.height;
  }

  Widget _buildHeroSection(BuildContext context, AppLocalizations l10n, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          if (isSmallScreen) ...[
            //Image.asset('assets/images/smartopia_logo_nobg.png', height: 120),
            //const SizedBox(height: 40),
            _buildHeroText(context, l10n, true),
          ] else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildHeroText(context, l10n, true),
                      ],
                    ),
                  ),
                ),
                //Image.asset('assets/images/smartopia_logo_nobg.png', height: 250),
                //const Expanded(child: SizedBox()),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHeroText(BuildContext context, AppLocalizations l10n, bool center) {
    return Column(
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.end,
      children: [
        Text(
          l10n.heroTitle,
          textAlign: center ? TextAlign.center : TextAlign.right,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.2,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.heroSubtitle,
          textAlign: center ? TextAlign.center : TextAlign.right,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w300,
              ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            final auth = context.read<AuthProvider>();
            if (auth.isAuthenticated) {
              go('/tasks');
            } else {
              go('/signin');
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(l10n.getStarted),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required _FeatureCardData data,
    required double titleHeight,
    required double descHeight,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 40, color: data.color),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: titleHeight,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                data.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: descHeight,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                data.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCardData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  _FeatureCardData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
