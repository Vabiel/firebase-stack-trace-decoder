import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/widgets/ui/ui.dart';
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
  SelectPlatformDialog._();

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
    if (entries.length == 1) return entries.first;

    return showAppDialog<SelectPlatformResult>(
      context: context,
      builder: (ctx) => _SelectPlatformDialogBody(project: project),
    );
  }
}

class _SelectPlatformDialogBody extends StatefulWidget {
  final Project project;
  const _SelectPlatformDialogBody({required this.project});

  @override
  State<_SelectPlatformDialogBody> createState() =>
      _SelectPlatformDialogBodyState();
}

class _SelectPlatformDialogBodyState
    extends State<_SelectPlatformDialogBody> {
  SelectPlatformResult? _selected;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l;

    return AppDialogFrame(
      title: l.selectPlatformDialogTitle(widget.project.name),
      width: 420,
      onClose: () => Navigator.of(context).pop(),
      footer: [
        const Spacer(),
        AppButton(
          kind: AppButtonKind.ghost,
          label: l.cancelButtonTitle,
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton(
          kind: AppButtonKind.primary,
          label: l.openButtonTitle,
          onPressed: _selected == null
              ? null
              : () => Navigator.of(context).pop(_selected),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              l.selectPlatformDialogBody,
              style: TextStyle(color: t.textMuted, fontSize: 12.5),
            ),
          ),
          for (final v in widget.project.versions)
            if (v.platforms.any((p) => p.isActive)) ...[
              Padding(
                padding:
                    const EdgeInsets.only(left: 4, bottom: 4, top: 6),
                child: Mono(v.version, dim: true, size: 11.5),
              ),
              Container(
                decoration: BoxDecoration(
                  color: t.surface,
                  border: Border.all(color: t.border),
                  borderRadius: BorderRadius.circular(AppTokens.radius),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < v.platforms.length; i++)
                      if (v.platforms[i].isActive)
                        _buildRow(
                          context,
                          version: v,
                          platform: v.platforms[i],
                          showDivider: _hasActiveBefore(v, i),
                        ),
                  ],
                ),
              ),
            ],
        ],
      ),
    );
  }

  bool _hasActiveBefore(ProjectVersion v, int index) {
    for (var i = 0; i < index; i++) {
      if (v.platforms[i].isActive) return true;
    }
    return false;
  }

  Widget _buildRow(BuildContext context,
      {required ProjectVersion version,
      required Platform platform,
      required bool showDivider}) {
    final t = context.tokens;
    final l = context.l;
    final value = SelectPlatformResult(version, platform);
    final on = value == _selected;
    final artifactCount = platform.artifacts.length;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _selected = value),
        child: Container(
          decoration: BoxDecoration(
            color: on ? t.accentSoft : Colors.transparent,
            border: showDivider
                ? Border(top: BorderSide(color: t.divider))
                : null,
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: AppTokens.s3, vertical: AppTokens.s2),
          child: Row(
            children: [
              AppRadio(checked: on, onTap: () {
                setState(() => _selected = value);
              }),
              const SizedBox(width: 10),
              Icon(PlatformGlyphs.of(platform.type),
                  size: 14, color: t.textMuted),
              const SizedBox(width: 6),
              Text(
                platform.name,
                style: TextStyle(color: t.text, fontSize: 13),
              ),
              const Spacer(),
              Mono(
                l.artifactsCountText(artifactCount),
                dim: true,
                size: 11,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
