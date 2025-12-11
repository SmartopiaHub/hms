// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../authenticator.dart';
import '../notification.dart';
import '../widgets/user_form.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../api.dart';
import '../model/database.dart';
import 'base.dart';
import 'package:provider/provider.dart';

class UserDetailPage extends StatefulWidget {
  /// route should supply either `userId` or an extra User object
  final int? userId;
  final User? user;
  const UserDetailPage({super.key, this.userId, this.user})
      : assert(userId != null || user != null,
          'Either userId or user must be provided.');

  @override
  PageBaseState<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends PageBaseState<UserDetailPage> {

  bool _loading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _loading = true);
    try {
      _user = widget.user ?? await apiService.fetchUser(widget.userId!.toString());
    } catch (e) {
      showErrorNotification(localizations.failToFetchUser, context: context);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveChanges(User user) async {
    setState(() => _loading = true);
    try {
      final success = await apiService.updateUser(user);
      if (success) {
        showInfoNotification('User updated');
        // pop and return true so list can refresh
        if (mounted) GoRouter.of(context).pop(true);
      } else {
        showErrorNotification('Save failed');
      }
    } catch (e) {
      showErrorNotification('Save failed: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  String get pageTitle => localizations.userDetailTitle;

  @override
  bool get goBackButtonInAppBar => true;

  @override
  Widget buildContent(BuildContext context) {
    final currentUsername = context.read<AuthProvider>().username;
    return _loading || _user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(padding: const EdgeInsets.all(16.0),
                    child: UserForm(
                      onSubmit: _saveChanges, 
                      initialUser: _user,
                      submitButtonLabel: localizations.submit,
                      goBackButtonLabel: localizations.goBackButtonText,
                      allowChangeAccountType: currentUsername != _user!.username,
                    )
                );
  }

}