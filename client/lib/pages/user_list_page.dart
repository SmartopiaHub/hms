// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../api.dart';
import '../authenticator.dart';
import '../config.dart';
import '../l10n/app_localizations.dart';
import '../logger.dart';
import '../model/database.dart';
import '../notification.dart';
import '../themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/point_badge.dart';
import '../widgets/card.dart';


class ListUserPage extends StatefulWidget {
  const ListUserPage({super.key});

  @override
  State<ListUserPage> createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {
  List<User> _users = [];
  bool _isLoading = true;

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await apiService.fetchUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showErrorNotification(
          localizations.errorFetchingUsers,
          context: context,
        );
      }
    }
  }

  void _deleteUser(int userId) async {
    try {
      final success = await apiService.deleteUser(userId);
      if (success) {
        setState(() {
          _users.removeWhere((user) => user.id == userId);
        });
        if (mounted) showInfoNotification(localizations.userDeleted, context: context);
      } else {
        if (mounted) showErrorNotification(localizations.deleteAccountError, context: context);
      }
    } catch (e, stackTrace) {
      logError('Failed to delete user', e, stackTrace);
      if (mounted) showErrorNotification(localizations.deleteAccountError, context: context);
    }
  }

  //@override
  //String get pageTitle => localizations.userList;


  Widget _buildUserCard(User user, String? currentUsername) {
    final theme = Theme.of(context);
    return buildCard(context,
            child: ListTile(
                    title: GestureDetector(
                      onTap: () {
                        // Navigate to user details page
                        GoRouter.of(context).push('/users/${user.id}/detail');
                      },
                      child: Row(
                        children: [
                          Text(user.username, style: theme.textTheme.taskCardTitle),
                          if (!user.isParent && context.read<AppConfig>().pointSystemEnabled) ...[
                            const SizedBox(width: 10),
                            PointBadge(
                              points: user.availablePoints,
                              pointSystemId: user.pointSystemId,
                              iconSize: 16,
                              maxPoints: user.totalPoints,
                              //color: Colors.amber[800],
                            ),
                          ]
                        ],
                      ),
                    ),
                    subtitle: Text('${localizations.nickname}: ${user.nickname}\n${localizations.accountType}: ${user.isParent ? localizations.accountTypeParent : localizations.accountTypeChild}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (currentUsername != user.username) IconButton(
                          icon: Icon(Icons.delete, color: const Color.fromARGB(255, 130, 16, 16)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(localizations.deleteUser),
                                content: Text('${localizations.deleteUserConfirmation(user.username)}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(localizations.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteUser(user.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(localizations.delete),
                                  ),
                                ],
                              ),
                            );
                          }
                        ),
                        IconButton(
                          icon: Icon(Icons.password, color: theme.colorScheme.primary),
                          onPressed: () {
                            GoRouter.of(context).push(
                              '/users/${user.id}/password',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final currentUsername = auth.username;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length+1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == _users.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: IconButton(
                      icon: const Icon(Icons.add_circle),
                      onPressed: () {
                        GoRouter.of(context).push('/users/create');
                      },
                    ),
                  );
                }
                final user = _users[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildUserCard(user,currentUsername,)
                );
              },
            )
      )
      );
  }

}