import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/widgets/artifact_selector/artifact_selector.dart';
import 'package:firebase_stacktrace_decoder/widgets/drop_target_box/drop_target_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformTabData extends StatefulWidget {
  final Platform platform;
  final OnDragDone onDragDone;

  const PlatformTabData({
    Key? key,
    required this.platform,
    required this.onDragDone,
  }) : super(key: key);

  @override
  State<PlatformTabData> createState() => _PlatformTabDataState();
}

class _PlatformTabDataState extends State<PlatformTabData> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final platform = widget.platform;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _buildBody(platform),
    );
  }

  Widget _buildBody(Platform platform) {
    final artifacts = platform.artifacts;
    return Column(
      children: [
        if (artifacts.length > 1)
          ArtifactSelector(
            artifacts: artifacts,
            onSelect: (page) => _pageController.jumpToPage(page),
          ),
        const SizedBox(height: 8),
        Expanded(
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              for (final artifact in artifacts)
                DropTargetBox(
                  artifact: artifact,
                  onDragDone: widget.onDragDone,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
