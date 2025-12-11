// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import 'package:smartopia_hms_shared/shared.dart';
import '../api.dart';
import '../logger.dart';
import '../l10n/app_localizations.dart';
import '../notification.dart';
import 'card.dart';
import 'buttons.dart';

class NotificationSettingsWidget extends StatefulWidget {
  const NotificationSettingsWidget({super.key});

  @override
  State<NotificationSettingsWidget> createState() => _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState extends State<NotificationSettingsWidget> {
  bool _loading = true;
  bool _saving = false;

  // Notification method checkboxes
  final Map<String, Map<int, bool>> _selectedMethods = {
    'onAssigned': {},
    'onStarted': {},
    'onOverdue': {},
    'onGraded': {},
    'onCompleted': {},
  };

  List<Map<String, dynamic>> _getAvailableMethods(AppLocalizations l10n) {
    return [
      {'id': NotificationSetting.PUSH_NOTIFICATION, 'name': l10n.pushNotification},
      {'id': NotificationSetting.EMAIL, 'name': l10n.email},
      {'id': NotificationSetting.SMS, 'name': l10n.sms},
      {'id': NotificationSetting.MQTT, 'name': l10n.mqtt},
    ];
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _loading = true);
    try {
      final settings = await apiService.getNotificationSettings();
      if (settings != null && mounted) {
        setState(() {
          _initializeSelectedMethods(settings);
        });
      }
    } catch (e, st) {
      logError('Failed to load notification settings', e, st);
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _initializeSelectedMethods(NotificationSetting settings) {
    // Initialize from settings
    _updateMethodMap('onAssigned', settings.onAssigned);
    _updateMethodMap('onStarted', settings.onStarted);
    _updateMethodMap('onOverdue', settings.onOverdue);
    _updateMethodMap('onGraded', settings.onGraded);
    _updateMethodMap('onCompleted', settings.onCompleted);
  }

  void _updateMethodMap(String event, List<int>? methods) {
    _selectedMethods[event]!.clear();
    if (methods != null) {
      for (var method in methods) {
        _selectedMethods[event]![method] = true;
      }
    }
  }

  List<int> _getSelectedMethodsForEvent(String event) {
    return _selectedMethods[event]!
        .entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
  }

  Future<void> _saveSettings() async {
    setState(() => _saving = true);
    try {
      final newSettings = NotificationSetting(
        onAssigned: _getSelectedMethodsForEvent('onAssigned'),
        onStarted: _getSelectedMethodsForEvent('onStarted'),
        onOverdue: _getSelectedMethodsForEvent('onOverdue'),
        onGraded: _getSelectedMethodsForEvent('onGraded'),
        onCompleted: _getSelectedMethodsForEvent('onCompleted'),
      );

      await apiService.updateNotificationSettings(newSettings);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Success')),
        );
      }
    } catch (e, st) {
      logError('Failed to save notification settings', e, st);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Widget _buildEventSection(String event, String label, AppLocalizations l10n) {
    return buildCard(
      context,
      blur: 20,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      color: Colors.white.withAlpha(50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: _getAvailableMethods(l10n).map((method) {
              return FilterChip(
                label: Text(method['name'] as String),
                selected: _selectedMethods[event]![method['id'] as int] ?? false,
                onSelected: (selected) async {
                  if (selected && method['id'] == NotificationSetting.MQTT) {
                    try {
                      final connected = await apiService.isMqttConnected();
                      if (!connected && mounted) {
                        showErrorNotification(l10n.mqttConnectionTestError, context: context);
                      }
                    } catch (e) {
                      if (mounted) {
                        showErrorNotification(l10n.mqttConnectionTestError, context: context);
                      }
                    }
                  }
                  setState(() {
                    _selectedMethods[event]![method['id'] as int] = selected;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Text(
                      l10n.notificationSettingsDescription,
                      style: TextStyle(color: Colors.grey[600]),
              ),
              ),
              const SizedBox(height: 16),
              _buildEventSection('onAssigned', l10n.onAssigned, l10n),
              const SizedBox(height: 16),
              _buildEventSection('onStarted', l10n.onStarted, l10n),
              const SizedBox(height: 16),
              _buildEventSection('onOverdue', l10n.onOverdue, l10n),
              const SizedBox(height: 16),
              _buildEventSection('onGraded', l10n.onGraded, l10n),
              const SizedBox(height: 16),
              _buildEventSection('onCompleted', l10n.onCompleted, l10n),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                buildElevatedButton(
                context: context,
                onPressed: _saving ? null : _saveSettings,
                icon: Icons.save,
                label: _saving ? l10n.saving : l10n.save,
              ),]),
              const SizedBox(width: 12),
              
            ],
          ),
        ),
      ),
    );
  }
}
