// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import '../api.dart';
import '../notification.dart';
import 'base.dart';
import '../widgets/task_template_form.dart';
import 'package:flutter/material.dart';
import '../model/database.dart';
import 'package:go_router/go_router.dart';

class CreateOrEditTaskPage extends StatefulWidget {
  final int? taskId;
  final TaskTemplate? taskTemplate;
  final bool returnOnSubmit;
  final bool fromReview;
  const CreateOrEditTaskPage({
    super.key,
    this.taskId,
    this.taskTemplate,
    this.returnOnSubmit = false,
    this.fromReview = false,
  });

  @override
  State<CreateOrEditTaskPage> createState() => _CreateOrEditTaskPageState();
}

class _CreateOrEditTaskPageState extends PageBaseState<CreateOrEditTaskPage> {
  bool get isUpdate =>
      widget.taskTemplate != null &&
      widget.taskTemplate!.id >= 0 &&
      !widget.fromReview;

  @override
  String get pageTitle {
    return isUpdate ? localizations.taskEdit : localizations.createTask;
  }

  @override
  bool get goBackButtonInAppBar => true;

  @override
  Widget buildContent(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: TaskTemplateForm(
          initial: widget.taskTemplate,
          fetchChildList: () => apiService.getChildList(),
          onSubmit: (template) async {
            if (widget.returnOnSubmit) {
              GoRouter.of(context).pop(template);
              return;
            }
            try {
              if (template.id >= 0) {
                await apiService.updateTaskTemplate(template);
              } else {
                await apiService.createTaskTemplate(template);
              }
              if (context.mounted) {
                showInfoNotification(
                  isUpdate
                      ? localizations.taskUpdated
                      : localizations.taskCreated,
                  context: context,
                );

                Future.delayed(const Duration(seconds: 2), () {
                  if (context.mounted) {
                    // Return true to indicate successful creation when from review
                    GoRouter.of(context).pop(widget.fromReview ? true : null);
                  }
                });
              }
            } catch (e) {
              if (context.mounted) {
                showErrorNotification(
                  isUpdate
                      ? localizations.taskUpdateError
                      : localizations.taskCreateError,
                  context: context,
                );
              }
            }
          },
        ),
      ),
    );
  }
}
