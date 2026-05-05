import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/widgets/drop_target_box/drop_target_box.dart';
import 'package:flutter/material.dart';

class DraggableDecodePage extends StatelessWidget {
  final PageController draggablePageController;
  final OnDragDone onDragDone;
  final List<Artifact> artifacts;
  final PlatformType platformType;

  const DraggableDecodePage({
    super.key,
    required this.draggablePageController,
    required this.onDragDone,
    required this.artifacts,
    required this.platformType,
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: draggablePageController,
      children: [
        for (final artifact in artifacts)
          DropTargetBox(
            artifact: artifact,
            platformType: platformType,
            onDragDone: onDragDone,
          ),
      ],
    );
  }
}
