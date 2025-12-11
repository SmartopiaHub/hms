// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DurationPicker extends StatefulWidget {
  final bool showYear;
  final bool showMonth;
  final Locale locale;
  final Duration? initialValue;
  final String? label;
  final void Function(Duration duration)? onChanged;

  const DurationPicker({
    super.key,
    this.showYear = false,
    this.showMonth = false,
    this.locale = const Locale('en'),
    this.onChanged,
    this.initialValue,
    this.label,
  });

  @override
  State<DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  int years = 0, months = 0, days = 0, hours = 0, minutes = 0;

  late Map<String, String> labels;

  @override
  void initState() {
    super.initState();
    labels = _getLabels(widget.locale);
    if (widget.initialValue != null) {
      final duration = widget.initialValue!;
      years = duration.inDays ~/ 365;
      months = (duration.inDays % 365) ~/ 30;
      days = duration.inDays % 30;
      hours = duration.inHours % 24;
      minutes = duration.inMinutes % 60;
    }
  }

  @override
  void didUpdateWidget(covariant DurationPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locale != widget.locale) {
      labels = _getLabels(widget.locale);
    }
  }

  Map<String, String> _getLabels(Locale locale) {
    if (locale.languageCode == 'zh') {
      return {
        'year': '年',
        'month': '月',
        'day': '天',
        'hour': '小时',
        'minute': '分',
      };
    }
    // Default to English
    return {
      'year': 'Y',
      'month': 'M',
      'day': 'D',
      'hour': 'H',
      'minute': 'M',
    };
  }

  void _onFieldChanged() {
    final duration = Duration(
      days: days + months * 30 + years * 365,
      hours: hours,
      minutes: minutes,
    );
    widget.onChanged?.call(duration);
  }

  Widget _buildNumberField(int value, void Function(String) onChanged, String label, {int max = 999}) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: TextFormField(
            //controller: TextEditingController(text: value > 0 ? value.toString() : ''),
            initialValue: value > 0 ? value.toString() : '',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) {
              int v = int.tryParse(val) ?? 0;
              if (v > max) v = max;
              onChanged(v.toString());
              _onFieldChanged();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(label),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fields = [];

    if (widget.showYear) {
      fields.add(_buildNumberField(years, (v) => setState(() => years = int.tryParse(v) ?? 0), labels['year']!));
    }
    if (widget.showMonth) {
      fields.add(_buildNumberField(months, (v) => setState(() => months = int.tryParse(v) ?? 0), labels['month']!));
    }
    fields.add(_buildNumberField(days, (v) => setState(() => days = int.tryParse(v) ?? 0), labels['day']!));
    fields.add(_buildNumberField(hours, (v) => setState(() => hours = int.tryParse(v) ?? 0), labels['hour']!));
    fields.add(_buildNumberField(minutes, (v) => setState(() => minutes = int.tryParse(v) ?? 0), labels['minute']!));

    var input = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: fields
          .map((w) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: w,
              ))
          .toList(),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.label ?? 'Duration',
          //style: const TextStyle(fontSize: 16),
        ),
        input,
        
      ],
    );
  }
}