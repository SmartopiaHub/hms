// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:blurrycontainer/blurrycontainer.dart';
import '../authenticator.dart';
import '../notification.dart';
import '../pages/base.dart';
import '../themes/theme.dart';
import 'buttons.dart';
import 'duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smartopia_hms_shared/shared.dart';
import '../model/database.dart';
import '../config.dart';
import 'add_or_edit_chip.dart';
import 'recurrence_pattern.dart';
import 'package:smartopia_hms_shared/shared.dart' as shared;

import '../l10n/app_localizations.dart';
import 'number_field.dart';

typedef TaskTemplateSubmit = void Function(TaskTemplate template);
typedef ChildListFetchCallback = Future<List<String>> Function();

class TaskTemplateForm extends StatefulWidget {
  /// Called when the form is valid and the user taps Save.
  final TaskTemplateSubmit onSubmit;
  final ChildListFetchCallback fetchChildList;

  /// Initial values for editing; if null, the form starts blank.
  final TaskTemplate? initial;

  const TaskTemplateForm({
    super.key,
    required this.onSubmit,
    required this.fetchChildList,
    this.initial,
  });

  @override
  State<TaskTemplateForm> createState() => _TaskTemplateFormState();
}

class _TaskTemplateFormState extends PageBaseState<TaskTemplateForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _rewardCtrl;
  late final TextEditingController _penaltyCtrl;
  late final TextEditingController _maxPointsCtrl;
  List<String> _tags = [];
  late List<String> _assignedUsers;
  late RecurrencePattern _recurrence;
  late Duration _expectedCompletionTimeInMinutes;
  late Duration _remindDuration;
  //NotificationSetting? _notification;
  bool _attachmentRequired = false;
  bool _submissionRequired = true;
  List<String>? _childList;

  /*final _notificationEvents = {
    'assigned': <int>{},
    'started': <int>{},
    'overdue': <int>{},
    'completed': <int>{},
    'graded': <int>{},
  };

  final _notificationMethodCodes = const [
    NotificationSetting.EMAIL, 
    NotificationSetting.SMS,
    NotificationSetting.MQTT];

  String _getNotificationMethodLabel(int code) {
    final loc = AppLocalizations.of(context)!;
    switch (code) {
      case NotificationSetting.EMAIL:
        return loc.email;
      case NotificationSetting.SMS:
        return loc.sms;
      case NotificationSetting.MQTT:
        return loc.mqtt;
      default:
        return code.toString(); // Fallback to the code itself if no match found
    }
  }*/

  @override
  void initState() {
    super.initState();
    final init = widget.initial;
    _nameCtrl = TextEditingController(text: init?.title ?? '');
    _descCtrl = TextEditingController(text: init?.description ?? '');
    _rewardCtrl = TextEditingController(text: init?.rewards?.description ?? '');
    _penaltyCtrl = TextEditingController(text: init?.penalty ?? '');
    
    // Default to 0 points if point system is disabled, otherwise default to 5
    final configProvider = context.read<AppConfig>();
    final defaultPoints = configProvider.pointSystemEnabled ? '5' : '0';
    _maxPointsCtrl = TextEditingController(text: init?.rewards?.maxPoints?.toString() ?? defaultPoints);
    
    _tags = init?.tags?.toList() ?? [];
    _assignedUsers = init?.assignedUsers.toList() ?? [];
    
    final now = DateTime.now();
    final due = now.add(const Duration(hours: 1));
    _recurrence = init?.recurrence ??
        DailyPattern(startDateTime: now, dueDateTime: due, times: [shared.TimeOfDay(hour: now.hour, minute: now.minute)]);
    _expectedCompletionTimeInMinutes = init?.expectedCompletionTimeInMinutes ?? const Duration(minutes: 30);
    _remindDuration = init?.remind == null 
        ? const Duration(minutes: 0)
        : Duration(minutes: init!.remind);
    //_notification = init?.notificationSetting;
    _attachmentRequired = init?.attachmentRequired ?? false;

    /*final initNotif = widget.initial?.notificationSetting;
    if (initNotif != null) {
      _notificationEvents['assigned']   = initNotif.onAssigned?.toSet() ?? {};
      _notificationEvents['started']    = initNotif.onStarted?.toSet() ?? {};
      _notificationEvents['overdue']        = initNotif.onOverdue?.toSet() ?? {};
      _notificationEvents['completed']  = initNotif.onCompleted?.toSet() ?? {};
      _notificationEvents['graded']     = initNotif.onGraded?.toSet() ?? {};
    }*/

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final auth = context.read<AuthProvider>();
      if (!auth.isParent && auth.allowSelfHomeworkManagement) {
        // If user is not parent but can manage self, lock assigned users to self
        if (mounted) {
          setState(() {
            _childList = [auth.username!];
            _assignedUsers = [auth.username!];
          });
        }
      } else {
        final children = await widget.fetchChildList();
        if (mounted) {
          setState(() {
            _childList = children;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _rewardCtrl.dispose();
    _penaltyCtrl.dispose();
    _maxPointsCtrl.dispose();
    super.dispose();
  }

  bool _validateRecurrence() {
    if (_recurrence is DailyPattern) {
      if ((_recurrence as DailyPattern).times.isEmpty) {
        showErrorNotification(localizations.rpTimePointRequired, context: context);
        return false;
      }
    }
    return true;
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;
    if (!_validateRecurrence()) return;
    if (_expectedCompletionTimeInMinutes.inMinutes <= 0) {
      showErrorNotification(localizations.taskExpectedCompletionDurationRequired, context: context);
      return;
    }
    if (_assignedUsers.isEmpty) {
      showErrorNotification(localizations.taskAssignedUsersRequired, context: context);
      return;
    }

    final user = context.read<AuthProvider>().username;
    final template = TaskTemplate(
      id: widget.initial?.id ?? -1,
      title: _nameCtrl.text.trim(),
      creator: user!,
      assignedUsers: _assignedUsers,
      priority: 0,
      tags: _tags.isEmpty ? null : _tags,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      recurrence: _recurrence,
      rewards: RewardInfo(
        maxPoints: int.tryParse(_maxPointsCtrl.text.trim()),
        description: _rewardCtrl.text.trim().isEmpty ? null : _rewardCtrl.text.trim(),
      ),
      penalty: _penaltyCtrl.text.trim().isEmpty ? null : _penaltyCtrl.text.trim(),
      attachmentRequired: _attachmentRequired,
      creationTime: widget.initial?.creationTime ?? DateTime.now(),
      expectedCompletionTimeInMinutes: _expectedCompletionTimeInMinutes,
      remind: _remindDuration.inMinutes,
      notificationSetting: null, //notif,
      submissionRequired: _submissionRequired,
    );
    widget.onSubmit(template);
  }

  List<Widget> _buildTagChips(Locale locale) {
    final newChip = AddOrEditChip(
      label: null,
      locale: locale,
      onSubmitted: (s) {
        if (s.isEmpty || _tags.contains(s)) return;
        setState(() => _tags.add(s));
      },
      onDeleted: () {},
    );
    final chips = _tags.map((tag) {
      return AddOrEditChip(
        label: tag,
        locale: locale,
        onSubmitted: (s) {
          if (s.isEmpty || _tags.contains(s)) return;
          setState(() {
            _tags.remove(tag);
            _tags.add(s);
          });
        },
        onDeleted: () => setState(() => _tags.remove(tag)),
      );
    }).toList();
    chips.add(newChip);
    return chips;
  }

  Widget _scale(Widget child) {
    return Transform.scale(
      scale: 0.8,
      child: child,
    );
  }

  Widget _wrapWithCard(Widget child) {
    return BlurryContainer(
      elevation: 0,
      color: Colors.white.withAlpha(10),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }

  List<Widget> _constructFields(BuildContext context){
    final loc = AppLocalizations.of(context)!;
    final locale = context.watch<AppConfig>().locale;
    final appConfig = context.read<AppConfig>();
    final widgets = <Widget>[];
    widgets.add(TextFormField(
                controller: _nameCtrl,
                decoration: MyAppTheme.glassInputDecoration(labelText: loc.taskName),
                validator: (v) => v == null || v.isEmpty ? loc.signInRequireUsername : null,
              ));
    widgets.add(TextFormField(
                controller: _descCtrl,
                decoration: MyAppTheme.glassInputDecoration(labelText: loc.taskDescription),
                maxLines: 3,
              ));
    widgets.add(
          _wrapWithCard( Row(
               // crossAxisAlignment: WrapCrossAlignment.center,
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(loc.taskTags),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _buildTagChips(locale),
                      ),
                    ],
                  ),
                ],
              )));
    widgets.add(
      _wrapWithCard( Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(loc.taskAssignedUsers),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(width: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (_childList == null) 
                              const CircularProgressIndicator(),
                            if (_childList != null && _childList!.isEmpty) 
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: GestureDetector(
                                  onTap: () => go('/users/create'),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(loc.taskCreateChildAccountFirst),
                                  ),
                                ),
                              ),
                              if (_childList!=null) ..._childList!.map((child) {
                              if (_childList!.length == 1 && _assignedUsers.isEmpty) {
                                // If there's only one child and no assigned users, auto-select it
                                _assignedUsers.add(child);
                              }
                              final isSelected = _assignedUsers.contains(child);
                              return FilterChip(
                                label: Text(child),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _assignedUsers.add(child);
                                    } else {
                                      _assignedUsers.remove(child);
                                    }
                                  });
                                },
                              );
                            }),
                          ]),
                      ]
                    ),
                  ],
                ),)
    );
    widgets.add(
      _wrapWithCard(
        RecurrencePatternPicker(
                  initialPattern: _recurrence,
                  onChanged: (p) => setState(() => _recurrence = p),
                  locale: locale,
                )
      )
    );
    widgets.add(
      _wrapWithCard( DurationPicker(
                initialValue: _expectedCompletionTimeInMinutes,
                onChanged: (d) => setState(() => _expectedCompletionTimeInMinutes = d),
                label: loc.taskExpectedCompletionDuration,
                locale: locale,
              ))
    );

    widgets.add(
      _wrapWithCard(
        Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(loc.taskAttachmentRequired),
                  _scale(Switch(
                    value: _attachmentRequired,
                    onChanged: (v) => setState(() => _attachmentRequired = v),
                    
                  ),),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(loc.taskSubmitRequired),
                  _scale(Switch(
                    value: _submissionRequired,
                    onChanged: (v) => setState(() => _submissionRequired = v),
                  ),),
                ],
              )
                 
          ],
        )
      )
    );
    
    widgets.add(
      _wrapWithCard(
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (appConfig.pointSystemEnabled) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(loc.taskMaxPoints),
                    Container(
                      constraints: BoxConstraints(maxWidth: 200),
                      child: _scale( NumberField( 
                          controller: _maxPointsCtrl,
                          //label: loc.taskMaxPoints,
                          min: 0,
                          max: 1000,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _rewardCtrl,
                      decoration: MyAppTheme.glassInputDecoration(labelText: appConfig.pointSystemEnabled ? loc.taskOtherReward : loc.taskReward),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _penaltyCtrl,
                decoration: MyAppTheme.glassInputDecoration(labelText: loc.taskPenalty),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
      )
    );
    
    widgets.add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  buildGoBackButton(context),
                  buildElevatedButton(context: context, 
                    icon: Icons.save,
                    label: widget.initial?.id != null ? loc.taskUpdate : loc.taskCreate,
                    onPressed: _handleSave,
                  ),
                ],
              ));

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final fields = _constructFields(context);
    return Form(
      key: _formKey,
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: fields.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (ctx, i) {
          return fields[i];
        },
      ),
    );
  }
}