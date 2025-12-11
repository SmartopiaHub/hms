// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.


import '../pages/base.dart';
import '../themes/theme.dart';
import '../widgets/buttons.dart';
import '../widgets/card.dart';
import 'package:flutter/material.dart';

/// A reusable form for updating a user's password.
class PasswordForm extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  final bool showCancelButton;

  const PasswordForm({
    super.key,
    required this.onSubmit,
    this.showCancelButton = true,
  });

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends PageBaseState<PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  double _strength = 0;
  String _strengthLabel = '';

  String get _submitButtonLabel {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'zh' ? '修改' : 'Update';
  }


  String get _passwordLabel {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'zh' ? '密码' : 'Password';
  }


  String get _confirmLabel {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'zh' ? '确认密码' : 'Confirm Password';
  }


  String get _passwordTooShort {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'zh' ? '密码长度至少为8个字符' : 'Password must be at least 8 characters';
  }
  String get _confirmRequired {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'zh' ? '请确认密码' : 'Please confirm your password';
  }
  String get _passwordMismatch {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'zh' ? '两次密码不一致' : 'Passwords do not match';
  }


  void _checkPasswordStrength(String pwd) {
    final strength = _calculatePasswordStrength(pwd);
    setState(() {
      _strength = strength;
      final locale = Localizations.localeOf(context);
      if (strength < 0.3) {
        _strengthLabel = locale.languageCode == 'zh' ? '弱' : 'Weak';
      } else if (strength < 0.7) {
        _strengthLabel = locale.languageCode == 'zh' ? '中等' : 'Medium';
      } else {
        _strengthLabel = locale.languageCode == 'zh' ? '强' : 'Strong';
      }
    });
  }

  double _calculatePasswordStrength(String pwd) {
    var s = 0.0;
    if (pwd.length >= 6) s += 0.3;
    if (pwd.contains(RegExp(r'[A-Z]'))) s += 0.2;
    if (pwd.contains(RegExp(r'[0-9]'))) s += 0.2;
    if (pwd.contains(RegExp(r'[^A-Za-z0-9]'))) s += 0.3;
    return s.clamp(0.0, 1.0);
  }



  @override
  void dispose() {

    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() != true) return;
    widget.onSubmit(_passwordCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return buildCard(
      context,
      blur: 10,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      color: Colors.white.withAlpha(25),
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 500),
        child: buildContent(context),
      ),
    );
  }

  Color? get _passwordStrengthBarColor {
    if (_strength < 0.3) {
      return const Color.fromARGB(255, 191, 54, 44);
    } else if (_strength < 0.7) {
      return const Color.fromARGB(255, 176, 111, 14);
    } else {
      return const Color.fromARGB(255, 2, 60, 4);
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing:  16,
        children: [

          TextFormField(
            controller: _passwordCtrl,
            obscureText: _obscurePassword,
            onChanged: _checkPasswordStrength,
            decoration: MyAppTheme.glassInputDecoration(
              labelText: _passwordLabel,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (v) => v == null || v.length < 8
                ? _passwordTooShort
                : null,
          ),
          
          if(_passwordCtrl.text.isNotEmpty ) 
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // make the bar expand to fill available width
                Expanded(
                  child: LinearProgressIndicator(
                    value: _strength,
                    minHeight: 6,
                    color: _passwordStrengthBarColor,
                  ),
                ),
                const SizedBox(width: 8),
                // immediately after, show the label
                Text(
                  _strengthLabel,
                  style: TextStyle(
                    // optional: color‐code by strength
                    color: _passwordStrengthBarColor
                  ),
                ),
              ],
            ),
          
          TextFormField(
            controller: _confirmCtrl,
            obscureText: _obscureConfirm,
            decoration: MyAppTheme.glassInputDecoration(
              labelText: _confirmLabel,
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirm
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            validator: (v) {
                if (v == null || v.isEmpty) {
                  return _confirmRequired;
                }
                if (v != _passwordCtrl.text) {
                  return _passwordMismatch;
                }
                return null;
              },
            ),
        
          Row(children: [
            if (widget.showCancelButton) buildGoBackButton( context),
            const Spacer(),
            buildElevatedButton(
              context: context,
              label: _submitButtonLabel,
              icon: Icons.save,
              onPressed: _handleSubmit,
            ),
          ],)
          
        ],
      ),
    );
  }
}