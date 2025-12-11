// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../api.dart';
import '../notification.dart';
import 'base.dart';
import '../widgets/user_form.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../model/database.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends PageBaseState<CreateUserPage> {
  
  Future<void> _onSubmit(User user) async {
    final loc = AppLocalizations.of(context)!;
    final userId = await apiService.createUser(user);
    if (mounted) {
      if (userId != null) {
        showInfoNotification(loc.createAccountSuccess, context: context);
        Future.delayed(const Duration(seconds: 2), () {
          go('/signin');
        });
      } else {
        showErrorNotification('Failed to create user', context: context);
      }
    }
  }

  @override
  String get pageTitle => isAuthenticated ? localizations.createAccountTitle : localizations.signupFirstAccount;

  @override
  bool get goBackButtonInAppBar => isAuthenticated;

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserForm(
                onSubmit: _onSubmit,
                includeRoleOption: isAuthenticated,
                goBackButtonLabel: localizations.goBackButtonText,
                submitButtonLabel: localizations.createAccount,
              ),
            ],
          ),
        ),
      );
  }
}