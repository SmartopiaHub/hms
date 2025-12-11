// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:smartopia_hms_shared/shared.dart';
import 'package:smartopia_hms_shared/shared.dart' as shared;

typedef RecurrenceChanged = void Function(RecurrencePattern pattern);

const String enUS = '''
{
  "monday": "Mon",
  "tuesday": "Tue",
  "wednesday": "Wed",
  "thursday": "Thu",
  "friday": "Fri",
  "saturday": "Sat",
  "sunday": "Sun",
  "hourly": "Hourly",
  "daily": "Daily",
  "weekly": "Weekly",
  "monthly": "Monthly",
  "yearly": "Yearly",
  "once": "Once",
  "time": "Time",
  "recurrence": "Recurrence",
  "firstInstance": "First Occurrence",
  "lastDayOfMonth": "Last Day of Month",
  "startDate": "Start Date",
  "endDate": "End Date",
  "date": "Date",
  "startDateTime": "Start",
  "timeAlreadySelected": "Time already selected",
  "dueDateTime": "Due",
  "stopRecurrenceAfter": "Stop After"
}
''';

const String zhCN = '''
{
  "monday": "周一",
  "tuesday": "周二",
  "wednesday": "周三",
  "thursday": "周四",
  "friday": "周五",
  "saturday": "周六",
  "sunday": "周日",
  "hourly": "每小时",
  "daily": "每天",
  "weekly": "每周",
  "monthly": "每月",
  "yearly": "每年",
  "once": "单次",
  "time": "时间",
  "recurrence": "重复",
  "firstInstance": "首次",
  "lastDayOfMonth": "每月最后一天",
  "startDate": "开始日期",
  "endDate": "结束日期",
  "date": "日期",
  "startDateTime": "开始时间",
  "timeAlreadySelected": "该时间点已存在",
  "dueDateTime": "截止时间",
  "stopRecurrenceAfter": "重复结束于"
}
''';

class RecurrencePatternLabels {

  RecurrencePatternLabels({Locale? locale}) {
    locale ??= WidgetsBinding.instance.platformDispatcher.locale;
    _labels = _load(locale);
  }

  static Map<String, String> _load(Locale locale) {
    final String lang = locale.languageCode;

    var decoded = json.decode(enUS) as Map<String, dynamic>;
    if (lang == 'zh') {
      decoded = json.decode(zhCN) as Map<String, dynamic>;
    }
    return Map<String, String>.from(decoded);
  }

  late Map<String, String> _labels;


  String _getLabel(String key) {
    return _labels[key] ?? key;
  }

  String _getRecurrenceTypeLabel(RecurrencePatternType type) => _getLabel(type.name);
  
  String get monday => _getLabel('monday');
  String get tuesday => _getLabel('tuesday');
  String get wednesday => _getLabel('wednesday');
  String get thursday => _getLabel('thursday');
  String get friday => _getLabel('friday');
  String get saturday => _getLabel('saturday');
  String get sunday => _getLabel('sunday');
  String get hourly => _getLabel('hourly');
  String get daily => _getLabel('daily');
  String get weekly => _getLabel('weekly');
  String get monthly => _getLabel('monthly');
  String get yearly => _getLabel('yearly');
  String get once => _getLabel('once');
  String get time => _getLabel('time');
  String get recurrence => _getLabel('recurrence');
  String get firstInstance => _getLabel('firstInstance');
  String get lastDayOfMonth => _getLabel('lastDayOfMonth');
  String get startDate => _getLabel('startDate');
  String get endDate => _getLabel('endDate');
  String get date => _getLabel('date');
  String get startDateTime => _getLabel('startDateTime');
  String get dueDateTime => _getLabel('dueDateTime');
  String get stopRecurrenceAfter => _getLabel('stopRecurrenceAfter');
  String get timeAlreadySelected => _getLabel('timeAlreadySelected');

}

class RecurrencePatternPicker extends StatefulWidget {
  final RecurrencePattern initialPattern;
  final RecurrenceChanged onChanged;
  final bool isSmallScreen;
  final Locale locale;

  const RecurrencePatternPicker({
    super.key,
    required this.initialPattern,
    required this.onChanged,
    this.isSmallScreen = true,
    this.locale = const Locale('en', 'US'),
  });

  @override
  State<RecurrencePatternPicker> createState() =>
      _RecurrencePatternPickerState();
}

class _RecurrencePatternPickerState extends State<RecurrencePatternPicker> {

  // current recurrence pattern selected
  //late RecurrencePattern _selectedRecurrencePattern;

