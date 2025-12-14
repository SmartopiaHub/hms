import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartopia_hms_client/api.dart';
import 'package:smartopia_hms_client/l10n/app_localizations.dart';
import 'package:smartopia_hms_client/model/database.dart';
import 'package:smartopia_hms_client/pages/base.dart';
import 'package:smartopia_hms_client/widgets/task_item.dart';
import 'package:smartopia_hms_client/widgets/task_review_global_settings.dart';
import 'package:smartopia_hms_shared/shared.dart';

import '../notification.dart';

class TaskReviewPage extends StatefulWidget {
  final List<TaskTemplate> initialTasks;

  const TaskReviewPage({super.key, required this.initialTasks});

  @override
  State<TaskReviewPage> createState() => _TaskReviewPageState();
}

class _TaskReviewPageState extends PageBaseState<TaskReviewPage> {
  late List<TaskTemplate> _tasks;
  bool _isSaving = false;
  final Set<int> _createdTaskIndices = {};

  // Per-task settings
  final Map<int, List<String>> _taskAssignedUsers = {};
  final Map<int, int> _taskRewardPoints = {};

  // Global batch settings
  late RecurrencePattern _globalRecurrence;
  List<String> _globalAssignedUsers = [];
  bool _applyGlobalRecurrence = false;

