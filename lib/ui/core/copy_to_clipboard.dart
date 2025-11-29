import 'dart:async';

import 'package:casseed/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyToClipboard extends StatefulWidget {
  const CopyToClipboard({
    super.key,
    required this.value,
    this.size = 32,
    this.tooltip = "Copy to clipboard",
  });

  final String value;
  final double size;
  final String tooltip;

  @override
  State<CopyToClipboard> createState() => _CopyToClipboardState();
}

class _CopyToClipboardState extends State<CopyToClipboard> {
  bool _copied = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          try {
            await Clipboard.setData(ClipboardData(text: widget.value));

            _timer?.cancel();
            setState(() {
              _copied = true;
              _timer = Timer(const Duration(seconds: 2), () {
                if (mounted) {
                  setState(() {
                    _copied = false;
                  });
                }
              });
            });
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to copy to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        },
        child: Container(
          height: widget.size,
          width: widget.size,
          decoration: BoxDecoration(
            border: _copied ? Border.all(color: AppTheme.success) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              _copied ? Icons.done_all_rounded : Icons.copy_rounded,
              color: _copied ? AppTheme.success : null,
              size: widget.size * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
