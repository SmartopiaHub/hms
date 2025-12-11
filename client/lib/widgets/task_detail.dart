// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../api.dart';
import '../config.dart';
import '../notification.dart';
import '../pages/base.dart';
import '../themes/theme.dart';
import 'buttons.dart';
import 'card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:go_router/go_router.dart';
import '../model/database.dart';
import '../widgets/point_badge.dart';
import 'package:provider/provider.dart';
import '../authenticator.dart';
import 'package:universal_html/html.dart' as html;

/// Displays all fields of a [Task] in cards, plus action buttons:
///  - delete & edit (parent)
///  - submit (child & not submitted)
///  - grade (parent & submitted)
///  - unsubmit (parent)
class TaskDetail extends StatefulWidget {
  final Task task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSubmit;
  final VoidCallback? onGrade;
  final VoidCallback? onUnsubmit;
  final VoidCallback? onGoBack;
  final VoidCallback? onCancel;

  final bool includeCompletionTime;
  final bool includeStartTime;
  final bool includeDuetime;
  final bool includeDescription;
  final bool includeReward;
  final bool includePenalty;
  final bool includeSubmittedFiles;
  final bool includeEvaluator;
  final bool includeEvaluationTime;
  final bool includeAssignedUsers;


  const TaskDetail({
    super.key,
    required this.task,
    this.onEdit,
    this.onDelete,
    this.onSubmit,
    this.onGrade,
    this.onUnsubmit,
    this.onGoBack,
    this.onCancel,

    this.includeCompletionTime = true,
    this.includeStartTime = true,
    this.includeDuetime = true,
    this.includeDescription = true,
    this.includeReward = true,
    this.includePenalty = true,
    this.includeSubmittedFiles = true,
    this.includeEvaluator = true,
    this.includeEvaluationTime = true,
    this.includeAssignedUsers = true,
    
  });

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends PageBaseState<TaskDetail> {

  final Map<String, String> _downloadedFiles = {};

  Task get task => widget.task;

  @override
  void initState() {
    super.initState();
      final files = task.submittedFiles;
      if (files != null && files.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _downloadFiles(files);
        });
      }
  }

  Future<void> _downloadFiles(List<String> filenames) async {
    for (var filename in filenames) {
      final path = await apiService.downloadFile(
        widget.task.id,
        filename,
      );
      if (path != null) {
        setState(() {
          _downloadedFiles[filename] = path;
        });
      } else {
        showErrorNotification('Failed to download file: $filename');
      }
    }
  }

  Widget _buildButtons(BuildContext context) {
    final canGoBack = GoRouter.of(context).canPop();
    final loc = AppLocalizations.of(context)!;
    final actions = <Widget>[];
      if (widget.onEdit != null && !task.cancelled) {
        actions.add(buildElevatedButton(
          context: context,
          onPressed: widget.onEdit,
          icon: Icons.edit,
          label: loc.edit,
        ));
      }
      if (widget.onDelete != null) {
        actions.add(buildElevatedButton(
          context: context,
          onPressed: widget.onDelete,
          icon: Icons.delete,
          label: loc.delete,
        ));
      }
      if (widget.onCancel != null && !task.cancelled) {
        actions.add(buildElevatedButton(
          context: context,
          onPressed: widget.onCancel,
          icon: Icons.cancel,
          label: loc.taskCancelTitle,
        ));
      }
      if (widget.onGrade != null) {
        actions.add(buildElevatedButton(
          context: context,
          onPressed: widget.onGrade,
          icon: Icons.grade,
          label: loc.grade,
        ));
      }
      if (widget.onUnsubmit != null) {
        actions.add(buildElevatedButton(
          context: context,
          onPressed: widget.onUnsubmit,
          icon: Icons.undo,
          label: loc.unsubmit,
        ));
      }
    
      // child user
      if (widget.onSubmit != null) {
        actions.add(buildElevatedButton(
          context: context,
          onPressed: widget.onSubmit,
          icon: Icons.upload_file,
          label: loc.submit,
        ));
      }

    if (actions.isEmpty && !canGoBack) {
      return const SizedBox.shrink(); // No actions to display
    }

    final goBackButton = canGoBack && widget.onGoBack != null ?
        buildGoBackButton(context,
            onPressed: () => widget.onGoBack!= null ? widget.onGoBack!() : GoRouter.of(context).pop(),
          )
        : null;

    // responsive button layout
    final isNarrow = MediaQuery.of(context).size.width < 550;
    final buttonArea = isNarrow
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[ ...actions
                .map((b) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: b,
                    )),
                if (goBackButton != null) goBackButton,
            ],
          )
        : canGoBack ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              if (goBackButton != null) goBackButton,
              if (actions.isNotEmpty) Expanded(child: SizedBox(width: 10,),),
              if (actions.isNotEmpty) Row(
                spacing: 8,
                children: actions,)
              
            ],
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: actions,
          );
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
      child: buttonArea,
    );
  }

  Widget _buildCard(BuildContext context, String label, {String? value, Widget? valueWidget}) {
    final theme = Theme.of(context);
    value ??= '';
    if (value.isEmpty) {
      if (valueWidget == null) {
        return const SizedBox.shrink(); // No value or widget to display
      }
    }
    return buildCard(
      context,
        padding: const EdgeInsets.all(16.0),
      child: 
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.taskCardBody),
            valueWidget ?? Text(value, style: theme.textTheme.taskCardBody),
        ],)
    );
  }

  String _formatDateTime(DateTime dt) {
    final y = dt.year;
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $h:$min';
}


  Widget _buildSubmittedFile(BuildContext context, String file) {
    return InkWell(
      onTap: !_downloadedFiles.containsKey(file) ? null : () async{
        final url = _downloadedFiles[file];
        if (kIsWeb) {
          
          final anchor = html.AnchorElement(href: url.toString())
            ..setAttribute('download', file)
            ..style.display = 'none';
          html.document.body!.append(anchor);
          anchor.click();
          anchor.remove();
        } else {
          showErrorNotification(
            'File download is not supported on this platform.',
            context: context,
          );

          // mobile: open in external browser which will download or display
          /*if (await canLaunchUrl(url)) {
            await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Cannot launch download URL')),
            );
          }*/
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.insert_drive_file, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                file,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            _downloadedFiles.containsKey(file) ? Icon(Icons.download, size: 20) : CircularProgressIndicator()
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final auth = context.read<AuthProvider>();
    final appConfig = context.read<AppConfig>();
    
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 550), 
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          //padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            SizedBox(height: 18),
            Center(
              child: Text(
                task.title,
                style: theme.textTheme.taskCardTitle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            if(task.description!=null && widget.includeDescription) Center(
              child: Text(
                task.description!,
                style: theme.textTheme.taskCardBody,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            _buildCard(
                context,
                loc.taskAssignedTo,
                value: task.assignedUsers.join(', ')),
            if (widget.includeStartTime) SizedBox(height: 8),
            if (widget.includeStartTime) _buildCard(
                context,
                loc.taskStartAt,
                value: _formatDateTime(task.startTime)),
            if (widget.includeDuetime) SizedBox(height: 8),
            if (widget.includeDuetime) _buildCard(
                context,
                loc.taskDueAt,
                value: _formatDateTime(task.dueTime)),
            if (task.completionTime != null && widget.includeCompletionTime) SizedBox(height: 8),
            if (task.completionTime != null && widget.includeCompletionTime)
              _buildCard(context, loc.taskCompletedAt,
                  value: _formatDateTime(task.completionTime!)),
            if (task.rewards?.pointsAwarded != null)
              SizedBox(height: 8),
            if (task.rewards?.pointsAwarded != null)
              _buildCard(context, loc.taskRating, 
                  valueWidget:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 100,
                        child: StarRating(
                            rating: (task.rewards!.maxPoints != null && task.rewards!.maxPoints! > 0)
                                ? (task.rewards!.pointsAwarded! / task.rewards!.maxPoints! * 5)
                                : 0.0,
                            size: 20,
                            color: Colors.amber,
                          )
                      ),
                      
                    ],
                  ),
                  
              ),
            if (widget.includeReward && task.rewards?.description != null) SizedBox(height: 8),
            if (widget.includeReward && task.rewards?.description != null)
              _buildCard(context, loc.taskReward, value: task.rewards!.description),
            if (appConfig.pointSystemEnabled && widget.includeReward && task.rewards?.maxPoints != null) SizedBox(height: 8),
            if (appConfig.pointSystemEnabled && widget.includeReward && task.rewards?.maxPoints != null)
              _buildCard(
                context, task.isGraded ? loc.taskReward : loc.taskMaxPoints, 
                value: task.rewards!.maxPoints.toString(),
                valueWidget: PointBadge(
                  points: task.isGraded ? task.rewards!.pointsAwarded! : task.rewards!.maxPoints!,
                  maxPoints: task.rewards!.maxPoints,
                  pointSystemId: auth.pointSystemId,
                  iconSize: 14,
                  fontSize: 12,
                  //color: Colors.amber[800],
                ),
              ),
            if (widget.includePenalty && task.penalty != null) SizedBox(height: 8),
            if (widget.includePenalty && task.penalty != null)
              _buildCard(context, loc.taskPenalty, value: task.penalty),
            if (task.evaluationTime != null && widget.includeEvaluationTime)
              SizedBox(height: 8),
            if (task.evaluationTime != null && widget.includeEvaluationTime)
              _buildCard(context, loc.taskGradedAt,
                  value: _formatDateTime(task.evaluationTime!)),
            if (task.evaluator != null && widget.includeEvaluator) SizedBox(height: 8),
            if (task.evaluator != null && widget.includeEvaluator)
              _buildCard(context, loc.taskGradedBy, value: task.evaluator),
            if (task.submittedFiles != null && task.submittedFiles!.isNotEmpty && widget.includeSubmittedFiles) SizedBox(height: 8),
            if (task.submittedFiles != null && task.submittedFiles!.isNotEmpty && widget.includeSubmittedFiles)
              buildCard(
               context,
               child: ExpansionTile(
                    title: Text(loc.taskSubmittedFiles, style: theme.textTheme.taskCardBody),
                    children: task.submittedFiles!
                        .map((f) => 
                          _buildSubmittedFile(context, f))
                        .toList(),
                  ),),
            if (task.submittedFiles != null && task.submittedFiles!.isNotEmpty && widget.includeSubmittedFiles) SizedBox(height: 8),
            const SizedBox(height: 12),
            _buildButtons(context),
            const SizedBox(height: 24),
          ],
        )
      ),
      ),
    );
  }
}