import 'package:desktop_drop/desktop_drop.dart';
import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:flutter/material.dart';

class DropTargetBox extends StatefulWidget {
  final Artifact artifact;
  final ValueChanged<DropDoneDetails> onDragDone;

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
    final defaultBorder = Border.all(color: const Color(0xff9b9b9b));
    final draggingBorder = Border.all(color: Colors.blue, width: 5);
    final l = context.l;

    return DropTarget(
      onDragEntered: _onDragEntered,
      onDragExited: _onDragExited,
      onDragDone: widget.onDragDone,
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
