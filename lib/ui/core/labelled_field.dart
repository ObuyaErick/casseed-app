import 'package:flutter/material.dart';

class LabelledField extends StatelessWidget {
  final Widget child;
  final Widget? label;
  final String? labelText;
  const LabelledField({
    super.key,
    this.label,
    this.labelText,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        if (label != null)
          label!
        else if (labelText != null)
          Text(
            labelText!,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),

        child,
      ],
    );
  }
}
