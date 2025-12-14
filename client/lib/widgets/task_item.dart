// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../config.dart';
import 'recurrence_pattern.dart';
import '../pages/base.dart';
import '../themes/theme.dart';
import '../utility.dart';
import 'card.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:smartopia_hms_client/widgets/number_field.dart';
import 'package:smartopia_hms_shared/shared.dart';
import '../model/database.dart';
import '../widgets/point_badge.dart';
import 'package:provider/provider.dart';
import '../authenticator.dart';
import '../l10n/app_localizations.dart';

class TaskTemplateItem extends StatefulWidget {
  final TaskTemplate template;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isCreated;
  final bool showQuickSettings;
  final List<String> assignedUsers;
  final int rewardPoints;
  final List<String>? availableUsers;
  final ValueChanged<List<String>>? onAssignedUsersChanged;
  final ValueChanged<int>? onRewardPointsChanged;
  final ValueChanged<RecurrencePattern>? onRecurrenceChanged;

  const TaskTemplateItem({
    super.key,
    required this.template,
    this.onEdit,
    this.onDelete,
    this.isCreated = false,
    this.showQuickSettings = false,
    this.assignedUsers = const [],
    this.rewardPoints = 1,
    this.availableUsers,
    this.onAssignedUsersChanged,
    this.onRewardPointsChanged,
    this.onRecurrenceChanged,
  });

  @override
  State<TaskTemplateItem> createState() => _TaskTemplateItemState();
}

class _TaskTemplateItemState extends State<TaskTemplateItem> {
  late TextEditingController _rewardController;
  bool _isRecurrenceExpanded = false;

  @override
  void initState() {
    super.initState();
    _rewardController = TextEditingController(
      text: widget.rewardPoints.toString(),
    );
    _rewardController.addListener(_onRewardChanged);
  }

