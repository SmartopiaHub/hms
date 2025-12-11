// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';

class AddOrEditChip extends StatefulWidget {
  final String? label;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onDeleted;
  final Locale? locale;
  const AddOrEditChip({super.key, this.label, required this.onSubmitted, required this.onDeleted, this.locale});
  @override
  State<AddOrEditChip> createState() => _AddOrEditChipState();
}

class _AddOrEditChipState extends State<AddOrEditChip> {
  bool _editing = false;
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.label);
  }

  String get _addLabel {
    if (widget.locale == null) return 'Add';
    switch (widget.locale!.languageCode) {
      case 'zh':
        return '添加';
      default:
        return 'Add';
    }
  }

  @override
  Widget build(BuildContext ctx) {
    if (_editing) {
      return SizedBox(
        width: 100,
        child: TextField(
          controller: _ctrl,
          autofocus: true,
          onSubmitted: (val) {
            widget.onSubmitted(val);
            setState(() => _editing = false);
          },
          onEditingComplete: () {
            widget.onSubmitted(_ctrl.text);
            setState(() => _editing = false);
          },
          onTapOutside: (_) {
            widget.onSubmitted(_ctrl.text);
            setState(() => _editing = false);
          },
        ),
      );
    }

    if (widget.label == null || widget.label!.isEmpty) {
      return ActionChip(
        avatar: Icon(Icons.add, size: 18),
        label: Text(_addLabel),
        onPressed: () => setState(() => _editing = true),
      );
    }

    return InputChip(
      label: Text(widget.label!),
      onDeleted: widget.onDeleted,
      deleteIcon: Icon(Icons.close),
      onPressed: () => setState(() => _editing = true),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}