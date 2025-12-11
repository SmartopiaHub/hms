// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:math';

import 'package:flutter/foundation.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/point_badge.dart';

import '../authenticator.dart';
import '../config.dart';
import '../pages/base.dart';
import '../themes/theme.dart';
import '../widgets/card.dart';
import '../widgets/drawer_and_appbar.dart';
import '../widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class BokehPainter extends CustomPainter {
  final List<Offset> centers;
  final Random random = Random();

  BokehPainter({required this.centers});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);
    final colors = [Colors.white.withAlpha(25), Colors.white.withAlpha(5)];

    for (final center in centers) {
      paint.shader = RadialGradient(
        colors: colors,
      ).createShader(Rect.fromCircle(center: center, radius: 20));
      canvas.drawCircle(center, 20, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  static List<Offset> generateCenters(Size size, int count) {
    final Random random = Random();
    return List.generate(count, (_) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      return Offset(dx, dy);
    });
  }
}

class AnimatedBackground extends StatelessWidget {
  final Animation<double> animation;
  const AnimatedBackground({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final centers = BokehPainter.generateCenters(size, 10);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.backgroundTop,
                theme.colorScheme.backgroundBottom,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              transform: GradientRotation(animation.value),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: BokehPainter(centers: centers)),
          ),
        ),
      ],
    );
  }
}

class _AppShellState extends PageBaseState<AppShell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.2,
      end: -0.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBanner() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: buildCard(
          context,
          blur: 30,
          elevation: 0,
          color: Colors.white.withAlpha(50),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          borderRadius: BorderRadius.all(
            Radius.zero,
          ),
          child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const LogoWidget(width: 220, height: 50),
                  Spacer(),
                  ..._buildActions(context, auth),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      //appBar: buildAppBar(),
      drawer: !isWideScreen && !isMobile ? buildDrawer(context) : null,
      body: Stack(
        children: [
          AnimatedBackground(animation: _animation),
          Padding(
            padding: EdgeInsets.only(
              top: isWideScreen ? 80 : 0,
              bottom: isWideScreen ? 30 : 0,
            ),
            child: widget.child,
          ),
          if (isWideScreen) _buildBanner(),
          if (isWideScreen)
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Center(
                child: buildCard(
                  context,
                  blur: 20,
                  elevation: 0,
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "© 2025 Smartopia AI",
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "• ",
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                      InkWell(
                        onTap: () => GoRouter.of(context).go('/disclaimer'),
                        child: Text(
                          localizations.disclaimerAndPrivacy,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            //decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context, AuthProvider auth) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black.withAlpha(165),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDialogButton(
                    icon: Icons.person,
                    label: localizations.profile,
                    onTap: () {
                      Navigator.of(context).pop();
                      GoRouter.of(context).go('/profile');
                    },
                  ),
                  const SizedBox(width: 40),
                  _buildDialogButton(
                    icon: Icons.logout,
                    label: localizations.signOut,
                    onTap: () async {
                      Navigator.of(context).pop();
                      GoRouter.of(context).go('/');
                      await auth.signOut();
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.white54, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.white),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, AuthProvider auth) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final activeColor = const Color.fromARGB(115, 7, 45, 1);
    final localizations = AppLocalizations.of(context)!;
    
    return [
      if (kIsWeb)
        IconButton(
          onPressed: () => GoRouter.of(context).go('/'),
          icon: Icon(Icons.home, color: currentRoute == '/' ? activeColor : null),
          tooltip: localizations.homepage,
        ),
      if (auth.isAuthenticated) ...[
        IconButton(
          onPressed: () => GoRouter.of(context).go('/tasks'),
          icon: Icon(Icons.assignment, color: currentRoute == '/tasks' ? activeColor : null),
          tooltip: localizations.tasks,
        ),
        IconButton(
          onPressed: () => GoRouter.of(context).go('/templates'),
          tooltip: localizations.taskTemplates,
          icon: Icon(Icons.file_copy, color: currentRoute == '/templates' ? activeColor : null),
        ),
        if (context.watch<AppConfig>().pointSystemEnabled) IconButton(
          onPressed: () => GoRouter.of(context).go('/shop'),
          tooltip: localizations.shop,
          icon: Icon(Icons.store, color: currentRoute == '/shop' ? activeColor : null),
        ),
        if (auth.isParent)
          IconButton(
            onPressed: () => GoRouter.of(context).go('/settings'),
            icon: Icon(Icons.settings, color: currentRoute == '/settings' ? activeColor : null),
            tooltip: localizations.settings,
          ),
        
      ],
      IconButton(
          onPressed: () => GoRouter.of(context).go('/helper'),
          icon: Icon(Icons.help_outline, color: currentRoute == '/helper' ? activeColor : null),
          tooltip: localizations.helperWhatIsThis,
        ),
      IconButton(
        onPressed: () {
          if (context.read<AppConfig>().locale.languageCode == 'en') {
            context.read<AppConfig>().setLocale(Locale('zh'));
          } else {
            context.read<AppConfig>().setLocale(Locale('en'));
          }
        },
        icon: const Icon(Icons.language),
        tooltip: localizations.language,
      ),
      if (kIsWeb)
        IconButton(
          onPressed: () => GoRouter.of(context).go('/downloads'),
          icon: Icon(Icons.download, color: currentRoute == '/downloads' ? activeColor : null),
          tooltip: localizations.downloadClients,
        ),
      auth.isAuthenticated
          ? IconButton(
              icon: const Icon(Icons.account_circle, size: 28),
              tooltip: localizations.profile,
              onPressed: () => _showProfileDialog(context, auth),
            )
          : IconButton(
              onPressed: () => GoRouter.of(context).go('/signin'),
              icon: const Icon(Icons.login),
              tooltip: localizations.signIn,
            ),
      if (auth.isAuthenticated && !auth.isParent)
        PointBadge(points: auth.rewardPointInfo.availablePoints,
          pointSystemId: auth.pointSystemId,
          iconSize: 14,
          fontSize: 14,
        ),
    ];
  }
}
