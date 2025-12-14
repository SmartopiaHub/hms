// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'pages/change_password_page.dart';
import 'pages/client_download_page.dart';
import 'pages/helper_page.dart';
import 'pages/profile_page.dart';
import 'pages/server_connection_page.dart';
import 'pages/task_list_page.dart';
import 'pages/user_detail_page.dart';
import 'server.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'authenticator.dart';
import 'model/database.dart';
import 'pages/app_shell.dart' as nas;
import 'pages/create_edit_task_template.dart';
import 'pages/disclaimer_page.dart';
import 'pages/create_user.dart';
import 'pages/homepage.dart';
import 'pages/task_template_list_page.dart';
import 'pages/user_list_page.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';
import 'pages/task_detail_page.dart';
import 'pages/task_grading.dart';
import 'pages/task_submission.dart';
import 'widgets/responsive_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/settings.dart';
import 'pages/shop/shop_list_page.dart';
import 'pages/shop/redemption_history_page.dart';
import 'pages/task_review_page.dart';
import 'pages/admin/ai_settings_page.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (previousRoute == null) return;
    //debugPrint('Pushed route: ${route.settings.name}');
    _saveCurrentPage(route.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // debugPrint('Popped route: ${route.settings.name}');
    _saveCurrentPage(previousRoute?.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    //debugPrint('Replace route: ${newRoute?.settings.name}');
    _saveCurrentPage(newRoute?.settings.name);
  }

  void _saveCurrentPage(String? routeName) async {
    if (routeName == null) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('current_page_time', DateTime.now().toIso8601String());
    prefs.setString('current_page', routeName);
    debugPrint('Saved current page: $routeName');
  }
}

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    observers: [CustomNavigatorObserver()],
    refreshListenable: authProvider,
    // set up the redirect logic
    redirect: (ctx, state) async {
      if (!ctx.mounted) return null;
      if (state.uri.path == '/index.html') {
        // this is the default path for web apps, redirect to home
        return '/';
      }

      if (state.uri.path == '/downloads' ||
          state.uri.path == '/helper' ||
          state.uri.path == '/disclaimer' ||
          state.uri.path == '/signin') {
        return null; // no redirect
      }

      if (!kIsWeb) {
        final serverUrl = await getServerUrl();
        if (serverUrl == null) {
          if (state.uri.path != '/server-connection') {
            return '/server-connection';
          }
          return null;
        }
      }

      final goingToSignUp = state.uri.path.startsWith('/signup');
      if (goingToSignUp) return null; // no redirect

      if (state.uri.path == '/') {
        if (kIsWeb) {
          // on web, redirect to homepage
          return null;
        }
        // on mobile/desktop, redirect to tasks or signin
        if (authProvider.isAuthenticated) {
          return '/tasks';
        }
        return '/signin';
      }

      final goingToSignIn = state.uri.path.startsWith('/signin');
      final isLoggedIn = authProvider.isAuthenticated;
      if (!isLoggedIn && !goingToSignIn) {
        // user is not authed → remember where they wanted to go
        return '/signin?from=${Uri.encodeComponent(state.uri.path)}';
      }
      if (isLoggedIn && goingToSignIn) {
        // once they sign in → return to the original page
        final from =
            state.uri.queryParameters['from']; //state.pathParameters['from'];
        return from == null ? '/' : Uri.decodeComponent(from);
      }
      return null; // no redirect
    },
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (ctx, state, child) {
          if (!ctx.mounted) return const SizedBox();
          return ResponsiveLayout(child: nas.AppShell(child: child));
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => HomePage()),
          GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
          GoRoute(
            path: '/server-connection',
            builder: (context, state) => ServerConnectionPage(),
          ),
          GoRoute(path: '/signin', builder: (context, state) => SignInPage()),
          GoRoute(path: '/signup', builder: (context, state) => SignUpPage()),
          GoRoute(path: '/users', builder: (context, state) => ListUserPage()),
          GoRoute(
            path: '/admin/ai-settings',
            builder: (context, state) => const AiSettingsPage(),
          ),
          GoRoute(
            path: '/downloads',
            builder: (context, state) => const ClientDownloadPage(),
          ),
          GoRoute(
            path: '/helper',
            builder: (context, state) => const HelperPage(),
          ),
          GoRoute(
            path: '/users/:id/detail',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              User? initial;
              if (state.extra != null) {
                if (state.extra is User) {
                  initial = state.extra as User;
                } else if (state.extra is Map<String, dynamic>) {
                  initial = User.fromJson(state.extra as Map<String, dynamic>);
                }
              }
              return UserDetailPage(
                userId: id == null ? null : int.tryParse(id),
                user: initial,
              );
            },
          ),
          GoRoute(
            path: '/users/:id/password',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              if (id == null) {
                throw Exception('User ID is required for ChangePasswordPage');
              }
              return ChangePasswordPage(userId: int.parse(id));
            },
          ),
          GoRoute(
            path: '/users/create',
            builder: (context, state) => CreateUserPage(),
          ),
          GoRoute(path: '/tasks', builder: (context, state) => TaskListPage()),
          GoRoute(
            path: '/tasks/:id/submit',
            name: 'taskSubmit',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              Task? initial;
              if (state.extra != null) {
                if (state.extra is Task) {
                  initial = state.extra as Task;
                } else if (state.extra is Map<String, dynamic>) {
                  initial = Task.fromJson(state.extra as Map<String, dynamic>);
                }
              }
              //final task = state.extra as Task?;
              return TaskSubmissionPage(
                taskId: id == null ? null : int.tryParse(id),
                task: initial,
              );
            },
          ),
          GoRoute(
            path: '/tasks/:id/detail',
            name: 'taskDetail',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              Task? initial;
              if (state.extra != null) {
                if (state.extra is Task) {
                  initial = state.extra as Task;
                } else if (state.extra is Map<String, dynamic>) {
                  initial = Task.fromJson(state.extra as Map<String, dynamic>);
                }
              }
              return TaskDetailPage(
                taskId: id == null ? null : int.tryParse(id),
                task: initial,
              );
            },
          ),
          GoRoute(
            path: '/tasks/:id/grade',
            name: 'taskGrade',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              Task? initial;
              if (state.extra != null) {
                if (state.extra is Task) {
                  initial = state.extra as Task;
                } else if (state.extra is Map<String, dynamic>) {
                  initial = Task.fromJson(state.extra as Map<String, dynamic>);
                }
              }
              return TaskGradingPage(
                taskId: id == null ? null : int.tryParse(id),
                task: initial,
              );
            },
          ),
          GoRoute(
            path: '/templates',
            builder: (context, state) => TastTemplateListPage(),
          ),
          GoRoute(
            path: '/shop',
            builder: (context, state) => const ShopListPage(),
          ),
          GoRoute(
            path: '/shop/history',
            builder: (context, state) => const RedemptionHistoryPage(),
          ),

          GoRoute(
            path: '/templates/create',
            name: 'taskCreate',
            builder: (context, state) {
              if (state.extra != null && state.extra is Map<String, dynamic>) {
                final extra = state.extra as Map<String, dynamic>;
                return CreateOrEditTaskPage(
                  returnOnSubmit: extra['returnOnSubmit'] ?? false,
                  taskTemplate: extra['taskTemplate'],
                );
              }
              return CreateOrEditTaskPage();
            },
          ),
          GoRoute(
            path: '/templates/review',
            name: 'taskReview',
            builder: (context, state) {
              final tasks = state.extra as List<TaskTemplate>;
              return TaskReviewPage(initialTasks: tasks);
            },
          ),
          GoRoute(
            path: '/templates/:id/edit',
            name: 'taskEdit',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              final task = state.extra as TaskTemplate?;
              return CreateOrEditTaskPage(
                taskId: id == null ? null : int.tryParse(id),
                taskTemplate: task,
              );
            },
          ),
          GoRoute(
            path: '/admin/ai-settings',
            builder: (context, state) => const AiSettingsPage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: '/disclaimer',
            builder: (context, state) => const DisclaimerPage(),
          ),
        ],
      ),
    ],
  );
}
