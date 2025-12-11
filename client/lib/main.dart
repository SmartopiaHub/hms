// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'api.dart';

import 'authenticator.dart';
import 'config.dart';
import 'logger.dart';
import 'router.dart';
import 'server.dart';
import 'sse.dart';
import 'theme.dart';
import 'web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:json_theme/json_theme.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toastification/toastification.dart';
import 'package:url_strategy/url_strategy.dart';
import '../l10n/app_localizations.dart';






void main() async {
  await initLogging();
  await initIfWeb();


  WidgetsFlutterBinding.ensureInitialized();
  //final themeMap = json.decode(await rootBundle.loadString('assets/theme.json'));
  //final themeData = ThemeDecoder.decodeThemeData(themeMap)!;  

  ServerErrorNotifier serverErrorNotifier = ServerErrorNotifier();

  ApiService.initApiService(
    onError: (error) {
      logError('API Error: $error');
      serverErrorNotifier.setError(error);
    },
    onSuccess: () {
      serverErrorNotifier.clear();
    }
  );



  
  if (kIsWeb) {
    // For web, set the URL strategy to use path URLs instead of hash URLs
    setPathUrlStrategy();
  } 

  // Default app configuration and authentication provider
  var cfg = AppConfig(themeMode: ThemeMode.light, locale: const Locale('en', 'US'));
  final auth = AuthProvider();

    // Load app config provider
  await cfg.loadConfig();

  // Load the app configuration  
  try {
    cfg = await AppConfig.load();
  }
  catch (e, s) {
    logError('Error loading app config', e, s);
    // Handle the error, e.g., show an error message or fallback UI
  }

  try {
    // Load the authentication credentials
    await auth.loadCredentials();
    if (auth.isAuthenticated && auth.token != null) {
      // Initialize the notification service if the user is authenticated
      try{
        NotificationService().init(auth.token!);
      } catch (e, st) {
        logError('Error initializing notification service', e, st);
      }
    }
  } catch (e, s) {
    logError('Error loading app config or auth credentials', e, s);
    // Handle the error, e.g., show an error message or fallback UI
  }

  

  runApp(
    ToastificationWrapper(
      child: MyApp(appConfig: cfg, authProvider: auth, serverErrorNotifier: serverErrorNotifier))
    );
}

class MyApp extends StatelessWidget {
  final ThemeData? themeData;
  final AppConfig appConfig;
  final AuthProvider authProvider;
  final ServerErrorNotifier serverErrorNotifier;
  const MyApp({super.key, this.themeData, required this.serverErrorNotifier,
    required this.appConfig, required this.authProvider});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (!context.mounted) {
      return const SizedBox.shrink();
    }
    final router = createRouter(authProvider);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => appConfig),
        ChangeNotifierProvider(create: (context) => authProvider),
        ChangeNotifierProvider(create: (context) => NotificationService()),
        ChangeNotifierProvider(create: (_) => serverErrorNotifier),
      ],
      builder: (ctx, child) {
        if (!ctx.mounted) {
          return const SizedBox.shrink();
        }
        return MaterialApp.router(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en'), // English
            Locale('zh'), // Spanish
          ],
          locale: ctx.watch<AppConfig>().locale,
          theme: AppTheme.light,
          // The Mandy red, dark theme.
          darkTheme: AppTheme.light,
          // Use dark or light theme based on system setting.
          themeMode: ThemeMode.system,

          routerConfig: router,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
            child: child!
          ),
          //builder: (context, child) => LandscapeRequired(child: FullScreenPrompt(child: child!)),
          //routerDelegate: router.routerDelegate,
          //routeInformationParser: router.routeInformationParser,
          //routeInformationProvider: router.routeInformationProvider,
        );
      },
    );
  }
}
