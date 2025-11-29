import 'package:casseed/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RequiredFieldIndicator extends StatelessWidget {
  final Widget child;
  final bool valid;
  const RequiredFieldIndicator({
    super.key,
    this.valid = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Badge(
      textColor: valid ? AppTheme.success : AppTheme.error,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      alignment: Alignment.topRight,
      offset: Offset(0, -12),
      label: Text(
        "*",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      child: child,
    );
  }
}
