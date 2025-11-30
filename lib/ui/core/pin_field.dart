import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final FocusNode? previousFocus;
  final Function(String)? onChanged;
  final VoidCallback? onSubmit;
  final double width;
  final double verticalPadding;

  const PinField({
    super.key,
    this.verticalPadding = 8,
    this.width = 20,
    required this.controller,
    required this.focusNode,
    this.nextFocus,
    this.previousFocus,
    this.onChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: min(width, verticalPadding * 2) * (2 / 3),
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.symmetric(vertical: verticalPadding),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
        onSubmitted: (value) {
          if (onSubmit != null) {
            onSubmit!();
          }
        },
      ),
    );
  }
}
