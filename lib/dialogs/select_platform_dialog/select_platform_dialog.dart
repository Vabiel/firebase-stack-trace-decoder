import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';

class SelectPlatformResult {
  final ProjectVersion version;
  final Platform platform;

  const SelectPlatformResult(this.version, this.platform);

  @override
  bool operator ==(Object other) =>
      other is SelectPlatformResult &&
      other.version.uid == version.uid &&
      other.platform.uid == platform.uid;

  @override
  int get hashCode => Object.hash(version.uid, platform.uid);
}

class SelectPlatformDialog {
  static Future<SelectPlatformResult?> show(
    BuildContext context, {
    required Project project,
  }) async {
    final entries = <SelectPlatformResult>[];
    for (final v in project.versions) {
      for (final p in v.platforms.where((p) => p.isActive)) {
        entries.add(SelectPlatformResult(v, p));
      }
    }
    if (entries.isEmpty) return null;

    return showDialog<SelectPlatformResult?>(
      context: context,
      builder: (BuildContext context) {
        final l = context.l;
        SelectPlatformResult? selected;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(l.platformSelectorTooltip),
            content: SingleChildScrollView(
              child: RadioGroup<SelectPlatformResult>(
                groupValue: selected,
                onChanged: (value) {
                  setState(() => selected = value);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final v in project.versions)
                      if (v.platforms.any((p) => p.isActive)) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                          child: Text(
                            v.version,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        for (final p in v.platforms.where((p) => p.isActive))
                          RadioListTile<SelectPlatformResult>(
                            value: SelectPlatformResult(v, p),
                            title: Text(p.name),
                          ),
                      ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(l.cancelButtonTitle)),
              TextButton(
                  onPressed: selected != null
                      ? () => Navigator.of(context).pop(selected)
                      : null,
                  child: Text(l.selectButtonTitle)),
            ],
          );
        });
      },
    );
  }

  SelectPlatformDialog._();
}
