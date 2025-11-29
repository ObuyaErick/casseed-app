import 'package:flutter/material.dart';

typedef ThemedMaterialScheme = ({
  Color bgColor,
  Color fgColor,
  Color borderColor,
});

class ThemedMaterial extends StatelessWidget {
  const ThemedMaterial({
    super.key,
    this.opacity = 1.0,
    this.elevation = 0,
    this.themeColor,
    this.borderRadius = 0.0,
    this.padding,
    this.borderSideBuilder,
    required this.contentBuilder,
  });

  final double opacity;
  final double elevation;
  final Color? themeColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final BorderSide Function(ThemedMaterialScheme)? borderSideBuilder;
  final Widget Function(ThemedMaterialScheme) contentBuilder;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = themeColor == null
        ? Theme.of(context).colorScheme
        : ColorScheme.fromSeed(seedColor: themeColor!);

    final ThemedMaterialScheme localScheme = (
      fgColor: colorScheme.primary,
      bgColor: colorScheme.primaryContainer,
      borderColor: colorScheme.primary.withValues(alpha: 0.3),
    );

    return Material(
      clipBehavior: Clip.antiAlias,
      elevation: elevation,
      color: colorScheme.primaryContainer.withValues(alpha: opacity),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: borderSideBuilder != null
            ? borderSideBuilder!((localScheme))
            : BorderSide.none,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(0),
        child: contentBuilder((localScheme)),
      ),
    );
  }
}