  //RecurrencePatternType get _recurrenceType => _selectedRecurrencePattern.type;

  //material.TimeOfDay _time = material.TimeOfDay( hour: 0, minute: 0);

  // cache for recurrence patterns, to avoid re-inputing information
  //final Map<RecurrencePatternType, RecurrencePattern> _recurrencePatternsCache = {};


  final List<int> _selectedWeekdays = []; // for Weekly pattern
  final List<int> _selectedDaysOfMonth = []; // for Monthly pattern
  final List<int> _selectedMinutes = []; // for Hourly pattern
  //final List<material.TimeOfDay> _selectedTimesOfDay = []; // for Daily, Weekly, Monthly, Yearly patterns
  final List<MonthDay> _selectedDates = []; // for yearly patterns
  late DateTime _startDateTime; 
  DateTime? _dueDateTime; 
  DateTime? _stopRecurrenceAfter;
  late RecurrencePatternLabels _labels;
  late RecurrencePatternType _recurrenceType;

  List<shared.TimeOfDay> constructTimesOfDay(){
    return [shared.TimeOfDay(hour: _startDateTime.hour, minute: _startDateTime.minute)];
  }

  RecurrencePattern constructRecurrencePattern() {
    switch (_recurrenceType) {
      case RecurrencePatternType.once:
        return OncePattern(startDateTime: _startDateTime, dueDateTime: _dueDateTime);
      case RecurrencePatternType.hourly:
        if (_selectedMinutes.isEmpty) {
          throw Exception('Hourly recurrence must have at least one minute selected');
        }
        return HourlyPattern(startDateTime: _startDateTime, minutes: _selectedMinutes, stopRecurrenceAfter: _stopRecurrenceAfter);
      case RecurrencePatternType.daily:
        return DailyPattern(startDateTime: _startDateTime, dueDateTime: _dueDateTime, stopRecurrenceAfter: _stopRecurrenceAfter, times: constructTimesOfDay());
      case RecurrencePatternType.weekly:
        if (_selectedWeekdays.isEmpty) {
          throw Exception('Weekly recurrence must have at least one weekday selected');
        }
        return WeeklyPattern(startDateTime: _startDateTime, dueDateTime: _dueDateTime, stopRecurrenceAfter: _stopRecurrenceAfter, weekdays: _selectedWeekdays, times: constructTimesOfDay());
      case RecurrencePatternType.monthly:
        if (_selectedDaysOfMonth.isEmpty) {
          throw Exception('Monthly recurrence must have at least one day of month selected');
        }
        return MonthlyPattern(startDateTime: _startDateTime, dueDateTime: _dueDateTime, stopRecurrenceAfter: _stopRecurrenceAfter, daysOfMonth: _selectedDaysOfMonth, times: constructTimesOfDay());
      case RecurrencePatternType.yearly:
        if (_selectedDates.isEmpty) {
          throw Exception('Yearly recurrence must have at least one month-day selected');
        }
        return YearlyPattern(startDateTime: _startDateTime, dueDateTime: _dueDateTime, stopRecurrenceAfter: _stopRecurrenceAfter, monthDays: _selectedDates, times: constructTimesOfDay());
      default:
        throw Exception('Unknown recurrence pattern type');
    }
    
  }

  @override
  void initState() {
    super.initState();
    _labels = RecurrencePatternLabels(locale: widget.locale);

    var p = widget.initialPattern;
    _recurrenceType = p.type;
    _dueDateTime = p.dueDateTime;
    _stopRecurrenceAfter = p.stopRecurrenceAfter;
    _startDateTime = p.startDateTime;

    if (p is HourlyPattern) {
      _selectedMinutes
        ..clear()
        ..addAll(p.minutes);
    } 
    else if (p is WeeklyPattern) {
      _selectedWeekdays
        ..clear()
        ..addAll(p.weekdays);
    } 
    else if (p is MonthlyPattern){
      _selectedDaysOfMonth
        ..clear()
        ..addAll(p.daysOfMonth);
    } 
    else if (p is YearlyPattern) {
      _selectedDates
        ..clear()
        ..addAll(p.monthDays);
    } 
  }

  @override
  void didUpdateWidget(covariant RecurrencePatternPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if the incoming locale prop has changed, re-load the labels
    if (oldWidget.locale != widget.locale) {
      setState(() {
        _labels = RecurrencePatternLabels(locale: widget.locale);
      });
    }
  }



