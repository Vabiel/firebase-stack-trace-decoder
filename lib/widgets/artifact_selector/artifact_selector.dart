import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:flutter/cupertino.dart';

class ArtifactSelector extends StatefulWidget {
  final List<Artifact> artifacts;
  final ValueChanged<int> onSelect;
  final Artifact? selected;

  const ArtifactSelector({
    Key? key,
    required this.artifacts,
    required this.onSelect,
    required this.selected,
  }) : super(key: key);

  @override
  State<ArtifactSelector> createState() => _ArtifactSelectorState();
}

class _ArtifactSelectorState extends State<ArtifactSelector> {
  late Artifact? _selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    final artifacts = widget.artifacts;
    return CupertinoSegmentedControl<Artifact>(
      children: <Artifact, Widget>{
        for (final artifact in artifacts)
          artifact: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FittedBox(
              child: Text(
                artifact.filename,
                maxLines: 1,
              ),
            ),
          ),
      },
      onValueChanged: (artifact) {
        setState(() {
          _selected = artifact;
          widget.onSelect(artifacts.indexOf(artifact));
        });
      },
      groupValue: _selected,
    );
  }
}
