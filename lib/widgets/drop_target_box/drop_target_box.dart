import 'package:desktop_drop/desktop_drop.dart';
import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/widgets/platform_tab_data/platform_tab_data.dart';
import 'package:flutter/material.dart';

typedef OnDragDone = void Function(DropDoneDetails, Artifact);

class DropTargetBox extends StatefulWidget {
  final Artifact artifact;
  final OnDragDone onDragDone;

  const DropTargetBox({
    super.key,
    required this.artifact,
    required this.onDragDone,
  });

  @override
  State<DropTargetBox> createState() => _DropTargetBoxState();
}

class _DropTargetBoxState extends State<DropTargetBox> {
  var _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final defaultBorder = Border.all(color: AppTheme.borderColor);
    final draggingBorder = Border.all(color: Colors.blue, width: 5);
    final l = context.l;

    return DropTarget(
      onDragEntered: _onDragEntered,
      onDragExited: _onDragExited,
      onDragDone: (details) => widget.onDragDone(details, widget.artifact),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_isDragging ? 8 : 4),
          border: _isDragging ? draggingBorder : defaultBorder,
        ),
        child: Text(l.dropTargetBoxTitle),
      ),
    );
  }

  void _onDragEntered(DropEventDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onDragExited(DropEventDetails details) {
    setState(() {
      _isDragging = false;
    });
  }
}

class DecodeResult {
  final String filename;
  final String result;
  final DecodeMode mode;

  const DecodeResult({
    required this.filename,
    required this.result,
    required this.mode,
  });
}