  Widget _buildRecurrenceOption(BuildContext context) {

    Widget buildType(RecurrencePatternType type) {
      return 
      Expanded( child:
        RadioListTile<RecurrencePatternType>(
          title: Text(_labels._getRecurrenceTypeLabel(type)),
          value: type,
          groupValue: _recurrenceType,
          onChanged: (v) {
            setState(() {
              _recurrenceType = v!;
            });
            widget.onChanged(constructRecurrencePattern());
          },
        )
      );
    }

    if (widget.isSmallScreen){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_labels.recurrence),
          SizedBox(width: 10),
          Transform.scale(
            scale: 0.8,
            child:
          DropdownMenu(dropdownMenuEntries: [
            DropdownMenuEntry<RecurrencePatternType>(
              label: _labels._getRecurrenceTypeLabel(RecurrencePatternType.once),
              value: RecurrencePatternType.once,
            ),
            DropdownMenuEntry<RecurrencePatternType>(
              label: _labels._getRecurrenceTypeLabel(RecurrencePatternType.hourly),
              value: RecurrencePatternType.hourly,
            ),
            DropdownMenuEntry<RecurrencePatternType>(
              label: _labels._getRecurrenceTypeLabel(RecurrencePatternType.daily),
              value: RecurrencePatternType.daily,
            ),
            DropdownMenuEntry<RecurrencePatternType>(
              label: _labels._getRecurrenceTypeLabel(RecurrencePatternType.weekly),
              value: RecurrencePatternType.weekly,
            ),
            DropdownMenuEntry<RecurrencePatternType>(
              label: _labels._getRecurrenceTypeLabel(RecurrencePatternType.monthly),
              value: RecurrencePatternType.monthly,
            ),
            DropdownMenuEntry<RecurrencePatternType>(
              label: _labels._getRecurrenceTypeLabel(RecurrencePatternType.yearly),
              value: RecurrencePatternType.yearly,
            )
            ], 
            initialSelection: _recurrenceType,
            onSelected: (RecurrencePatternType? v) {
              setState(() {
                if (v != null) {
                  _recurrenceType = v;
                  if (v == RecurrencePatternType.hourly && _selectedMinutes.isEmpty) {
                    _selectedMinutes.add(_startDateTime.minute); // default to 0 minute if none selected
                  //} else if (v == RecurrencePatternType.daily && _startDateTime.hour == 0 && _startDateTime.minute == 0) {
                  //  _startDateTime = DateTime(_startDateTime.year, _startDateTime.month, _startDateTime.day, 0, 0);
                  }else if (v == RecurrencePatternType.weekly && _selectedWeekdays.isEmpty) {
                    _selectedWeekdays.addAll([_startDateTime.weekday]);
                  } else if (v == RecurrencePatternType.monthly && _selectedDaysOfMonth.isEmpty) {
                    _selectedDaysOfMonth.add(_startDateTime.day);
                  } else if (v == RecurrencePatternType.yearly && _selectedDates.isEmpty) {
                    _selectedDates.add(MonthDay(month: _startDateTime.month, day: _startDateTime.day));

                  }
                }
              });
              widget.onChanged(constructRecurrencePattern());
            },
            
          ))
        ]
      );
    } else {
      return Row(
        children: [
          buildType(RecurrencePatternType.once),
          buildType(RecurrencePatternType.hourly),
          buildType(RecurrencePatternType.daily),
          buildType(RecurrencePatternType.weekly),
          buildType(RecurrencePatternType.monthly),
          buildType(RecurrencePatternType.yearly),
        ]
      );
    }
  }

  Widget _buildMonthlyPattern(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: List<int>.generate(32, (index) => index + 1).map((day) {
        return Padding(padding: EdgeInsets.symmetric(vertical: 5),
          child:  ChoiceChip(
            label: Text(day == MonthlyPattern.lastDayOfMonth ? _labels.lastDayOfMonth : day.toString()),
            selected: _selectedDaysOfMonth.contains(day),
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _selectedDaysOfMonth.add(day);
                } else {
                  _selectedDaysOfMonth.remove(day);
                }
              });
              widget.onChanged(constructRecurrencePattern());
            },
          )
        );
      }).toList(),
    );
  }

  Widget _buildWeeklyPattern(BuildContext context) {
    final weekdays = <int, String>{
      DateTime.monday: _labels.monday,
      DateTime.tuesday: _labels.tuesday,
      DateTime.wednesday: _labels.wednesday,
      DateTime.thursday: _labels.thursday,
      DateTime.friday: _labels.friday,
      DateTime.saturday: _labels.saturday,
      DateTime.sunday: _labels.sunday,
    };
    return Wrap(
            spacing: 8,
            children: weekdays.entries.map((e) {
              final day = e.key;
              return Padding(padding: EdgeInsets.symmetric(vertical: 5) , child: ChoiceChip(
                label: Text(e.value),
                selected: _selectedWeekdays.contains(day),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedWeekdays.add(day);
                    } else {
                      _selectedWeekdays.remove(day);
                    }
                  });
                  widget.onChanged(constructRecurrencePattern());
                },
              ));
            }).toList(),
          );
  }

  Widget _buildHourlyPattern(BuildContext context) {
    return Wrap(
            spacing: 8,
            children: List<int>.generate(60, (m) => m).map((m) {
              return Padding(padding: EdgeInsets.symmetric(vertical: 5), child: ChoiceChip(
                label: Text(m.toString()),
                selected: _selectedMinutes.contains(m),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedMinutes.add(m);
                    } else {
                      _selectedMinutes.remove(m);
                    }
                  });
                  widget.onChanged(constructRecurrencePattern());
                },
              ));
            }).toList(),
          );
  }

  /// Format TimeOfDay as "HH:mm"
  String _formatTimeOfDay(material.TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }


  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }



  Widget _buildStartDateTime(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(_labels.startDateTime),
        Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white70,
              ),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: _startDateTime,
                          firstDate: DateTime(_startDateTime.year - 10),
                          lastDate: DateTime(_startDateTime.year + 10),
                        );
                        if (date == null) return;
                        setState(() {
                          _startDateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            _startDateTime.hour,
                            _startDateTime.minute,
                          );
                        });
                        widget.onChanged(constructRecurrencePattern());
                      },
                      child: Text(_formatDate(_startDateTime)),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final t = await showTimePicker(context: context, initialTime: material.TimeOfDay(hour: _startDateTime.hour, minute: _startDateTime.minute));
                        if (t == null) return;
                          setState(() {
                            _startDateTime = DateTime(
                              _startDateTime.year,
                              _startDateTime.month,
                              _startDateTime.day,
                              t.hour,
                              t.minute,
                            );
                            widget.onChanged(constructRecurrencePattern());
                          });
                      },
                      child: Text(_formatTimeOfDay(material.TimeOfDay(hour: _startDateTime.hour, minute: _startDateTime.minute))),
                    ),
                  ],
                ),
            ),
      ],
    );
      
  }

  Widget _buildDueDateTime(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${_labels.dueDateTime} '),
        Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white70,
              ),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: _startDateTime,
                          firstDate: DateTime(_startDateTime.year - 10),
                          lastDate: DateTime(_startDateTime.year + 10),
                        );
                        if (date == null) return;
                        setState(() {
                          _dueDateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            _dueDateTime?.hour ?? _startDateTime.hour+1,
                            _dueDateTime?.minute ?? _startDateTime.minute,
                          );
                        });
                        widget.onChanged(constructRecurrencePattern());
                      },
                      child: Text(_formatDate(_dueDateTime ?? _startDateTime)),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final t = await showTimePicker(context: context, initialTime: material.TimeOfDay(hour: _startDateTime.hour, minute: _startDateTime.minute));
                        if (t == null) return;
                          setState(() {
                            _dueDateTime = DateTime(
                              _dueDateTime?.year ?? _startDateTime.year,
                              _dueDateTime?.month ?? _startDateTime.month,
                              _dueDateTime?.day ?? _startDateTime.day,
                              t.hour,
                              t.minute,
                            );
                          });
                          widget.onChanged(constructRecurrencePattern());
                          
                      },
                      child: Text(_formatTimeOfDay(material.TimeOfDay(hour: _dueDateTime?.hour ?? _startDateTime.hour, 
                        minute: _dueDateTime?.minute ?? _startDateTime.minute))),
                    ),
                  ],
                ),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        _buildStartDateTime(context),
        _buildDueDateTime(context),
        _buildRecurrenceOption(context),
        if (_recurrenceType == RecurrencePatternType.hourly) _buildHourlyPattern(context),
        if (_recurrenceType == RecurrencePatternType.weekly) _buildWeeklyPattern(context),
        if (_recurrenceType == RecurrencePatternType.monthly) _buildMonthlyPattern(context),
        SizedBox(height: 10),
        //if (_recurrenceType != RecurrencePatternType.once && _recurrenceType != RecurrencePatternType.hourly) _buildTimePicker(context), 
        
      ],
    );
  }
}