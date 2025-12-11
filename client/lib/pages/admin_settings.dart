// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../api.dart';
import '../config.dart';
import '../authenticator.dart';
import '../l10n/app_localizations.dart';
import '../notification.dart';
import '../widgets/card.dart';
import '../widgets/buttons.dart';
import '../widgets/point_system_settings.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _isLoading = false;

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final configProvider = context.read<AppConfig>();
    await configProvider.loadConfig();
  }

  Future<void> _togglePointSystem(bool value) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final configProvider = context.read<AppConfig>();
      final success = await configProvider.updatePointSystemEnabled(value);

      if (success && mounted) {
        showInfoNotification(
          value 
            ? localizations.pointSystemEnabled 
            : localizations.pointSystemDisabled,
          context: context,
        );
      } else if (mounted) {
        showErrorNotification(
          localizations.failedToUpdateSettings,
          context: context,
        );
      }
    } catch (e) {
      if (mounted) {
        showErrorNotification(
          localizations.failedToUpdateSettings,
          context: context,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _purgeTasks() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.areYouSure),
          content: Text(localizations.purgeTasksConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.confirm),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await apiService.purgeTasks();
        if (mounted) {
          showInfoNotification(
            localizations.purgeTasksSuccess,
            context: context,
          );
        }
      } catch (e) {
        if (mounted) {
          showErrorNotification(
            localizations.purgeTasksError,
            context: context,
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _purgeTaskTemplates() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.areYouSure),
          content: Text(localizations.purgeTaskTemplatesConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.confirm),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await apiService.purgeTaskTemplates();
        if (mounted) {
          showInfoNotification(
            localizations.taskTemplatesPurgedSuccessfully,
            context: context,
          );
        }
      } catch (e) {
        if (mounted) {
          showErrorNotification(
            localizations.failedToPurgeTaskTemplates(e.toString()),
            context: context,
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _exportTaskTemplates() async {
    setState(() => _isLoading = true);
    try {
      final templates = await apiService.exportTaskTemplates();
      final jsonString = jsonEncode(templates);

      final result = await FilePicker.platform.saveFile(
        dialogTitle: localizations.saveTaskTemplates,
        fileName:
            'task_templates_${DateTime.now().millisecondsSinceEpoch}.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final file = File(result);
        await file.writeAsString(jsonString);
        if (mounted) {
          showInfoNotification(
            localizations.taskTemplatesExportedSuccessfully,
            context: context,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorNotification(
          localizations.failedToExportTaskTemplates(e.toString()),
          context: context,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _importTaskTemplates() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() => _isLoading = true);
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final templates = jsonDecode(jsonString) as List;

        final importResult = await apiService.importTaskTemplates(
          templates.cast<Map<String, dynamic>>(),
        );

        if (mounted && importResult != null) {
          final importedCount = importResult['importedCount'] as int;
          final duplicates =
              importResult['duplicates'] as List<Map<String, dynamic>>;

          if (duplicates.isNotEmpty) {
            await _showDuplicatesDialog(
              localizations.taskTemplates,
              duplicates,
              hasStartTime: false,
            );
          }

          showInfoNotification(
            duplicates.isNotEmpty
                ? localizations.importedTaskTemplatesWithDuplicates(
                  importedCount,
                  duplicates.length,
                )
                : localizations.importedTaskTemplates(importedCount),
            context: context,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorNotification(
          localizations.failedToImportTaskTemplates(e.toString()),
          context: context,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _exportTasks() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await apiService.exportTasks();
      final jsonString = jsonEncode(tasks);

      final result = await FilePicker.platform.saveFile(
        dialogTitle: localizations.saveTasks,
        fileName: 'tasks_${DateTime.now().millisecondsSinceEpoch}.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final file = File(result);
        await file.writeAsString(jsonString);
        if (mounted) {
          showInfoNotification(
            localizations.tasksExportedSuccessfully,
            context: context,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorNotification(
          localizations.failedToExportTasks(e.toString()),
          context: context,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _importTasks() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() => _isLoading = true);
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final tasks = jsonDecode(jsonString) as List;

        final importResult = await apiService.importTasks(
          tasks.cast<Map<String, dynamic>>(),
        );

        if (mounted && importResult != null) {
          final importedCount = importResult['importedCount'] as int;
          final duplicates =
              importResult['duplicates'] as List<Map<String, dynamic>>;

          if (duplicates.isNotEmpty) {
            await _showDuplicatesDialog(
              localizations.tasks,
              duplicates,
              hasStartTime: true,
            );
          }

          showInfoNotification(
            duplicates.isNotEmpty
                ? localizations.importedTasksWithDuplicates(
                  importedCount,
                  duplicates.length,
                )
                : localizations.importedTasks(importedCount),
            context: context,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorNotification(
          localizations.failedToImportTasks(e.toString()),
          context: context,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showDuplicatesDialog(
    String itemType,
    List<Map<String, dynamic>> duplicates, {
    required bool hasStartTime,
  }) async {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withAlpha(125),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    localizations.duplicateItemsNotImported(itemType),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: duplicates.length,
                    itemBuilder: (context, index) {
                      final item = duplicates[index];
                      final title =
                          item['title'] as String? ?? localizations.noTitle;
                      final assignedUsers =
                          (item['assignedUsers'] as List?)?.join(', ') ??
                          localizations.none;
                      final startTime =
                          hasStartTime && item['startTime'] != null
                              ? DateTime.parse(item['startTime'] as String)
                              : null;

                      return ListTile(
                        title: Text(title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${localizations.assigned}: $assignedUsers'),
                            if (startTime != null)
                              Text(
                                '${localizations.start}: ${startTime.toLocal()}',
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(localizations.dismiss),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.read<AuthProvider>().isAuthenticated;
    if (!isAuthenticated) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            localizations.pleaseLoginToAccessAdminSettings,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              
              // Point System Toggle
              buildCard(
                context,
                blur: 20,
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withAlpha(50),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.stars,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            localizations.enablePointSystem,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.pointSystemDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Consumer<AppConfig>(
                        builder: (context, configProvider, child) {
                          return SwitchListTile(
                            value: configProvider.pointSystemEnabled,
                            onChanged: _isLoading ? null : _togglePointSystem,
                            title: Text(
                              configProvider.pointSystemEnabled 
                                ? localizations.pointSystemEnabled
                                : localizations.pointSystemDisabled,
                            ),
                            contentPadding: EdgeInsets.zero,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              if (context.read<AppConfig>().pointSystemEnabled) ...[
                PointSystemSettingsWidget(),
                const SizedBox(height: 24),
              ],
              

              // Task Templates Section
              buildCard(
                context,
                blur: 20,
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withAlpha(50),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            localizations.taskTemplates,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: buildElevatedButton(
                              context: context,
                              onPressed:
                                  _isLoading ? null : _exportTaskTemplates,
                              icon: Icons.download,
                              label: localizations.export,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: buildElevatedButton(
                              context: context,
                              onPressed:
                                  _isLoading ? null : _importTaskTemplates,
                              icon: Icons.upload,
                              label: localizations.import,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      buildElevatedButton(
                        context: context,
                        onPressed: _isLoading ? null : _purgeTaskTemplates,
                        icon: Icons.delete_forever,
                        label: localizations.purgeAllTemplates,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Tasks Section
              buildCard(
                context,
                blur: 20,
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withAlpha(50),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.assignment,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            localizations.tasks,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: buildElevatedButton(
                              context: context,
                              onPressed: _isLoading ? null : _exportTasks,
                              icon: Icons.download,
                              label: localizations.export,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: buildElevatedButton(
                              context: context,
                              onPressed: _isLoading ? null : _importTasks,
                              icon: Icons.upload,
                              label: localizations.import,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      buildElevatedButton(
                        context: context,
                        onPressed: _isLoading ? null : _purgeTasks,
                        icon: Icons.delete_forever,
                        label: localizations.purgeTasks,
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
}
