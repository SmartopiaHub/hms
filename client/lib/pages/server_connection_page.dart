// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:convert';
import 'base.dart';
import '../widgets/buttons.dart';

import '../local_storage.dart';
import '../widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../l10n/app_localizations.dart';

class ServerConnectionPage extends StatefulWidget {
  const ServerConnectionPage({super.key});

  @override
  State<ServerConnectionPage> createState() => _ServerConnectionPageState();
}

class _ServerConnectionPageState extends PageBaseState<ServerConnectionPage> {
  final _formKey = GlobalKey<FormState>();
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _testAndSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final host = _hostController.text.trim();
    final port = _portController.text.trim();
    
    // Load scheme from config or default to http
    String scheme = 'http';
    try {
      final configStr = await rootBundle.loadString('assets/app_config.json');
      final config = jsonDecode(configStr);
      scheme = config['scheme'] ?? 'http';
    } catch (e) {
      // ignore
    }

    final url = '$scheme://$host:$port';

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        // Success
        await save(key: 'server_host', value: host);
        await save(key: 'server_port', value: port);
        
        if (mounted) {
          context.go('/');
        }
      } else {
        setState(() {
          _errorMessage = 'Server responded with status: ${response.statusCode}';
        });
      }
    } catch (e) {
      if (mounted) {
        final loc = AppLocalizations.of(context)!;
        setState(() {
          _errorMessage = '${loc.serverConnectionError}: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildCard(
              context,
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        localizations.connectToServer,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _hostController,
                        decoration: InputDecoration(
                          labelText: localizations.host,
                          hintText: 'e.g. 192.168.1.100',
                          prefixIcon: const Icon(Icons.dns),
                        ),
                        validator: (value) => value?.isEmpty == true ? localizations.required : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _portController,
                        decoration: InputDecoration(
                          labelText: localizations.port,
                          hintText: 'e.g. 8080',
                          prefixIcon: const Icon(Icons.numbers),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value?.isEmpty == true ? localizations.required : null,
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 24),
                      buildElevatedButton(
                        context: context,
                        label: localizations.connect,
                        onPressed: _isLoading ? null : _testAndSave,
                        icon: Icons.link,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(localizations.connect),
                      ),
                      
                    ],
                  ),
                ),
              ),
            ),
   
      ),
    );
  }
}
