import 'package:flutter/material.dart';

class HoverListener extends StatefulWidget {
  const HoverListener({super.key, required this.builder});

  final Widget Function(BuildContext context, bool hovered) builder;

  @override
  State<HoverListener> createState() => _HoverListenerState();
}

class _HoverListenerState extends State<HoverListener> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          _hovered = false;
        });
      },
      child: widget.builder(context, _hovered),
    );
  }
}