  // Available users for dropdown
  List<String> _availableUsers = [];
  bool _isLoadingUsers = false;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.initialTasks);

    // Initialize default recurrence (Once task, due in 24 hours)
    final now = DateTime.now();
    _globalRecurrence = OncePattern(
      startDateTime: now,
      dueDateTime: now.add(const Duration(hours: 24)),
    );

    _loadAvailableUsers();
  }

  Future<void> _loadAvailableUsers() async {
    setState(() {
      _isLoadingUsers = true;
    });

    try {
      final users = await apiService.getChildList();
      if (mounted) {
        setState(() {
          _availableUsers = users;
          _isLoadingUsers = false;

          // Auto-assign if only one child is available
          if (_availableUsers.length == 1) {
            final singleChild = _availableUsers.first;
            for (int i = 0; i < _tasks.length; i++) {
              // Only auto-assign if not already set (though initially empty)
              if (_taskAssignedUsers[i] == null ||
                  _taskAssignedUsers[i]!.isEmpty) {
                _taskAssignedUsers[i] = [singleChild];
              }
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingUsers = false;
        });
      }
    }
  }

  @override
  String get pageTitle => AppLocalizations.of(context)!.reviewTasks;

  @override
  bool get goBackButtonInAppBar => true;

  Future<void> _handleConfirm() async {
    setState(() {
      _isSaving = true;
    });

    final loc = AppLocalizations.of(context)!;

    try {
      int successCount = 0;
      for (int i = 0; i < _tasks.length; i++) {
        // Skip already created tasks
        if (_createdTaskIndices.contains(i)) continue;

        var task = _tasks[i];

        // Ensure title is within 256 chars
        if (task.title.length > 256) {
          task = task.copyWith(title: task.title.substring(0, 256));
        }

        // 1. Apply per-task assigned users
        final assigned = _taskAssignedUsers[i];
        if (assigned != null && assigned.isNotEmpty) {
          task = task.copyWith(assignedUsers: assigned);
        } else if (_globalAssignedUsers.isNotEmpty) {
          // Fallback to global assignment if per-task is empty
          task = task.copyWith(assignedUsers: _globalAssignedUsers);
        }

        // 2. Apply per-task reward points
        final points = _taskRewardPoints[i];
        if (points != null) {
          final newRewardInfo =
              task.rewards != null
                  ? task.rewards!.copyWith(maxPoints: points)
                  : RewardInfo(maxPoints: points, description: null);
          task = task.copyWith(rewards: Value(newRewardInfo));
        }

        // 3. Apply recurrence
        // If global toggle is on, override everything. Otherwise respect task's own recurrence.
        if (_applyGlobalRecurrence) {
          task = task.copyWith(recurrence: _globalRecurrence);
        }

        final taskToCreate = task.copyWith(id: 0);
        final success = await apiService.createTaskTemplate(taskToCreate);
        if (success) {
          successCount++;
        }
      }

      if (mounted) {
        showInfoNotification(
          '${loc.taskCreated}: $successCount',
          context: context,
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        showErrorNotification(
          loc.errorSavingTasks(e.toString()),
          context: context,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (_tasks.isEmpty) {
      return Center(child: Text(loc.noTasksToReview));
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            var task = _tasks[index];
            // Apply effective recurrence for display if global is on
            if (_applyGlobalRecurrence) {
              task = task.copyWith(recurrence: _globalRecurrence);
            }

            return TaskTemplateItem(
              template: task,
              isCreated: _createdTaskIndices.contains(index),
              showQuickSettings: true,
              assignedUsers: _taskAssignedUsers[index] ?? [],
              rewardPoints: _taskRewardPoints[index] ?? 1,
              availableUsers: _availableUsers,
              onAssignedUsersChanged: (users) {
                setState(() {
                  _taskAssignedUsers[index] = users;
                });
              },
              onRewardPointsChanged: (points) {
                setState(() {
                  _taskRewardPoints[index] = points;
                });
              },
              onRecurrenceChanged: (pattern) {
                setState(() {
                  // Direct modification
                  // If global is on, user should probably be warned or we assume editing individual task disables global override?
                  // Requirement: "if it is on, apply the global setting to all tasks regardless of their own setting."
                  // This implies if they edit an individual one, it might conflict.
                  // For now, let's just update the individual task. If global is ON, it will likely visually override it due to the 'if' above.
                  // Maybe we should disable editing if global is on?
                  // Or better, let's assume editing a specific one is allowed but the global toggle needs to be respected.
                  // If I edit one, I update the underlying task. But if global is ON, the UI shows global.
                  // So editing has no visual effect until global is OFF.
                  // Ideally we disable the picker if _applyGlobalRecurrence is true.

                  // For MVP per request: "modify the corresponding task"
                  _tasks[index] = _tasks[index].copyWith(recurrence: pattern);
                });
              },
              onEdit: () async {
                final created = await context.push<bool>(
                  '/templates/create',
                  extra: {
                    'taskTemplate': task,
                    'returnOnSubmit': false,
                    'fromReview': true,
                  },
                );

                // Mark task as created if successful
                if (created == true) {
                  setState(() {
                    _createdTaskIndices.add(index);
                  });
                }
              },
              onDelete: () {
                setState(() {
                  _tasks.removeAt(index);
                  _taskAssignedUsers.remove(index);
                  _taskRewardPoints.remove(index);
                  //_taskRecurrence.remove(index);
                });
              },
            );
          },
        ),

        // Global settings panel
        TaskReviewGlobalSettings(
          initialRecurrence: _globalRecurrence,
          availableUsers: _availableUsers,
          initialAssignedUsers: _globalAssignedUsers,
          applyGlobalRecurrence: _applyGlobalRecurrence,
          onRecurrenceChanged: (pattern) {
            setState(() {
              _globalRecurrence = pattern;
            });
          },
          onAssignedUsersChanged: (users) {
            setState(() {
              _globalAssignedUsers = users;
            });
          },
          onApplyGlobalRecurrenceChanged: (value) async {
            if (value) {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(loc.applyGlobalRecurrence),
                      content: Text(loc.applyGlobalRecurrenceConfirmation),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(loc.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(loc.confirm),
                        ),
                      ],
                    ),
              );
              if (confirm == true) {
                setState(() {
                  _applyGlobalRecurrence = true;
                });
              }
            } else {
              setState(() {
                _applyGlobalRecurrence = false;
              });
            }
          },
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _handleConfirm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child:
                  _isSaving
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Text(loc.taskReviewConfirmCreate),
            ),
          ),
        ),
      ],
    );
  }
}
