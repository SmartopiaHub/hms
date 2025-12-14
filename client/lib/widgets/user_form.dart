// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../notification.dart';
import '../pages/base.dart';
import '../themes/theme.dart';
import 'buttons.dart';
import 'card.dart';
import '../local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../model/database.dart';
import '../l10n/app_localizations.dart';

/// A reusable form for creating or signing up a [User].
/// - [onSubmit] is called with the filled [User] when the form is valid.
/// - [includeRoleOption]: if true, shows a “Is Parent” switch.
class UserForm extends StatefulWidget {
  final ValueChanged<User> onSubmit;
  final bool includeRoleOption;
  final String submitButtonLabel;
  final String goBackButtonLabel;
  final bool allowChangeAccountType;
  final User? initialUser;

  const UserForm({
    super.key,
    required this.onSubmit,
    this.includeRoleOption = true,
    this.submitButtonLabel = 'Submit',
    this.goBackButtonLabel = 'Go Back',
    this.initialUser,
    this.allowChangeAccountType = true,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends PageBaseState<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController(text: '');
  final _nicknameCtrl = TextEditingController(text: '');
  final _passwordCtrl = TextEditingController(text: '');
  final _confirmCtrl = TextEditingController(text: '');
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  bool _isParent = false;
  bool _allowSelfHomeworkManagement = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  double _strength = 0;
  String _strengthLabel = '';

  String get _usernameLabel => AppLocalizations.of(context)!.username;
  String get _passwordLabel => AppLocalizations.of(context)!.password;
  String get _nicknameLabel => AppLocalizations.of(context)!.nickname;
  String get _confirmLabel => AppLocalizations.of(context)!.confirmNewPassword;
  String get _usernameRequired =>
      AppLocalizations.of(context)!.signInRequireUsername;
  String get _passwordTooShort =>
      AppLocalizations.of(context)!.passwordMinLength;
  String get _confirmRequired =>
      AppLocalizations.of(context)!.confirmNewPassword;
  String get _passwordMismatch =>
      AppLocalizations.of(context)!.passwordMismatch;
  String get _nicknameRequired =>
      AppLocalizations.of(context)!.nickname +
      ' ' +
      AppLocalizations.of(context)!.required;
  String get _isParentLabel => AppLocalizations.of(context)!.accountTypeParent;
  String get _changingAccountTypeNotAllowed =>
      AppLocalizations.of(context)!.changingAccountTypeNotAllowed;

  void _checkPasswordStrength(String pwd) {
    final strength = _calculatePasswordStrength(pwd);
    setState(() {
      _strength = strength;
      if (strength < 0.3) {
        _strengthLabel = AppLocalizations.of(context)!.passwordStrengthWeak;
      } else if (strength < 0.7) {
        _strengthLabel = AppLocalizations.of(context)!.passwordStrengthMedium;
      } else {
        _strengthLabel = AppLocalizations.of(context)!.passwordStrengthStrong;
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
  void initState() {
    super.initState();
    if (widget.initialUser != null) {
      _usernameCtrl.text = widget.initialUser!.username;
      if (widget.initialUser?.nickname != null)
        _nicknameCtrl.text = widget.initialUser!.nickname!;
      _isParent = widget.initialUser!.isParent;
      _allowSelfHomeworkManagement =
          widget.initialUser!.allowSelfHomeworkManagement;
      _passwordCtrl.text = widget.initialUser!.password;
    } else {
      if (!kIsWeb) {
        _loadHostPort();
      }
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _nicknameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() != true) return;
    if (!kIsWeb) {
      final host = _hostController.text.trim();
      final port = _portController.text.trim();
      if (host.isNotEmpty && port.isNotEmpty) {
        await save(key: 'server_host', value: host);
        await save(key: 'server_port', value: port);
      }
    }
    final user = User(
      id: 0,
      username: _usernameCtrl.text.trim(),
      nickname: _nicknameCtrl.text.trim(),
      password: _passwordCtrl.text,
      isParent: widget.includeRoleOption ? _isParent : true,
      allowSelfHomeworkManagement: _allowSelfHomeworkManagement,
      totalPoints: 0,
      redeemedPoints: 0,
    );
    widget.onSubmit(user);
  }

  Future<void> _loadHostPort() async {
    final host = await read('server_host');
    final port = await read('server_port');
    if (host != null) _hostController.text = host;
    if (port != null) _portController.text = port;
  }

  @override
  Widget build(BuildContext context) {
    return buildCard(
      context,
      blur: 10,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      color: Colors.white.withAlpha(25),
      child: buildContent(context),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            const SizedBox(height: 1),

            TextFormField(
              enabled: widget.initialUser == null,
              style: theme.textTheme.formFieldText,
              controller: _usernameCtrl,
              decoration: MyAppTheme.glassInputDecoration(
                labelText: _usernameLabel,
              ),
              validator:
                  (v) => v == null || v.isEmpty ? _usernameRequired : null,
            ),
            TextFormField(
              controller: _nicknameCtrl,
              style: theme.textTheme.formFieldText,
              decoration: MyAppTheme.glassInputDecoration(
                labelText: _nicknameLabel,
              ),
              validator:
                  (v) => v == null || v.isEmpty ? _nicknameRequired : null,
            ),
            if (widget.initialUser == null)
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                onChanged: _checkPasswordStrength,
                style: theme.textTheme.taskCardBody,
                decoration: MyAppTheme.glassInputDecoration(
                  labelText: _passwordLabel,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed:
                        () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                  ),
                ),
                validator:
                    (v) => v == null || v.length < 8 ? _passwordTooShort : null,
              ),
            if (_passwordCtrl.text.isNotEmpty && widget.initialUser == null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: _strength,
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _strengthLabel,
                    style: TextStyle(
                      color:
                          _strength < 0.3
                              ? Colors.red
                              : _strength < 0.7
                              ? Colors.orange
                              : Colors.green,
                    ),
                  ),
                ],
              ),
            if (widget.initialUser == null)
              TextFormField(
                controller: _confirmCtrl,
                obscureText: _obscureConfirm,
                decoration: MyAppTheme.glassInputDecoration(
                  labelText: _confirmLabel,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed:
                        () =>
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
            if (widget.includeRoleOption) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_isParentLabel, style: theme.textTheme.formFieldText),
                    Checkbox.adaptive(
                      activeColor: theme.colorScheme.primary,
                      value: _isParent,
                      onChanged:
                          !widget.allowChangeAccountType
                              ? null
                              : (v) {
                                if (widget.allowChangeAccountType) {
                                  setState(() => _isParent = v == true);
                                } else {
                                  showInfoNotification(
                                    _changingAccountTypeNotAllowed,
                                    context: context,
                                  );
                                }
                              },
                    ),
                  ],
                ),
              ),
              if (!_isParent) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.allowSelfHomeworkManagement,
                        style: theme.textTheme.formFieldText,
                      ),
                      Checkbox.adaptive(
                        activeColor: theme.colorScheme.primary,
                        value: _allowSelfHomeworkManagement,
                        onChanged: (v) {
                          setState(
                            () => _allowSelfHomeworkManagement = v == true,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                buildGoBackButton(context),
                const Spacer(),
                buildElevatedButton(
                  context: context,
                  label: widget.submitButtonLabel,
                  icon: Icons.save,
                  onPressed: _handleSubmit,
                  child: Text(widget.submitButtonLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
