// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartopia_hms_client/l10n/app_localizations.dart';
import 'package:smartopia_hms_client/widgets/card.dart';
import 'package:smartopia_hms_shared/shared.dart';
import '../config.dart';
import 'recurrence_pattern.dart';

/// Widget for global batch settings in task review page
/// Allows setting recurrency pattern and assigned users for all tasks
class TaskReviewGlobalSettings extends StatefulWidget {
  final RecurrencePattern initialRecurrence;
  final List<String> availableUsers;
  final List<String> initialAssignedUsers;
  final ValueChanged<RecurrencePattern>? onRecurrenceChanged;
  final ValueChanged<List<String>>? onAssignedUsersChanged;

  const TaskReviewGlobalSettings({
    super.key,
    required this.initialRecurrence,
    required this.availableUsers,
    this.initialAssignedUsers = const [],
    this.onRecurrenceChanged,
    this.onAssignedUsersChanged,
  });

  @override
  State<TaskReviewGlobalSettings> createState() =>
      _TaskReviewGlobalSettingsState();
}

class _TaskReviewGlobalSettingsState extends State<TaskReviewGlobalSettings> {
  bool _isExpanded = true;
  late RecurrencePattern _recurrence;
  late List<String> _assignedUsers;

  @override
  void initState() {
    super.initState();
    _recurrence = widget.initialRecurrence;
    _assignedUsers = List.from(widget.initialAssignedUsers);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return buildCard(
      context,
      color: const Color.fromARGB(193, 255, 255, 255),
      margin: const EdgeInsets.all(12),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    loc.taskReviewGlobalSettings,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  const Divider(),

                  // Multi-user assignment
                  if (widget.availableUsers.isNotEmpty) ...[
                    Text(
                      loc.taskAssignedUsers,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    //const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          widget.availableUsers.map((user) {
                            final isSelected =
                                _assignedUsers.contains(user) ||
                                widget.availableUsers.length == 1;
                            return FilterChip(
                              label: Text(user),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _assignedUsers.add(user);
                                  } else {
                                    _assignedUsers.remove(user);
                                  }
                                });
                                widget.onAssignedUsersChanged?.call(
                                  _assignedUsers,
                                );
                              },
                            );
                          }).toList(),
                    ),
                  ],

                  const SizedBox(height: 8),

                  // Recurrency pattern (always visible)
                  Text(
                    loc.recurrenceLabel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  //const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(35, 255, 255, 255),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RecurrencePatternPicker(
                      initialPattern: _recurrence,
                      onChanged: (pattern) {
                        setState(() {
                          _recurrence = pattern;
                        });
                        widget.onRecurrenceChanged?.call(pattern);
                      },
                      isSmallScreen: true,
                      locale: context.watch<AppConfig>().locale,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
