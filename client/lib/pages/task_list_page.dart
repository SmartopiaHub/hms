// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:smartopia_hms_client/logger.dart';
import 'package:smartopia_hms_client/notification.dart';

import '../api.dart';
import '../model/database.dart';
import 'base.dart';
import '../utility.dart';
import '../widgets/task_filter_panel.dart';
import '../widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends PageBaseState<TaskListPage> {

  static const _pageSize = 5;
  

  DateFilter? _selectedDate = DateFilter.today;
  Set<String> _selectedChildren = {};
  Set<TaskStatus> _selectedStatuses = {
    TaskStatus.completed,
    TaskStatus.inProgress,
    TaskStatus.notStarted,
    TaskStatus.overdue,
    TaskStatus.graded,
  };
  
  List<String> get _allChildren => [];

  int _getStatusPriority(TaskStatus status) {
    // Lower number = higher priority
    switch (status) {
      case TaskStatus.overdue:
        return 0;
      case TaskStatus.inProgress:
        return 1;
      case TaskStatus.notStarted:
        return 2;
      case TaskStatus.completed:
        return 3;
      case TaskStatus.graded:
        return 4;
      default:
        return 5;
    }
  }

  List<pw.Widget> _buildTaskDetails(pw.Context context, Task task) {
    final widgets = <pw.Widget>[];
    const double indent = 20;
    const double spacing = 2;
    widgets.add(
      pw.Text(task.title, style: pw.TextStyle(fontSize: 14))
    );
    widgets.add(pw.SizedBox(height: 2));
    if (task.description != null && task.description!.isNotEmpty) {
        widgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(left: indent, top: spacing, bottom: spacing),
            child: pw.Text(
              task.description!,
              style: pw.TextStyle(fontSize: 11),
            ),
          ),
      );
    }
    widgets.add(
      pw.Container(
            margin: const pw.EdgeInsets.only(left: indent, top: spacing, bottom: spacing),
            child: pw.Text('${localizations.taskStartAt}: ${formatDateTime(task.startTime)}')
          ),
      
    );
    widgets.add(
      pw.Container(
            margin: const pw.EdgeInsets.only(left: indent, top: spacing, bottom: spacing),
            child: pw.Text('${localizations.taskDueAt}: ${formatDateTime(task.dueTime)}')
          ),
    );
    widgets.add(pw.SizedBox(height: 8));
    return widgets;

  }
  
  Future<void> _printTasks() async {
    // grab whatever you want to print (all currently loaded items, or fetch fresh)
    final tasks = _taskPagingController.items ?? [];

    Duration overallDurationInMinutes = Duration.zero;
    for (final task in tasks) {
      overallDurationInMinutes += task.expectedCompletionTimeInMinutes;
    }
  
    // build a PDF document
    final chinese = await PdfGoogleFonts.notoSansSCRegular();
    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: chinese),
    );
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('${localizations.taskInstanceListTitle}  (${formatDuration(overallDurationInMinutes)})')),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: tasks.map((task) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: _buildTaskDetails(context, task),
              )).toList()
          ),
          /*pw.ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, i) {
              final t = tasks[i];
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: _buildTaskDetails(context, t),
              );
            },
          ),*/
        ],
      ),
    );
  
    // show the print/share dialog
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) => doc.save(),
    );
  }

  Future<void> _exportTasksToPdf() async {
    // Get tasks to export
    final tasks = _taskPagingController.items ?? [];
    if (tasks.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.noTasks)),
        );
      }
      return;
    }

    Duration overallDurationInMinutes = Duration.zero;
    for (final task in tasks) {
      overallDurationInMinutes += task.expectedCompletionTimeInMinutes;
    }
  
    // Build PDF document
    final chinese = await PdfGoogleFonts.notoSansSCRegular();
    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: chinese),
    );
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('${localizations.taskInstanceListTitle}  (${formatDuration(overallDurationInMinutes)})')),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: tasks.map((task) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: _buildTaskDetails(context, task),
              )).toList()
          ),
        ],
      ),
    );

    final pdfBytes = await doc.save();
    final now = DateTime.now();
    final defaultFileName = 'tasks_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}.pdf';

    if (kIsWeb) {
      // For web platform, trigger download
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', defaultFileName)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // For desktop/mobile, use file picker to let user choose save location
      final path = await FilePicker.platform.saveFile(
        dialogTitle: 'Save PDF',
        fileName: defaultFileName,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (path != null) {
        final file = File(path);
        await file.writeAsBytes(pdfBytes);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('PDF saved to $path')),
          );
        }
      }
    }
  }
  
  DateTime? get _filterStartDateTime {
    if (_selectedDate == null) return null;
    final now = DateTime.now();
    switch (_selectedDate!) {
      case DateFilter.today:
        return DateTime(now.year, now.month, now.day);
      case DateFilter.tomorrow:
        return DateTime(now.year, now.month, now.day + 1);
      case DateFilter.thisWeekend:
        // Assuming weekend starts on Saturday
        if (now.weekday == DateTime.saturday) {
          return DateTime(now.year, now.month, now.day);
        } else if (now.weekday == DateTime.sunday) {
          return DateTime(now.year, now.month, now.day - 1);
        }
        // If it's a weekday, return the upcoming Saturday
        return DateTime(now.year, now.month, now.day + (DateTime.saturday - now.weekday));

      case DateFilter.thisWeek:
        // Start of the week (Monday)
        return DateTime(now.year, now.month, now.day - (now.weekday - 1));
      case DateFilter.nextWeek:
        return DateTime(now.year, now.month, now.day - (now.weekday - 1) + 7);
    }
  }

  DateTime? get _filterEndDateTime {
    if (_selectedDate == null) return null;
    final start = _filterStartDateTime;
    switch (_selectedDate!) {
      case DateFilter.today:
        return start?.add(const Duration(hours: 23, minutes: 59, seconds: 59));
      case DateFilter.tomorrow:
        return start?.add(const Duration(hours: 23, minutes: 59, seconds: 59));
      case DateFilter.thisWeekend:
        return start?.add(const Duration(days: 1, hours: 23, minutes: 59, seconds: 59));
      case DateFilter.thisWeek:
      case DateFilter.nextWeek:
        return start?.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    }
  }

  Future<List<Task>> _fetchTasks(int pageKey) async {
    try{
      final tasks = await apiService.searchTasks(
        pageKey: pageKey,
        tasksPerPage: _pageSize,
        start: _filterStartDateTime,
        end: _filterEndDateTime,
        assignedUsers: _selectedChildren.toList(),
        statuses: _selectedStatuses.toList(),
      );
      
      // Sort tasks by status priority: overdue > in progress > not started > completed > graded
      tasks.sort((a, b) {
        final priorityA = _getStatusPriority(a.status);
        final priorityB = _getStatusPriority(b.status);
        if (priorityA != priorityB) {
          return priorityA.compareTo(priorityB);
        }
        // Within the same status, sort by due time (earlier first)
        return a.dueTime.compareTo(b.dueTime);
      });
      return tasks;
    }
    catch(e){
      logError('Failed to fetch tasks', e);
      if (mounted) showErrorNotification(e.toString(), context: context);
      return [];
    }
  }

  late PagingController<int, Task> _taskPagingController;


  void _onFiltersChanged({
    DateFilter? date,
    Set<String>? children,
    Set<TaskStatus>? statuses,
  }) {
    setState(() {
      _selectedDate      = date;
      _selectedChildren  = children!;
      _selectedStatuses  = statuses!;
      _taskPagingController.refresh();
    });
  }

  @override
  void initState() {
    super.initState();
    _taskPagingController = PagingController(
        getNextPageKey: (state){
          if (state.pages != null && state.pages!.isNotEmpty) {
            if (state.pages!.last.length < _pageSize) {
              return null;
            }
          } 
          return (state.keys?.last ?? 0) + 1;
        },
        fetchPage: (pageKey) async => _fetchTasks(pageKey),
      );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Example: fetch children from API or database
      final children = await apiService.getChildList();
      if (!mounted) return;
      setState(() {
        _selectedChildren = children.toSet();
      });
    });
  }

  String get title {
    String filterByDate = _selectedDate != null
        ? switch (_selectedDate!) {
            DateFilter.today => localizations.filterToday,
            DateFilter.tomorrow => localizations.filterTomorrow,
            DateFilter.thisWeekend => localizations.filterThisWeekend,
            DateFilter.thisWeek => localizations.filterThisWeek,
            DateFilter.nextWeek => localizations.filterNextWeek,
          }
        : '';
    return '${localizations.tasks} ${filterByDate.isNotEmpty ? '($filterByDate)' : ''}';
  }


  Widget _buildTaskItem(Task item){
    return TaskInstanceItem(
            instance: item,
            onUpdated: () async {
              setState(() {
                _taskPagingController.refresh();
              });
              
            },
          
          );
  }


  Widget _buildTaskList(BuildContext context) {
    return PagingListener(
        controller: _taskPagingController,
      builder: (context, state, fetchNextPage) => PagedListView<int, Task>(
        state: state,
        fetchNextPage: fetchNextPage,
        shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => _buildTaskItem(item),
          noItemsFoundIndicatorBuilder: (_) => Center(child: Text(localizations.noTasks)),
            firstPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
            newPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  @override

  String get pageTitle => title;

  @override
  Widget buildContent(BuildContext context) {
    return _buildTaskList(context);
  }

  @override
  Drawer buildEndDrawer(BuildContext context) {
    return Drawer(
              child: TaskFilterPanel(
                selectedDate:      _selectedDate,
                selectedChildren:  _selectedChildren,
                selectedStatuses:  _selectedStatuses,
                allChildren:       _allChildren,
                onChanged:         _onFiltersChanged,
              ),
    );
  }

  @override
  Widget buildFloatingActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Builder(builder: (ctx) {
            return FloatingActionButton(
              heroTag: 'filterFab',
              mini: true,
              tooltip: localizations.taskFilter,
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
              child: const Icon(Icons.filter_list),
            );
          }),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'printFab',
            mini: true,
            tooltip: localizations.taskPrint,
            onPressed: _printTasks,
            child: const Icon(Icons.print),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'exportFab',
            mini: true,
            tooltip: 'Export PDF',
            onPressed: _exportTasksToPdf,
            child: const Icon(Icons.picture_as_pdf),
          ),
        ],
      ),
    );
  }

}