
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartopia_hms_client/api.dart';
import 'package:smartopia_hms_client/model/database.dart';
import 'package:smartopia_hms_client/pages/base.dart';
import 'package:smartopia_hms_client/widgets/task_item.dart';
import 'package:smartopia_hms_client/notification.dart';

class TaskReviewPage extends StatefulWidget {
  final List<TaskTemplate> initialTasks;

  const TaskReviewPage({super.key, required this.initialTasks});

  @override
  State<TaskReviewPage> createState() => _TaskReviewPageState();
}

class _TaskReviewPageState extends PageBaseState<TaskReviewPage> {
  late List<TaskTemplate> _tasks;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.initialTasks);
  }

  @override
  String get pageTitle => 'Review Tasks';

  @override
  bool get goBackButtonInAppBar => true;

  Future<void> _handleConfirm() async {
    setState(() {
      _isSaving = true;
    });

    try {
      int successCount = 0;
      for (final task in _tasks) {
        // Create new tasks. Ensure ID is 0 for creation.
        final taskToCreate = task.copyWith(id: 0);
        final success = await apiService.createTaskTemplate(taskToCreate);
        if (success) {
          successCount++;
        }
      }

      if (mounted) {
        showInfoNotification('Created $successCount tasks', context: context);
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        showErrorNotification('Error saving tasks: $e', context: context);
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
    if (_tasks.isEmpty) {
      return Center(child: Text('No tasks to review'));
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            return TaskTemplateItem(
              template: task,
              onEdit: () async {
                final updatedTask = await context.push<TaskTemplate>(
                  '/tasks/create', // Assuming this route maps to CreateOrEditTaskPage
                  extra: {'taskTemplate': task, 'returnOnSubmit': true}, 
                  // Note: implementation of router needs to support this map extra
                );
                
                // If router expects TaskTemplate object as extra directly, we might need a wrapper or handle map.
                // Existing router usage: extra: item (TaskTemplate)
                // I need to check router.dart to see how it handles extra for create/edit.
                
                if (updatedTask != null) {
                  setState(() {
                    _tasks[index] = updatedTask;
                  });
                }
              },
              onDelete: () {
                 setState(() {
                   _tasks.removeAt(index);
                 });
              },
            );
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
              child: _isSaving 
                ? const SizedBox(
                    height: 20, 
                    width: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2)
                  )
                : const Text('Confirm & Create All'),
            ),
          ),
        ),
      ],
    );
  }
}
