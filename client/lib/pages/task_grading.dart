// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:provider/provider.dart';
import '../authenticator.dart';

import '../api.dart';
import '../model/database.dart';
import '../notification.dart';
import 'base.dart';
import '../widgets/buttons.dart';
import '../widgets/point_badge.dart';
import '../widgets/task_detail.dart';
import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';

class TaskGradingPage extends StatefulWidget {
  const TaskGradingPage({
    super.key,
    this.taskId,
    this.task,
  }) : assert(taskId != null || task != null, 'Either taskId or task must be provided.');

  final int? taskId;
  final Task? task;
  

  @override
  State<TaskGradingPage> createState() => _TaskGradingPageState();
}

class _TaskGradingPageState extends PageBaseState<TaskGradingPage> {
  int _selectedStars = 0;

  Task? _task;


  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _task = widget.task!;
    } else if (widget.taskId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Replace this with your actual fetch logic
        final fetchedTask = await apiService.fetchTask(widget.taskId!);
        if (fetchedTask == null) {
          showErrorNotification('Task with ID ${widget.taskId} not found.');
          return;
        }
        if (mounted) {
          setState(() {
            _task = fetchedTask;
          });
        }
      });
    } else {
      throw ArgumentError('Either taskId or task must be provided.');
    }
  }



  void _onStarTap(int index) {
    setState(() {
      _selectedStars = index + 1;
    });
  }

  Future<void> _submitGrade() async {
    final graded = await apiService.gradeTask(
      widget.taskId ?? widget.task!.id,
      _selectedStars,
    );

    if (graded) {
      showInfoNotification('Task graded successfully.');
      if (mounted) Navigator.of(context).pop<bool>(true);
    } else {
      showErrorNotification('Failed to grade task.');
    }
  }

  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        index < _selectedStars ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 40,
      ),
      onPressed: () => _onStarTap(index),
    );
  }



  void _onSubmit() async {
    if (_selectedStars == 0) {
      final yes = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          //title: Text(AppLocalizations.of(context)!.warning),
          content: Text(localizations.taskAreYouSureToGiveZeroStar),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
                
              },
              child: Text(localizations.confirm),
            ),
          ],
        ),
      );
      if (yes==true) await _submitGrade();
    }
    else{
      await _submitGrade();
    }
  }

  Widget _buildContent(BuildContext context) {
    if (_task == null) {
      return const Center(child: CircularProgressIndicator());
    }


    return SingleChildScrollView( child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TaskDetail(task: _task!,
          includeEvaluationTime: false,
          includeEvaluator: false,
          includeReward: false,
          includePenalty: false,
          includeAssignedUsers: false,
        ),
        const SizedBox(height: 26),

        Text(
              localizations.taskHowWouldYouRate,
              style: TextStyle(fontSize: 18),
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) => _buildStar(index)),
        ),
        if (_task?.rewards?.maxPoints != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PointBadge(
                  pointSystemId: context.read<AuthProvider>().pointSystemId,
                  points: (_task!.rewards!.maxPoints! * (_selectedStars / 5)).round(),
                  iconSize: 20,
                  fontSize: 18,
                  color: Colors.amber[800],
                ),
                Text(
                  ' / ${_task!.rewards!.maxPoints}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber[800]),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Row(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildGoBackButton(context),
            buildElevatedButton(
              icon: Icons.check,
              context: context,
              onPressed: _onSubmit,
              label: localizations.submit,
            ),
          ],
        )
        
      ],
    ),
    );
  }

  @override
  String get pageTitle => localizations.taskRating;

  @override
  bool get goBackButtonInAppBar => true;

  @override
  Widget buildContent(BuildContext context) {
    return _buildContent(context);
  }

}