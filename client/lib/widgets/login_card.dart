// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/foundation.dart';

import '../authenticator.dart';
import '../local_storage.dart';
import '../pages/base.dart';
import '../widgets/buttons.dart';
import '../widgets/card.dart';
import '../server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});
  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends PageBaseState<LoginCard> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _serverUrlController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  bool _isEditingServerUrl = false;
  String? _currentServerUrl;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      _currentServerUrl = await getServerUrl();
      if (mounted) {
        setState(() {
          _currentServerUrl = _currentServerUrl;
          if (_currentServerUrl != null) {
            _serverUrlController.text = _currentServerUrl!;
          } else {
            _isEditingServerUrl = true;
          }
        });
      }
    });
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (_isEditingServerUrl && _serverUrlController.text.isNotEmpty) {
      try {
        final uri = Uri.parse(_serverUrlController.text);
        if (uri.hasScheme && uri.hasAuthority) {
          await save(key: 'server_scheme', value: uri.scheme);
          await save(key: 'server_host', value: uri.host);
          await save(key: 'server_port', value: uri.port.toString());
          _currentServerUrl = _serverUrlController.text;
          setState(() {
            _isEditingServerUrl = false;
          });
        } else {
          setState(() {
            _errorMessage = "Invalid Server URL";
            _isLoading = false;
          });
          return;
        }
      } catch (e) {
        setState(() {
          _errorMessage = "Invalid Server URL";
          _isLoading = false;
        });
        return;
      }
    }

    var success = await context.read<AuthProvider>().signIn(
      _emailController.text,
      _passwordController.text,
    );

    try {
      if (!success) {
        setState(() {
          _errorMessage = localizations.signInError;
        });
        return;
      }
      if (!mounted) return;
      final parameters = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
      if (parameters == null || parameters['from'] == null) {
        // No parameters, navigate to home page
        go('/');
        return;
      }
      go(parameters['from']!); // Navigate to the specified route
    } 
    catch (e) {
      setState(() {
        _errorMessage = localizations.signInError;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  List<Widget> _buildServerUrlField() {
    if (kIsWeb) return [];
    final widgets = <Widget>[];
    if (_currentServerUrl == null || _currentServerUrl!.isEmpty || _isEditingServerUrl) {
      widgets.add(
              TextFormField(
                controller: _serverUrlController,
                decoration: InputDecoration(
                  labelText: localizations.serverUrl,
                  suffixIcon: _currentServerUrl != null && _currentServerUrl!.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _isEditingServerUrl = false;
                              _serverUrlController.text = _currentServerUrl!;
                            });
                          })
                      : null,
                ),
                validator: (v) => v == null || v.isEmpty ? 'Server URL is required' : null,
              )
      );
    }
    else {
      widgets.add(
              Row(
                children: [
                  Expanded(child: Text(_currentServerUrl!, style: const TextStyle(color: Colors.black38))),
                  IconButton(
                      icon: const Icon(Icons.edit, size: 16, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _isEditingServerUrl = true;
                          _serverUrlController.text = _currentServerUrl!;
                        });
                      })
                ],
              ),
      );
    }
    widgets.add(
            const SizedBox(height: 16),
    );
    return widgets;
  }
    

  @override
  Widget build(BuildContext context) {
    return buildCard(
      context,
      blur: 20,
      color: Colors.white.withAlpha(50),
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._buildServerUrlField(),
            TextFormField(
              decoration: InputDecoration(labelText:  localizations.username),
              controller: _emailController,
              validator: (v) => v == null || v.isEmpty
                          ? localizations.signInRequireUsername
                          : null,
              onChanged: (value) {
                setState(() {
                  _errorMessage = null; // reset error message on input change
                  _isLoading = false; // reset loading state
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(labelText: localizations.password),
              controller: _passwordController,
              validator: (v) => v == null || v.isEmpty
                          ? localizations.signInRequirePassword
                          : null,
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: buildElevatedButton(
                      icon: Icons.login,
                      context: context,
                      onPressed: () async {
                        setState(() {
                          _errorMessage = null; // reset error message
                        });
                        await _signIn();
                      },
                      label: localizations.signIn,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}