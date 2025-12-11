// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../notification.dart';
import '../widgets/password_form.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../api.dart';
import '../pages/base.dart';
import '../l10n/app_localizations.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key, required this.userId});

  final int userId;

  @override
  PageBaseState<ChangePasswordPage> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState extends PageBaseState<ChangePasswordPage> {

  @override
  bool get goBackButtonInAppBar => true;

  @override
  String get pageTitle => localizations.changePassword;

  @override
  Widget buildContent(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return PasswordForm(
                
                onSubmit: (value) async {
                  try {
                    await apiService.changePassword(widget.userId, value);
                    if (!context.mounted) return;
                      // Show success notification
                    showInfoNotification(loc.passwordChanged, context: context);
                    GoRouter.of(context).pop();
                  } catch (e) {
                    showErrorNotification(loc.passwordChangeError, context: context);
                  }
                },
              );
  
  }
}