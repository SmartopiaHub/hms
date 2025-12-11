// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:blurrycontainer/blurrycontainer.dart';
import '../config.dart';
import '../widgets/logo.dart';
import '../widgets/point_badge.dart';

import '../authenticator.dart';
import '../themes/theme.dart';
import '../widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

Drawer buildDrawer(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  final auth = context.read<AuthProvider>();
  final isAuthenticated = auth.isAuthenticated;
  final currentRoute = GoRouterState.of(context).uri.path;
  final activeColor = const Color.fromARGB(115, 7, 45, 1);
  
  return Drawer(
    backgroundColor: Colors.transparent,
      child: BlurryContainer(
        blur: 20,
        height: MediaQuery.of(context).size.height,
        borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
        color: Colors.white.withAlpha(180),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  LogoWidget(width: 180, height: 40),
                                  Expanded(child: Container()),
                                 
                                  if(isAuthenticated) 
                                    Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: 10,
                                      children: [
                                        Text(
                                          localizations.helloUser(auth.username ?? ''),
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                        
                                        if (!auth.isParent && context.read<AppConfig>().pointSystemEnabled)
                                          PointBadge(points: auth.rewardPointInfo.availablePoints,
                                            pointSystemId: auth.pointSystemId,
                                            iconSize: 16,
                                            fontSize: 12,
                                          ),
                                      ],
                                    ),
                                  ),
                                  
                                ],
                              ),
                  ),
                  if (isAuthenticated) ...[
                    
                    ListTile(
                      leading: Icon(Icons.task, color: currentRoute == '/tasks' ? activeColor : null),
                      title: Text(localizations.tasks, style: currentRoute == '/tasks' ? TextStyle(color: activeColor, fontWeight: FontWeight.bold) : null),
                      onTap: () {
                        GoRouter.of(context).go('/tasks');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.file_copy, color: currentRoute == '/templates' ? activeColor : null),
                      title: Text(localizations.taskTemplates, style: currentRoute == '/templates' ? TextStyle(color: activeColor, fontWeight: FontWeight.bold) : null),
                      onTap: () {
                        GoRouter.of(context).go('/templates');
                      },
                    ),
                    if (context.read<AppConfig>().pointSystemEnabled && auth.isParent) ListTile(
                      leading: Icon(Icons.store, color: currentRoute == '/shop' ? activeColor : null),
                      title: Text(localizations.shop, style: currentRoute == '/shop' ? TextStyle(color: activeColor, fontWeight: FontWeight.bold) : null),
                      onTap: () {
                        GoRouter.of(context).go('/shop');
                      },
                    ),
                    if (auth.isParent)
                      ListTile(
                        leading: Icon(Icons.settings, color: currentRoute == '/settings' ? activeColor : null),
                        title: Text(localizations.settings, style: currentRoute == '/settings' ? TextStyle(color: activeColor, fontWeight: FontWeight.bold) : null),
                        onTap: () {
                          GoRouter.of(context).go('/settings');
                        },
                      ),
                    Divider(),
                  ],
                  
                  
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(localizations.language),
                    onTap: (){
                        if (context.read<AppConfig>().locale.languageCode == 'en') {
                        context.read<AppConfig>().setLocale(Locale('zh'));
                        } else {
                          context.read<AppConfig>().setLocale(Locale('en'));
                        }
                    },
                  ),
                  ListTile(
                    leading: isAuthenticated ? const Icon(Icons.logout) : const Icon(Icons.login),
                    title: Text(isAuthenticated ? localizations.signOut : localizations.signIn),
                    onTap: () async {
                      if (isAuthenticated) {
                        await auth.signOut();
                        if (context.mounted) {
                          GoRouter.of(context).go('/');
                        }
                      } else {
                        GoRouter.of(context).go('/signin');
                      }
                    },
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ListTile(
                    leading: Icon(Icons.help_outline, color: currentRoute == '/helper' ? activeColor : null),
                    title: Text(localizations.helperWhatIsThis, style: currentRoute == '/helper' ? TextStyle(color: activeColor, fontWeight: FontWeight.bold) : null),
                    onTap: () {
                      GoRouter.of(context).go('/helper');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline, color: currentRoute == '/disclaimer' ? activeColor : null),
                    title: Text(localizations.disclaimerAndPrivacy, style: currentRoute == '/disclaimer' ? TextStyle(color: activeColor, fontWeight: FontWeight.bold) : null),
                    onTap: () {
                      GoRouter.of(context).go('/disclaimer');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

}

Widget buildAppBar(BuildContext context, String title, {bool goBackButton = false, List<Widget>? actions} ) {
  final theme = Theme.of(context);
  final width = MediaQuery.of(context).size.width;
  final sideWidth = width * 0.15; // 15% of the width
  return Material(
    color: Colors.transparent,
    child: buildCard(context,
          blur: 30,
          elevation: 0,
          color: Colors.white.withAlpha(50),
          //padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          borderRadius: BorderRadius.all(Radius.zero), //BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: sideWidth, child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        goBackButton
                            ? IconButton(
                                icon: Icon(Icons.arrow_back, 
                                  size: theme.textTheme.appBarTitle.fontSize,
                                  color: theme.textTheme.appBarTitle.color,
                                ),
                                onPressed: () => GoRouter.of(context).pop(),
                              )
                            :
                        Builder(builder: (ctx) => IconButton(
                          icon: Icon(Icons.menu, 
                            size: theme.textTheme.appBarTitle.fontSize,
                                  color: theme.textTheme.appBarTitle.color,),
                          onPressed: () => Scaffold.of(ctx).openDrawer(),
                        )),
                      ],
                    )
              ),
              Expanded(flex: 1, child: Center( child: Text(title, style: theme.textTheme.appBarTitle,),),), // Spacer to center the title
              SizedBox(width: sideWidth, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: actions ?? [],)), // Spacer to center the title
            ],
          ),
    ),
        );
  /*return AppBar(
    backgroundColor: Colors.transparent,
    title: Text(title, style: theme.textTheme.appBarTitle),
    actions: actions,
    leading: goBackButton
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => GoRouter.of(context).pop(),
          )
        : null,
  );*/
}