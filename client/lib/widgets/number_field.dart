// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final int min;
  final int max;
  final int step;

  const NumberField({
    super.key,
    required this.controller,
    this.label,
    this.min = 0,
    this.max = 1000,
    this.step = 1,
  });

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  void _increment() {
    final currentValue = int.tryParse(widget.controller.text) ?? widget.min;
    if (currentValue + widget.step <= widget.max) {
      widget.controller.text = (currentValue + widget.step).toString();
    }
  }

  void _decrement() {
    final currentValue = int.tryParse(widget.controller.text) ?? widget.min;
    if (currentValue - widget.step >= widget.min) {
      widget.controller.text = (currentValue - widget.step).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: IconButton(
          icon: const Icon(Icons.remove),
          onPressed: _decrement,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.add),
          onPressed: _increment,
        ),
      ),
    );
  }
}
