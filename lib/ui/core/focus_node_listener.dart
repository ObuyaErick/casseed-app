import 'package:flutter/material.dart';

class FocusNodeListener extends StatefulWidget {
  final FocusNode? focusNode;

  final Widget Function(
    BuildContext context,
    FocusNode focusNode,
    bool hasFocus,
  )
  builder;
  const FocusNodeListener({super.key, required this.builder, this.focusNode});

  @override
  State<FocusNodeListener> createState() => _FocusNodeListenerState();
}

class _FocusNodeListenerState extends State<FocusNodeListener> {
  late FocusNode _focusNode;
  late bool isExternalNode;

  @override
  void initState() {
    super.initState();
    isExternalNode = widget.focusNode != null;
    final focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      setState(() {});
    });
    _focusNode = focusNode;
  }

  @override
  void dispose() {
    if (!isExternalNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _focusNode, _focusNode.hasFocus);
  }
}
