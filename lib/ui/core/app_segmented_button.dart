import 'package:flutter/material.dart';

class AppSegmentedButton<T> extends StatelessWidget {
  const AppSegmentedButton({
    super.key,
    this.multiSelect = false,
    this.borderRadius = 0.0,
    required this.items,
    this.selected = const {},
    required this.selectedBuilder,
    required this.itemBuilder,
    required this.onSelectionChanged,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
  });

  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final bool multiSelect;
  final double borderRadius;
  final List<T> items;
  final Set<T> selected;
  final Widget Function(BuildContext context, T item, int index)
  selectedBuilder;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final void Function(Set<T> selected) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color:
            backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++)
            if (selected.contains(items[i]))
              Material(
                clipBehavior: Clip.antiAlias,
                color: selectedColor ?? Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(borderRadius * 0.8),
                child: InkWell(
                  hoverColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  onTap: () {},
                  child: selectedBuilder(context, items[i], i),
                ),
              )
            else
              Material(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(borderRadius * 0.8),
                color: unselectedColor ?? Colors.transparent,
                child: InkWell(
                  onTap: () => onSelectionChanged(
                    multiSelect ? {...selected, items[i]} : {items[i]},
                  ),
                  child: itemBuilder(context, items[i], i),
                ),
              ),
        ],
      ),
    );
  }
}