  @override
  void didUpdateWidget(TaskTemplateItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rewardPoints != oldWidget.rewardPoints) {
      final current = int.tryParse(_rewardController.text);
      if (current != widget.rewardPoints) {
        _rewardController.text = widget.rewardPoints.toString();
      }
    }
  }

  @override
  void dispose() {
    _rewardController.removeListener(_onRewardChanged);
    _rewardController.dispose();
    super.dispose();
  }

  void _onRewardChanged() {
    final value = int.tryParse(_rewardController.text);
    if (value != null && value != widget.rewardPoints) {
      widget.onRewardPointsChanged?.call(value);
    }
  }

  Widget _formateTaskTitle(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _formateRecurrence(
    RecurrencePattern? recurrence,
    BuildContext context,
  ) {
    if (recurrence == null) return const SizedBox.shrink();
    final loc = AppLocalizations.of(context)!;
    String text = '';

    if (recurrence is OncePattern) {
      text =
          '${loc.rpOnce} ${recurrence.dueDateTime != null ? formatDateTime(recurrence.dueDateTime!) : ""}';
    } else if (recurrence is HourlyPattern) {
      text = loc.rpHourly;
    } else if (recurrence is DailyPattern) {
      text = loc.rpDaily;
    } else if (recurrence is WeeklyPattern) {
      text = loc.rpWeekly;
    } else if (recurrence is MonthlyPattern) {
      text = loc.rpMonthly;
    } else if (recurrence is YearlyPattern) {
      text = loc.rpYearly;
    } else {
      text = recurrence.type.toString();
    }

    // Only allow expansion if we have a callback to change it
    final canEdit = widget.onRecurrenceChanged != null;

    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.repeat, size: 14, color: Colors.black87),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (canEdit)
            Icon(
              _isRecurrenceExpanded ? Icons.expand_less : Icons.expand_more,
              size: 16,
              color: Colors.grey,
            ),
        ],
      ),
    );

    if (!canEdit) return content;

    return InkWell(
      onTap: () {
        setState(() {
          _isRecurrenceExpanded = !_isRecurrenceExpanded;
        });
      },
      child: content,
    );
  }

  Widget _formateAssignedUsers(List<String> users, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Text('${localizations.assigned}: ${users.join(', ')}');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final auth = context.read<AuthProvider>();

    return buildCard(
      context,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      //elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: _formateTaskTitle(
                          widget.template.title,
                          context,
                        ),
                      ),
                      if (widget.isCreated) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: widget.onEdit,
                  tooltip: localizations.edit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 20,
                    color: Color.fromARGB(255, 141, 12, 3),
                  ),
                  onPressed: widget.onDelete,
                  tooltip: localizations.delete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (widget.template.description != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.template.description!),
              ),

            if (auth.isParent && !widget.showQuickSettings)
              Align(
                alignment: Alignment.centerLeft,
                child: _formateAssignedUsers(
                  widget.template.assignedUsers,
                  context,
                ),
              ),

            // Quick settings (inline editors)
            if (widget.showQuickSettings) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Assigned user selector
                  if (widget.availableUsers != null &&
                      widget.availableUsers!.isNotEmpty) ...[
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            localizations.taskAssignedUsers,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children:
                                widget.availableUsers!.map((user) {
                                  final isSelected = widget.assignedUsers
                                      .contains(user);
                                  return FilterChip(
                                    label: Text(user),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      final updatedList = List<String>.from(
                                        widget.assignedUsers,
                                      );
                                      if (selected) {
                                        updatedList.add(user);
                                      } else {
                                        updatedList.remove(user);
                                      }
                                      widget.onAssignedUsersChanged?.call(
                                        updatedList,
                                      );
                                    },
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],

                  // Reward points input
                  if (widget.onRewardPointsChanged != null)
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            localizations.taskRewardPoints,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Transform.scale(
                            scale: 0.8,
                            child: NumberField(
                              controller: _rewardController,
                              min: 0,
                              max: 1000,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            _formateRecurrence(widget.template.recurrence, context),
            if (widget.onRecurrenceChanged != null && _isRecurrenceExpanded)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withAlpha(50),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withAlpha(50)),
                ),
                child: RecurrencePatternPicker(
                  initialPattern: widget.template.recurrence,
                  onChanged: (pattern) {
                    widget.onRecurrenceChanged?.call(pattern);
                  },
                  isSmallScreen: true,
                  locale: context.watch<AppConfig>().locale,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TaskInstanceItem extends StatefulWidget {
  final Task instance;
  final VoidCallback? onUpdated;

  const TaskInstanceItem({super.key, required this.instance, this.onUpdated});

  @override
  State<TaskInstanceItem> createState() => _TaskInstanceItemState();
}

class _TaskInstanceItemState extends PageBaseState<TaskInstanceItem> {
  late Task instance;

  @override
  void initState() {
    super.initState();
    instance = widget.instance;
  }

  bool get isWide => MediaQuery.of(context).size.width > 600;

  Widget _buildTaskStatus(BuildContext context) {
    var statusText = '';
    Color? color;
    if (instance.isGraded && instance.rewards?.pointsAwarded != null) {
      final maxPoints = instance.rewards!.maxPoints ?? 0;
      final points = instance.rewards!.pointsAwarded!;
      final stars = maxPoints > 0 ? (points / maxPoints * 5).round() : 0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (starIndex) {
              return Icon(
                starIndex < stars ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: isWide ? 20 : 16,
              );
            }),
          ),
          const SizedBox(height: 4),
          PointBadge(
            points: points,
            pointSystemId: context.read<AuthProvider>().pointSystemId,
            iconSize: 14,
            fontSize: 12,
            color: Colors.amber[800],
          ),
        ],
      );
    }
    if (instance.cancelled) {
      statusText = AppLocalizations.of(context)!.taskStatusCancelled;
    } else if (instance.startTime.isAfter(DateTime.now())) {
      statusText = localizations.taskStatusNotStarted;
    } else if (instance.isCompleted) {
      if (instance.isGraded) {
        // child
        statusText = localizations.taskStatusCompleted;
        color = Colors.green.withAlpha(50);
      } else {
        // parent
        statusText = localizations.taskStatusAwaitGrading;
      }
    } else if (instance.isOverdue) {
      statusText = localizations.taskStatusOverdue;
      color = Colors.red.withAlpha(100);
    } else {
      statusText = localizations.taskStatusInProgress;
      color = Colors.blue.withAlpha(100);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(8),

        color: color,
      ),
      child: Text(
        statusText,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.black54),
      ),
    );
  }

  Widget buildTaskCard() {
    return GestureDetector(
      onTap: () async {
        final changed = await GoRouter.of(
          context,
        ).push<bool>('/tasks/${instance.id}/detail', extra: instance);
        if (changed == true && widget.onUpdated != null) {
          widget.onUpdated!();
        }
      },
      child: buildCard(
        context,
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(instance.title, style: theme.textTheme.taskCardTitle),
                  const SizedBox(height: 8),
                  if (instance.description != null)
                    Text(
                      '${localizations.taskDescription}: ${instance.description!}',
                      style: theme.textTheme.taskCardBody,
                    ),
                  if (instance.description != null) const SizedBox(height: 8),
                  Text(
                    '${localizations.taskStartAt}: ${formatDateTime(instance.startTime)}',
                    style: theme.textTheme.taskCardBody,
                  ),
                  Text(
                    '${localizations.taskDueDate}: ${formatDateTime(instance.dueTime)}',
                    style: theme.textTheme.taskCardBody,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_buildTaskStatus(context)],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: buildTaskCard(),
    );
  }
}
