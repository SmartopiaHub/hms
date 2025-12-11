// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'base.dart';
import '../themes/theme.dart';
import '../widgets/buttons.dart';
import '../widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../authenticator.dart';

class ProfilePage extends StatelessPageBase {
  const ProfilePage({super.key});

  Widget _buildProfileContent(BuildContext context, String username, bool isParent, AppLocalizations loc) {
    final theme = Theme.of(context);
    return 
     SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildCard(
            context,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(loc.username),
              trailing: Text(username, style: theme.textTheme.taskCardTitle),
            ),
          ),
          buildCard(
            context,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(isParent ? Icons.admin_panel_settings : Icons.child_care),
              title: Text(loc.accountType),
              trailing: Text(isParent ? loc.accountTypeParent : loc.accountTypeChild, style: theme.textTheme.taskCardTitle),
            ),
          ),

          SizedBox(height: 36),
          //Expanded(flex: 1, child: Container()), // Spacer to push buttons to the bottom
          buildElevatedButton(context: context, 
            icon: Icons.logout,
            label: loc.signOut,
            onPressed: () async {
              final auth = context.read<AuthProvider>();
              await auth.signOut();
              if (context.mounted) {
                //showInfoNotification(loc.signOutSuccess, context: context);
                GoRouter.of(context).go('/');
              }
            },
          ),
        ],
      )
     );
  }

  @override
  String pageTitle(context) => AppLocalizations.of(context)!.profile;

  @override
  Widget buildContent(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final username = auth.username;
    final isParent = auth.isParent;
    final loc = AppLocalizations.of(context)!;

    return 
      ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600),
        child: auth.isAuthenticated && username!=null
          ? _buildProfileContent(context, username, isParent, loc)
          : Center(
              child: Text(loc.notAuthenticated),
            ),
    );
  }

}