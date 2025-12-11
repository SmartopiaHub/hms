// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../model/database.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

enum DateFilter { today, tomorrow, thisWeek, nextWeek, thisWeekend }

typedef OnFiltersChanged = void Function({
  DateFilter? date,
  Set<String> children,
  Set<TaskStatus> statuses,
});

class TaskFilterPanel extends StatelessWidget {
  final DateFilter? selectedDate;
  final Set<String> selectedChildren;
  final Set<TaskStatus> selectedStatuses;
  final List<String> allChildren;

  final OnFiltersChanged onChanged;

  const TaskFilterPanel({
    super.key,
    required this.selectedDate,
    required this.selectedChildren,
    required this.selectedStatuses,
    required this.allChildren,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final _allStatuses = TaskStatus.values.toSet()..remove(TaskStatus.cancelled);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.filterByDate, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DateFilter.values.map((f) {
                final label = switch (f) {
                  DateFilter.today    => loc.filterToday,
                  DateFilter.tomorrow => loc.filterTomorrow,
                  DateFilter.thisWeekend  => loc.filterThisWeekend,
                  DateFilter.thisWeek     => loc.filterThisWeek,
                  DateFilter.nextWeek     => loc.filterNextWeek,
                };
                return ChoiceChip(
                  label: Text(label),
                  selected: f == selectedDate,
                  onSelected: (_) => onChanged(
                    date: f,
                    children: selectedChildren,
                    statuses: selectedStatuses,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            if (allChildren.length > 1) ...[
              Text(loc.filterByChild, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allChildren.map((c) {
                  return FilterChip(
                      label: Text(c),
                      selected: selectedChildren.contains(c),
                      onSelected: (yes) {
                        final next = Set.of(selectedChildren);
                        yes ? next.add(c) : next.remove(c);
                        onChanged(
                          date: selectedDate,
                          children: next,
                          statuses: selectedStatuses,
                        );
                      },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            Text(loc.filterByStatus, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allStatuses.map((s) {
                final label = switch (s) {
                  TaskStatus.notStarted     => loc.taskStatusNotStarted,
                  TaskStatus.inProgress => loc.taskStatusInProgress,
                  TaskStatus.completed => loc.taskStatusCompleted,
                  TaskStatus.overdue   => loc.taskStatusOverdue,
                  TaskStatus.graded   => loc.taskStatusGraded,
                  TaskStatus.cancelled => loc.taskStatusCancelled,
                };
                return ChoiceChip(
                  label: Text(label),
                  selected: selectedStatuses.contains(s),
                  onSelected: (yes) {
                        final next = Set.of(selectedStatuses);
                        yes ? next.add(s) : next.remove(s);
                        onChanged(
                          date: selectedDate,
                          children: selectedChildren,
                          statuses: next,
                        );
                  },
                );
              }).toList(),
            ),
            
          ],
        ),
      ),
    );
  }
}