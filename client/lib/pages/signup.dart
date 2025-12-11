// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../api.dart';
import '../model/database.dart';
import '../notification.dart';
import 'base.dart';
import '../widgets/user_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../server.dart';
import '../l10n/app_localizations.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends PageBaseState<SignUpPage> {

  bool? _signupAllowed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSignupAllowed();
    });
  }

  Future<void> _checkSignupAllowed() async {
    if (!kIsWeb) {
      final serverUrl = await getServerUrl();
      if (serverUrl == null) {
        if (mounted) {
          setState(() {
            _signupAllowed = false;
          });
        }
        return;
      }
    }
    /*try {
      final allowed = await apiService.isSignupAllowed();
      if (mounted) {
        setState(() {
          _signupAllowed = allowed;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _signupAllowed = false;
        });
      }
    }*/
  }

  Future<void> _onSubmit(User user) async {
    final userId = await apiService.signUp(user);
    if (mounted) {
      if (userId != null) {
        showInfoNotification(
          localizations.signUpSuccess, 
          context: context,
        );
        Future.delayed(const Duration(seconds: 2), () {
          go('/signin');
        });
      } else {
        showErrorNotification(
          'Failed to sign up', 
          context: context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // 1) still checking
    if (_signupAllowed == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(loc.checkingSignupAllowed),  // add this key to your .arb
        ],
      );
    }

    // 2) not allowed
    if (_signupAllowed == false) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.block, size: 64),
          const SizedBox(height: 12),
          Text(
            loc.signupNotAllowedMessage,   // add this key to your .arb
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: isWideScreen ? AppBar(title: Text(loc.signupFirstAccount)) :null,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                loc.signupFirstAccount,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              UserForm(
                onSubmit: _onSubmit,
                includeRoleOption: false,
                submitButtonLabel: loc.createAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}