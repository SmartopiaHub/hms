// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../authenticator.dart';
import '../config.dart';
import '../server.dart';
import '../themes/theme.dart';
import '../widgets/drawer_and_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../l10n/app_localizations.dart';

class StatelessPageBase extends StatelessWidget {
  const StatelessPageBase({super.key});

  bool isWideScreen(BuildContext context) {
    return ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP);
  }
  bool isMobile(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isMobile;
  }
  bool isTablet(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isTablet;
  }
  bool isDesktop(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isDesktop;
  }
  bool largerThanMobile(BuildContext context) {
    return ResponsiveBreakpoints.of(context).largerThan(MOBILE);
  }
  bool largerThanTablet(BuildContext context) {
    return ResponsiveBreakpoints.of(context).largerThan(TABLET);
  }
  bool largerThanDesktop(BuildContext context) {
    return ResponsiveBreakpoints.of(context).largerThan(DESKTOP);
  }
  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
  
  bool isAuthenticated(BuildContext context) {
    return context.read<AuthProvider>().isAuthenticated;
  }
  bool isParent(BuildContext context) {
    return context.read<AuthProvider>().isParent;
  }

  Widget? buildFloatingActionButton(BuildContext context) {
    return null; // Override in subclasses if needed
  }

  Drawer? buildEndDrawer(BuildContext context) {
    return null; // Override in subclasses if needed
  }

  List<Widget> buildActionsForWideScreen(BuildContext context) {
    return []; // Override in subclasses if needed
  }

  bool goBackButtonInAppBar(BuildContext context) => false;

  bool includePageTitleForWideScreen(BuildContext context) => true;

  String pageTitle(BuildContext context) => '';

  Widget buildContent(BuildContext context) {
    return Container(); // Override in subclasses to provide content
  }

  @override
  Widget build(BuildContext context) {
    if (!context.mounted) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    //final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: !isWideScreen(context) ? buildDrawer(context) : null,
      //appBar: isWideScreen ? null : buildAppBar(context, title, actions: [filterPanel]),
      floatingActionButton: buildFloatingActionButton(context),
      endDrawer:  buildEndDrawer(context),
      body: Column(
        children: [
          if (!isWideScreen(context)) 
            buildAppBar(context, pageTitle(context), 
              actions: buildActionsForWideScreen(context), 
              goBackButton: goBackButtonInAppBar(context)
          ),
          if (isWideScreen(context) && includePageTitleForWideScreen(context))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              child: Center(
                      child: Text(
                        pageTitle(context),
                        style: theme.textTheme.pageTitle,
                      ),
              ),
              
            ),
          // 2) The list itself must fill the remaining space:
          Expanded(
            child: buildContent(context),
          ),
        ],
      ),
    );
  }
}

abstract class PageBaseState<T extends StatefulWidget> extends State<T> {

  bool get isWideScreen => ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP);
  bool get includeBottomNavBar => isMobile; //=> ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);

  bool get isMobile => !isWideScreen; //ResponsiveBreakpoints.of(context).isMobile;
  bool get isTablet => ResponsiveBreakpoints.of(context).isTablet;
  bool get isDesktop => ResponsiveBreakpoints.of(context).isDesktop;
  bool get largerThanMobile => ResponsiveBreakpoints.of(context).largerThan(MOBILE);
  bool get largerThanTablet => ResponsiveBreakpoints.of(context).largerThan(TABLET);
  bool get largerThanDesktop => ResponsiveBreakpoints.of(context).largerThan(DESKTOP);

  Size get screenSize => MediaQuery.of(context).size;

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  ThemeData get theme => Theme.of(context);

  Locale get locale => context.read<AppConfig>().locale;

  bool get isAuthenticated => context.read<AuthProvider>().isAuthenticated;
  bool get isParent => context.read<AuthProvider>().isParent;
  bool get allowSelfHomeworkManagement => context.read<AuthProvider>().allowSelfHomeworkManagement;

  bool get goBackButtonInAppBar => false;

  bool get includePageTitleForWideScreen => true;

  String get pageTitle => '';

  bool _serverError = false;
  bool get serverError => _serverError;
  set serverError(bool value) {
    setState(() {
      _serverError = value;
    });
  }

  Future<void> onLanguageToggle() async {
    final config = context.read<AppConfig>();
    final newLocale = config.locale.languageCode == 'en' ? const Locale('en') : const Locale('zh');
    await config.setLocale(newLocale);
  }

  //Locale get locale => Localizations.localeOf(context);

  void go(String path) {
    if (path.isEmpty) return;
    GoRouter.of(context).go(path);
  }

  void push(String path) {
    if (path.isEmpty) return;
    GoRouter.of(context).push(path);
  }

  void pop() {
    GoRouter.of(context).pop();
  }

  Widget? buildFloatingActionButton(BuildContext context) {
    return null; // Override in subclasses if needed
  }

  Drawer? buildEndDrawer(BuildContext context) {
    return null; // Override in subclasses if needed
  }

  List<Widget> buildActionsForWideScreen(BuildContext context) {
    return []; // Override in subclasses if needed
  }



  Widget buildContent(BuildContext context) {
    return Container(); // Override in subclasses to provide content
  }

  Widget? buildBottomNavigationBar(BuildContext context) {
    return null; // Override in subclasses if needed
  }

  Widget buildErrorContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          localizations.serverConnectionError,
          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          drawer: !isWideScreen ? buildDrawer(context) : null,
          //appBar: isWideScreen ? null : buildAppBar(context, title, actions: [filterPanel]),
          floatingActionButton: buildFloatingActionButton(context),
          endDrawer:  buildEndDrawer(context),
          body: 
           Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (!isWideScreen) buildAppBar(context, pageTitle, actions: buildActionsForWideScreen(context), goBackButton: goBackButtonInAppBar),
                  if (!isWideScreen) SizedBox(height: 20), // Add some space below the app bar
                  if (isWideScreen && includePageTitleForWideScreen)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                      child: Center(
                              child: Text(
                                pageTitle,
                                style: theme.textTheme.pageTitle,
                              ),
                      ),
                      
                    ),
                  buildContent(context),  
                ],
            ),
          )),
          bottomNavigationBar: buildBottomNavigationBar(context),
        ),
        // Server Error Overlay
        Consumer<ServerErrorNotifier>(
          builder: (context, notifier, child) {
            if (notifier.error != null) {
              return _buildErrorOverlay(context, notifier.error!);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildErrorOverlay(BuildContext context, String error) {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(100),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 45,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  localizations.serverConnectionError,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white54
                  ),
                  textAlign: TextAlign.center,
                ),
                /*const SizedBox(height: 8),
                Text(
                  error,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),*/
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<ServerErrorNotifier>().clear();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(localizations.dismiss),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}