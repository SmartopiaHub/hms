// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../api.dart';
import '../authenticator.dart';
import '../model/database.dart';
import '../notification.dart';
import 'base.dart';
import '../widgets/drawer_and_appbar.dart';
import '../widgets/task_detail.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

/// Page to display task details, allowing for viewing, editing, deleting, and submitting tasks.
/// If [task] is provided, it uses that directly, and show 'go back' button.
/// Otherwise, it fetches the task by [taskId] and displays it.
class TaskDetailPage extends StatefulWidget {
  final Task? task;
  final int? taskId;

  const TaskDetailPage({
    super.key,
    this.taskId,
    this.task,
  }) : assert(task != null || taskId != null, 'Either task or taskId must be provided');

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends PageBaseState<TaskDetailPage> {

  Task? _task;
  bool _isLoading = false;

  bool _changed = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _task = widget.task; // Use the provided task directly
    } else if (widget.taskId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final loc = AppLocalizations.of(context)!;
        setState(() {
          _isLoading = true;
        });
        final fetchedTask = await apiService.fetchTask(widget.taskId!);
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          if (fetchedTask == null) {
            showErrorNotification(loc.taskNotFound);
            return;
          }
          setState(() {
            _task = fetchedTask;
          });
        }
      });
    }
  }

  bool _canCancelTask(Task task) {
    final auth = context.read<AuthProvider>();
    final canSelfCancel = task.assignedUsers.contains(auth.username) && auth.allowSelfHomeworkManagement;
    if ((auth.isParent || canSelfCancel) && !task.isCompleted) {
      return true;
    }
    return false;
  }

  bool _canDeleteTask(Task task) {
    final auth = context.read<AuthProvider>();
    final canSelfDelete = task.assignedUsers.contains(auth.username) && auth.allowSelfHomeworkManagement;
    if ((auth.isParent || canSelfDelete) && !task.isStarted) {
      return true;
    }
    return false;
  }

  Widget _buildTaskDetail(){
    final auth = context.read<AuthProvider>();
    return TaskDetail(task: _task!, 
          onEdit: _task!.isCompleted ||  !auth.isParent ? null :  () {
            Navigator.pushNamed(context, '/task/edit', arguments: _task!.id);
          },
          onGoBack: () {
            if (_changed) {
              Navigator.pop(context, true); // Notify parent that task was changed
            } else {
              Navigator.pop(context); // Just go back
            }
          },
          onCancel: !_canCancelTask(_task!) ? null : () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(localizations.taskCancelTitle),
                content: Text(localizations.taskCancelConfirmation),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: Text(localizations.goBackButtonText)),
                  TextButton(onPressed: () => Navigator.pop(context, true), child: Text(localizations.confirm)),
                ],
              ),
            );
            if (confirm == true) {
              try {
                await apiService.cancelTask(taskId: _task!.id, templateId: _task!.templateId, startTime: _task!.startTime);
                if (mounted) GoRouter.of(context).pop(true); // Notify parent that task was cancelled
              } catch (e) {
                showErrorNotification(localizations.taskCancelError);
                return;
              }
            }
          },
          onDelete: !_canDeleteTask(_task!) ? null : () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(localizations.taskDelete),
                content: Text(localizations.taskDeleteConfirmation),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: Text(localizations.cancel)),
                  TextButton(onPressed: () => Navigator.pop(context, true), child: Text(localizations.delete)),
                ],
              ),
            );
            if (confirm == true) {
              try {
                await apiService.deleteTask(_task!.id);
                if (mounted) GoRouter.of(context).pop(true); // Notify parent that task was deleted
              } catch (e) {
                showErrorNotification(localizations.taskDeleteError);
                return;
              }
            }
          },
          onSubmit: _task!.isCompleted || auth.isParent ? null : () async{
            final changed = await GoRouter.of(context).pushNamed<bool>(
              'taskSubmit',
              extra: _task,
              pathParameters: {'id': _task!.id.toString()},
            );
            if (changed == true) {
              _task = await apiService.fetchTask(_task!.id); // Refresh task data
              setState(() {
                _changed = true;
              });
            }
          },
          onGrade: !auth.isParent || !_task!.isCompleted || _task!.isGraded ? null : () async{
            final graded = await GoRouter.of(context).pushNamed<bool>(
              'taskGrade',
              extra: _task,
              pathParameters: {'id': _task!.id.toString()},
            );
            if (graded == true) {
              _task = await apiService.fetchTask(_task!.id); // Refresh task data
              setState(() {
                _changed = true;
              });
            }
          },
        );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: !isWideScreen && !isMobile ? buildDrawer(context) : null,
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        if (!isWideScreen) buildAppBar(context, localizations.taskDetails, goBackButton: true),
        // ← give your scrollable area a bounded height
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _task == null
                  ? Center(child: Text(localizations.taskNotFound))
                  : _buildTaskDetail(),  // this contains its own SingleChildScrollView
        ),
        ],
      )
      
      
        
    );
  }
}