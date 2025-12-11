// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../pages/base.dart';
import '../themes/theme.dart';
import '../utility.dart';
import 'card.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:smartopia_hms_shared/shared.dart';
import 'package:smartopia_hms_shared/shared.dart' as shared;
import '../model/database.dart';
import '../widgets/point_badge.dart';
import 'package:provider/provider.dart';
import '../authenticator.dart';
import '../l10n/app_localizations.dart';

String _formatDateTime(DateTime dt) {
    final y = dt.year;
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $h:$min';
}



Widget _formatDateTimeWidget(DateTime dt, {bool includeDate = true, bool includeTime = true}) {
    final y = dt.year;
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white30),
                borderRadius: BorderRadius.circular(8.0),
          ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (includeDate) Icon(Icons.calendar_month , size: 14),
            if (includeDate) const SizedBox(width: 4),
            if (includeDate) Text('$y-$m-$d'),
            if (includeDate) const SizedBox(width: 10),
            if (includeTime) Icon(Icons.access_time , size: 14),
            if (includeTime) const SizedBox(width: 4),
            if (includeTime) Text('$h:$min'),
            if (includeTime)  const SizedBox(width: 4),
          ],
        ),
      );
  }

Widget _buildChip(String label, {bool isTime = true}) {
    return Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white30),
                borderRadius: BorderRadius.circular(8.0),
          ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isTime ? Icons.access_time : Icons.calendar_month , size: 14),
            const SizedBox(width: 4),
            Text(label),
            const SizedBox(width: 4),
          ],
        ),
      );
}

class TaskTemplateItem extends StatelessWidget {
  final TaskTemplate template;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;


  const TaskTemplateItem({
    super.key,
    required this.template,
    this.onEdit,
    this.onDelete,
  });

  Text _formateTaskTitle(String title, BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.taskCardTitle,
    );
  }

  Widget _formateRecurrence(RecurrencePattern pattern, BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (pattern.type) {
      case RecurrencePatternType.once:
        var p = pattern as OncePattern;
        return Wrap(
          spacing: 4,
          children: [
            Text(loc.rpOnce),
            _formatDateTimeWidget(p.startDateTime),
          ],
        );
      case RecurrencePatternType.hourly:
        var p = pattern as HourlyPattern;
        return Wrap(
          spacing: 4,
          children: [
            Text(loc.rpHourly),
            ..._formateMinuteList(p.minutes),
          ],
        );
      case RecurrencePatternType.daily:
        var p = pattern as DailyPattern;
        return Wrap(
          spacing: 4,
          children: [
            Text(loc.rpDaily),
            ..._formateTimeOfDayListWidget(p.times, context),
          ],
        );
      case RecurrencePatternType.weekly:
        var p = pattern as WeeklyPattern;
        return Wrap(
          spacing: 4,
          children: [
            Text(loc.rpWeekly),
            ..._formateDaysOfWeekWidget(p.weekdays..sort(), context),
            ..._formateTimeOfDayListWidget(p.times, context)],
        );
      case RecurrencePatternType.monthly:
        var p = pattern as MonthlyPattern;
        return Wrap(
          spacing: 4,
          children: [
            Text(loc.rpMonthly),
            ..._formateDaysOfMonth(p.daysOfMonth, context),
            ..._formateTimeOfDayListWidget(p.times, context)],
        );
      default:
        return Text( "${loc.rpDaily} ${_formatDateTime(pattern.startDateTime)}");
    }
  }


  String _formateTimeOfDay(shared.TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  List<Widget> _formateMinuteList(List<int> minutes) {
    return minutes.map((e) => _buildChip(':${e.toString().padLeft(2,'0')}')).toList();
  }



  List<Widget> _formateDaysOfWeekWidget(List<int> days, BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return days.map((e) {
      if (e == shared.DayOfWeek.sunday.value) {
        return _buildChip(loc.rpSunday, isTime: false);
      } else if (e == shared.DayOfWeek.monday.value) {
        return _buildChip(loc.rpMonday, isTime: false);
      } else if (e == shared.DayOfWeek.tuesday.value) {
        return _buildChip(loc.rpTuesday, isTime: false);
      } else if (e == shared.DayOfWeek.wednesday.value) {
        return _buildChip(loc.rpWednesday, isTime: false);
      } else if (e == shared.DayOfWeek.thursday.value) {
        return _buildChip(loc.rpThursday, isTime: false);
      } else if (e == shared.DayOfWeek.friday.value) {
        return _buildChip(loc.rpFriday, isTime: false);
      } else if (e == shared.DayOfWeek.saturday.value) {
        return _buildChip(loc.rpSaturday);
      }
      throw Exception('Invalid day of week: $e');
    }).toList();
  }

  List<Widget> _formateDaysOfMonth(List<int> days, BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return days.map((e) {
      if (e < 32) {
        return _buildChip('${e.toString().padLeft(2, '0')}', isTime: false);
      } else if (e == 32) {
        return _buildChip(loc.rpLastDayOfMonth, isTime: false);
      } 
      throw Exception('Invalid day of month: $e');
    }).toList();
  }

  List<Widget> _formateTimeOfDayListWidget(
      List<shared.TimeOfDay> timeList, BuildContext context) {
    return timeList
        .map((e) => _buildChip(
              _formateTimeOfDay(e),
            ))
        .toList();
  }


  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    var nextInstance = template.recurrence.next();
    return buildCard(
      context,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            // Row 1: title + edit/delete
            Row(
              children: [
                Expanded(
                  child: _formateTaskTitle(
                    template.title,
                    context,),
                ),
                if (onEdit != null) IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: loc.edit,
                  onPressed: onEdit,
                ),
                if (onDelete != null) IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: loc.delete,
                  onPressed: onDelete,
                ),
              ],
            ),
            if (template.description != null)
              Text('${template.description}'),
            _formateRecurrence(template.recurrence, context),
            // Row 3: next due datetime
            if(nextInstance != null && template.recurrence.type != RecurrencePatternType.once) 
              Row(
                children: [
                  Text(loc.taskUpcomingInstance),
                  const SizedBox(width: 8),
                  _formatDateTimeWidget(nextInstance),
                ],
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

  const TaskInstanceItem({
    super.key,
    required this.instance,
    this.onUpdated
  });

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
          )
        ],
      );
    }
    if (instance.cancelled) {
      statusText = AppLocalizations.of(context)!.taskStatusCancelled;
    } 
    else if (instance.startTime.isAfter(DateTime.now())){
      statusText = localizations.taskStatusNotStarted;
    }
    else if (instance.isCompleted) {
      if (instance.isGraded) { // child 
        statusText = localizations.taskStatusCompleted;
        color = Colors.green.withAlpha(50);
      }
      else { // parent
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
        border: Border.all(color: Colors.black38,),
        borderRadius: BorderRadius.circular(8),
        
        color: color,
      ),
      child: Text(statusText, 
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.black54,
        ),
      ),
    );
  
  }

  Widget buildTaskCard() {
    return GestureDetector(
      onTap: () async {
        final changed = await GoRouter.of(context).push<bool>('/tasks/${instance.id}/detail', extra: instance);
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
                  Text(
                    instance.title,
                    style: theme.textTheme.taskCardTitle,
                  ),
                  const SizedBox(height: 8),
                  if (instance.description != null) Text(
                    '${localizations.taskDescription}: ${instance.description!}',
                    style: theme.textTheme.taskCardBody),
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
              children: [
                _buildTaskStatus(context)
              ],
            )
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