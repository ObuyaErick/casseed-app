import 'package:flutter/material.dart';

Widget buildCircularProgressIndicator(
  BuildContext context, {
  double size = 16.0,
  double strokeWidth = 2,
  Color? color,
}) {
  final valueColor = color ?? Theme.of(context).colorScheme.primary;
  return CircularProgressIndicator(
    constraints: BoxConstraints.tightFor(width: size, height: size),
    valueColor: AlwaysStoppedAnimation(valueColor),
    strokeCap: StrokeCap.round,
    strokeWidth: strokeWidth,
    backgroundColor: valueColor.withValues(alpha: 0.3),
  );
}
