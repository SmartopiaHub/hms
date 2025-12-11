// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.


import '../api.dart';
import '../model/database.dart';
import '../notification.dart';
import 'base.dart';
import '../themes/theme.dart';
import '../widgets/buttons.dart';
import '../widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../l10n/app_localizations.dart';

class TaskSubmissionPage extends StatefulWidget {
  final int? taskId;
  final Task? task;

  const TaskSubmissionPage({super.key, this.taskId, this.task}): 
    assert(taskId != null || task != null, 'Either taskId or task must be provided.');

  @override
  PageBaseState<TaskSubmissionPage> createState() => _TaskSubmissionPageState();
}

class _TaskSubmissionPageState extends PageBaseState<TaskSubmissionPage> {
  final Set<PlatformFile> _selectedFiles = {};
  bool _isSubmitting = false;

  Task? _task;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _task = widget.task;
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


  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      for (var f in result.files) {
        if (f.size > 5 * 1024 * 1024) {
          if (mounted){
            showErrorNotification(localizations.taskAttachmentExceedsLimit(5), context: context);
          }
          continue;
        }
        _selectedFiles.add(f);
      }
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (_task!.attachmentRequired && _selectedFiles.isEmpty) {
      showErrorNotification(localizations.taskAttachmentRequired);
      return;
    }

    
    setState(() {
      _isSubmitting = true;
    });

    try{
      await apiService.submitTask(
        widget.taskId ?? widget.task!.id,
        _selectedFiles.toList(),
      );
      setState(() {
        _isSubmitting = false;
      });
      if (mounted) {
        showInfoNotification(localizations.taskSubmitSuccess);
      }
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop<bool>(context, true);
        }
      });
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      if (mounted) {
        showErrorNotification(localizations.taskSubmitError, context: context);
      }
      return;
    }
  }

  Widget _buildFileList() {
    if (_selectedFiles.isEmpty) {
      //return const Center(child: Text('No files selected.'));
      return SizedBox.shrink();
    }
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _selectedFiles.map((file) {
        return buildCard(
          context,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: 
            Material(
              color: Colors.transparent,
              child: ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: Text(file.name, style: theme.textTheme.taskCardBody),
              subtitle: Text('${(file.size / 1024).toStringAsFixed(2)} KB'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _selectedFiles.remove(file);
                  });
                },
              ),
            )
            )
        );
      }).toList(),
    );
    
  }


  Widget _buildContent(Task task) {
    if (task.isCompleted) {
      return Center(child: Text(localizations.taskAlreadySubmitted));
    }
    return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16, width: double.infinity,),
            Text(task.title, style: theme.textTheme.taskCardTitle),
            SizedBox(height: 16, width: double.infinity,),
            FilledButton.icon(
              icon: const Icon(Icons.attach_file),
              label: Text(task.attachmentRequired ? localizations.selectFilesRequired : localizations.selectFilesOptional),
              onPressed: _pickFiles,
            ),
            const SizedBox(height: 16),
            ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600),
              child: _buildFileList(),
            ),
            
            
            const SizedBox(height: 16),
            //Expanded(child: SizedBox.expand()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                buildGoBackButton(context),
                buildElevatedButton(
                  context: context,
                  label: localizations.submit,
                  onPressed: _isSubmitting ? null : _submit,
                  icon: Icons.upload_file,
                  child: _isSubmitting
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(localizations.submit),
              
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 36),
              
            ),
          ],
        );
  }

  @override
  String get pageTitle => localizations.taskSubmitTitle;

  @override
  bool get goBackButtonInAppBar => true;

  @override
  Widget buildContent(BuildContext context) {
    return _isLoading || _task == null ? CircularProgressIndicator() :  _buildContent(_task!);
  }
}
