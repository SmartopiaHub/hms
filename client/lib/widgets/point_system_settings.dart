// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import 'package:smartopia_hms_shared/shared.dart';
import '../notification.dart';
import '../api.dart';
import '../logger.dart';
import '../l10n/app_localizations.dart';
import 'card.dart';
import '../config.dart';
import 'package:provider/provider.dart';

class PointSystemSettingsWidget extends StatefulWidget {
  const PointSystemSettingsWidget({super.key});

  @override
  State<PointSystemSettingsWidget> createState() => _PointSystemSettingsWidgetState();
}

class _PointSystemSettingsWidgetState extends State<PointSystemSettingsWidget> {
  bool _loading = true;
  String? _selectedPointSystemId;
  late PointSystem _pointSystem;

  @override
  void initState() {
    super.initState();
    _pointSystem = PointSystem.fromJson(PointSystem.defaultJsonData);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _loading = true);
    try {
      final user = await apiService.getPointSystem();
      if (mounted) {
        setState(() {
          _selectedPointSystemId = user;
        });
      }
    } catch (e, st) {
      logError('Failed to load point system settings', e, st);
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _saveSettings() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await apiService.updatePointSystem(_selectedPointSystemId);
    } catch (e, st) {
      logError('Failed to save point system settings', e, st);
      if (mounted) {
        showInfoNotification(l10n.pointSystemSettingFailed, context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = context.watch<AppConfig>().locale;
    final isZh = locale.languageCode == 'zh';

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      //padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              buildCard(
                context,
                blur: 20,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withAlpha(50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.pointSystemSettingsDescription,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: _pointSystem.points.map((point) {
                        return ChoiceChip(
                          label: Text(isZh ? point.nameZh : point.nameEn),
                          selected: _selectedPointSystemId == point.id,
                          onSelected: (selected) {
                            setState(() {
                              _selectedPointSystemId = selected ? point.id : null;
                              _saveSettings();
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              
              
            ],
          ),
        ),
      ),
    );
  }
}
