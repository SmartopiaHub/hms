// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../logger.dart';
import '../model/mqtt.dart';
import '../notification.dart';
import '../widgets/buttons.dart';
import '../widgets/card.dart';
import '../local_storage.dart';
import 'package:flutter/material.dart';
import '../api.dart';
import '../sse.dart';

class ServerSettingsPage extends StatefulWidget {
  const ServerSettingsPage({super.key});

  @override
  State<ServerSettingsPage> createState() => _ServerSettingsPageState();
}

class _ServerSettingsPageState extends State<ServerSettingsPage> {
  bool _mqttConnected = false;
  bool _loadingConfig = true;
  bool _savingConfig = false;
  MqttConfig? _mqttConfig;

  // Server config controllers
  final _hostController = TextEditingController();
  final _serverPortController = TextEditingController();

  // MQTT config controllers
  final _brokerController = TextEditingController();
  final _portController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _topicController = TextEditingController();
  final _clientIdController = TextEditingController();
  bool _obscurePassword = true;

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadServerSettings();
      await _loadConfig();
      await _loadStatus();
    });
  }

  Future<void> _loadServerSettings() async {
    final host = await read('server_host');
    final port = await read('server_port');
    if (mounted) {
      setState(() {
        _hostController.text = host ?? '';
        _serverPortController.text = port ?? '';
      });
    }
  }

  Future<void> _saveServerSettings() async {
    await save(key: 'server_host', value: _hostController.text);
    await save(key: 'server_port', value: _serverPortController.text);
    if (mounted) {
      showInfoNotification(localizations.save, context: context);
    }
  }

  Future<void> _loadConfig() async {
    setState(() => _loadingConfig = true);
    try {
      _mqttConfig = await apiService.getMqttConfig();
      if (_mqttConfig != null) {
        _brokerController.text = _mqttConfig!.host;
        _portController.text = _mqttConfig!.port.toString();
        _userController.text = _mqttConfig!.username ?? '';
        _passController.text = _mqttConfig!.password ?? '';
        _topicController.text = _mqttConfig!.topicPrefix;
        _clientIdController.text = _mqttConfig!.clientId;
      } else {
        // Reset fields if no config found
        _brokerController.clear();
        _portController.clear();
        _userController.clear();
        _passController.clear();
        _topicController.clear();
        _clientIdController.clear();
      }
    } catch (e, s) {
      logError('Failed to load MQTT config', e, s);
      showErrorNotification('Failed to load MQTT config: $e');
    } finally {
      setState(() => _loadingConfig = false);
    }
  }

  Future<void> _loadStatus() async {
    if (_mqttConfig == null) {
      return;
    }
    try {
      _mqttConnected = await apiService.isMqttConnected();
      setState(() {});
    } catch (e) {
      showErrorNotification('Failed to load server status: $e');
    }
  }

  Future<void> _saveMqttConfig() async {
    setState(() => _savingConfig = true);
    try {
      _mqttConfig = MqttConfig(
        host: _brokerController.text,
        port: int.tryParse(_portController.text) ?? 1883,
        username: _userController.text.isNotEmpty ? _userController.text : null,
        password: _passController.text.isNotEmpty ? _passController.text : null,
        topicPrefix: _topicController.text,
        clientId:
            _clientIdController.text.isNotEmpty
                ? _clientIdController.text
                : 'hms_server',
      );
      await apiService.configureMqtt(_mqttConfig!);
      showInfoNotification('MQTT configuration saved.');
      await _loadStatus();
    } catch (e) {
      showErrorNotification('Failed to save MQTT config: $e');
    } finally {
      setState(() => _savingConfig = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child:
            _loadingConfig
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                  onRefresh: _loadStatus,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Server Configuration Section
                      const SizedBox(height: 18),
                      buildCard(
                        context,
                        blur: 20,
                        padding: const EdgeInsets.all(16),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white.withAlpha(50),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  localizations.serverSettings,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _hostController,
                                decoration: InputDecoration(
                                  labelText: localizations.host,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _serverPortController,
                                decoration: InputDecoration(
                                  labelText: localizations.port,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              Consumer<NotificationService>(
                                builder: (context, notificationService, child) {
                                  return Column(
                                        children: [
                                          ListTile(
                                            leading: Icon(
                                              Icons.wifi,
                                              color:
                                                  notificationService.isConnected
                                                      ? Colors.green
                                                      : Colors.red,
                                            ),
                                            title: Text(localizations.sseConnection),
                                            subtitle: Text(
                                              notificationService.isConnected
                                                  ? localizations.connected
                                                  : localizations.disconnected,
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(Icons.refresh),
                                              onPressed: () async {
                                                await notificationService.refresh();
                                              },
                                              tooltip: localizations.refresh,
                                            ),
                                          ),
                                        ],
        
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              buildElevatedButton(
                                context: context,
                                onPressed: _saveServerSettings,
                                icon: Icons.save,
                                label: localizations.save,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      buildCard(
                        context,
                        blur: 20,
                        padding: const EdgeInsets.all(16),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white.withAlpha(50),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  localizations.mqttConnection,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ListTile(
                                leading: Icon(
                                  Icons.cloud,
                                  color:
                                      _mqttConnected
                                          ? Colors.green
                                          : Colors.red,
                                ),
                                title: Text(localizations.mqttConnection),
                                subtitle: Text(
                                  _mqttConnected
                                      ? localizations
                                          .mqttConnectionStatusConnected
                                      : localizations
                                          .mqttConnectionStatusDisconnected,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: _loadStatus,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _brokerController,
                                decoration: InputDecoration(
                                  labelText: localizations.mqttBrokerHost,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _portController,
                                decoration: InputDecoration(
                                  labelText: localizations.mqttBrokerPort,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _userController,
                                decoration: InputDecoration(
                                  labelText: localizations.mqttUsername,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _passController,
                                decoration: InputDecoration(
                                  labelText: localizations.mqttPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed:
                                        () => setState(
                                          () =>
                                              _obscurePassword =
                                                  !_obscurePassword,
                                        ),
                                  ),
                                ),
                                obscureText: _obscurePassword,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _topicController,
                                decoration: InputDecoration(
                                  labelText: localizations.mqttTopic,
                                ),
                              ),
                              const SizedBox(height: 24),
                              buildElevatedButton(
                                context: context,
                                onPressed:
                                    _savingConfig ? null : _saveMqttConfig,
                                icon: Icons.save,
                                label: localizations.save,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
      ),
    );
  }

  @override
  void dispose() {
    _hostController.dispose();
    _serverPortController.dispose();
    _brokerController.dispose();
    _portController.dispose();
    _userController.dispose();
    _passController.dispose();
    _topicController.dispose();
    super.dispose();
  }
}
