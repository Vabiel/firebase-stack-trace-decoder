import 'package:desktop_drop/desktop_drop.dart';
import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/application/uid_utils.dart';
import 'package:firebase_stacktrace_decoder/dialogs/app_dialog/app_dialog.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/widgets/ui/ui.dart';
import 'package:flutter/material.dart';

import '../../application/extensions/string_extension/string_extension.dart';

typedef OnDragDone = void Function(
    DropDoneDetails details, Artifact artifact, PlatformType platformType);
typedef OnDecodeData = void Function(
    Artifact artifact, List<String> stackTraceList);

/// Workspace view for a single open (project, version, platform) tab.
///
/// Layout (top → bottom):
///   1. [ArtifactBar] — selects which `*.symbols` file to decode against.
///   2. [SegmentedToggle] — drag-and-drop vs manual paste.
///   3. Mode body — drop zone or scrollable list of manual stack-trace blocks.
class WorkspaceView extends StatefulWidget {
  final ProjectVersion version;
  final Platform platform;
  final OnDragDone onDragDone;
  final OnDecodeData onDecodeData;

  const WorkspaceView({
    super.key,
    required this.version,
    required this.platform,
    required this.onDragDone,
    required this.onDecodeData,
  });

  @override
  State<WorkspaceView> createState() => _WorkspaceViewState();
}

class _WorkspaceViewState extends State<WorkspaceView>
    with AutomaticKeepAliveClientMixin {
  DecodeMode _mode = DecodeMode.dragging;
  late Artifact _artifact = widget.platform.artifacts.first;
  final List<_ManualEntry> _manualEntries = [_ManualEntry.empty()];

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(WorkspaceView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.platform.artifacts.contains(_artifact)) {
      _artifact = widget.platform.artifacts.first;
    }
  }

  @override
  void dispose() {
    for (final e in _manualEntries) {
      e.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        _ArtifactBar(
          artifacts: widget.platform.artifacts,
          selected: _artifact,
          onChange: (a) => setState(() => _artifact = a),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(AppTokens.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildModeRow(),
          const SizedBox(height: AppTokens.s3),
          Expanded(
            child: _mode == DecodeMode.dragging
                ? _DragMode(
                    artifact: _artifact,
                    platformType: widget.platform.type,
                    onDragDone: widget.onDragDone,
                  )
                : _ManualMode(
                    entries: _manualEntries,
                    platformType: widget.platform.type,
                    onAddEntry: () => setState(
                        () => _manualEntries.add(_ManualEntry.empty())),
                    onRemoveEntry: _manualEntries.length > 1
                        ? (e) => setState(() {
                              _manualEntries.remove(e);
                              e.dispose();
                            })
                        : null,
                    onDecodeOne: _decodeOne,
                    onDecodeAll: _decodeAll,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeRow() {
    final l = context.l;
    return Row(
      children: [
        SegmentedToggle<DecodeMode>(
          options: [
            (value: DecodeMode.dragging, label: l.draggingDecodeModeTitle),
            (value: DecodeMode.manual, label: l.manualDecodeModeTitle),
          ],
          selected: _mode,
          onChanged: (v) => setState(() => _mode = v),
        ),
        const Spacer(),
        if (_mode == DecodeMode.manual)
          AppButton(
            kind: AppButtonKind.ghost,
            size: AppButtonSize.sm,
            icon: AppIcons.reset,
            label: 'Clear',
            onPressed: _manualEntries.any((e) => e.controller.text.isNotEmpty)
                ? _clearAll
                : null,
          ),
      ],
    );
  }

  void _decodeOne(_ManualEntry entry) async {
    final text = entry.controller.text;
    final stack = text.prepareStackTrace(widget.platform.type);
    if (stack.isEmpty) {
      final l = context.l;
      await AppDialog.showAlert(
        context,
        title: l.decodeDialogErrorTitle,
        content: text.isEmpty
            ? l.decodeDialogEmptyTitle
            : l.decodeDialogInvalidTitle,
      );
      return;
    }
    widget.onDecodeData(_artifact, [stack]);
  }

  void _decodeAll() async {
    final l = context.l;
    final all = _manualEntries.map((e) => e.controller.text).toList();
    final prepared = [
      for (final t in all)
        if (t.prepareStackTrace(widget.platform.type).isNotEmpty)
          t.prepareStackTrace(widget.platform.type)
    ];
    if (prepared.isEmpty) {
      await AppDialog.showAlert(
        context,
        title: l.decodeDialogErrorTitle,
        content: l.decodeDialogEmptyListTitle,
      );
      return;
    }
    if (prepared.length < all.length) {
      final ok = await AppDialog.showConfirm(
        context,
        title: l.decodeDialogWarningTitle,
        content: l.decodeDialogConfirmText,
      );
      if (!ok) return;
    }
    widget.onDecodeData(_artifact, prepared);
  }

  void _clearAll() {
    setState(() {
      for (final e in _manualEntries) {
        e.controller.clear();
      }
    });
  }
}

class _ManualEntry {
  final String id;
  final TextEditingController controller;

  _ManualEntry._(this.id, this.controller);

  factory _ManualEntry.empty() {
    final c = TextEditingController();
    return _ManualEntry._(UidUtils.v4, c);
  }

  void dispose() => controller.dispose();
}

// ─── Artifact bar ────────────────────────────────────────────────────────────
class _ArtifactBar extends StatelessWidget {
  final List<Artifact> artifacts;
  final Artifact selected;
  final ValueChanged<Artifact> onChange;

  const _ArtifactBar({
    required this.artifacts,
    required this.selected,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.s4, vertical: AppTokens.s2),
      decoration: BoxDecoration(
        color: t.surface2,
        border: Border(bottom: BorderSide(color: t.border)),
      ),
      child: Row(
        children: [
          Text(
            'SYMBOLS',
            style: TextStyle(
              color: t.textDim,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(width: AppTokens.s3),
          if (artifacts.length > 1)
            Flexible(
              child: AppDropdownButton(
                value: selected.filename,
                prefixIcon: AppIcons.file,
                onPressed: () => _pickArtifact(context),
              ),
            )
          else
            Mono(selected.filename, size: 11.5),
          const Spacer(),
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 6),
            decoration:
                BoxDecoration(color: t.success, shape: BoxShape.circle),
          ),
          Text(
            'Symbols loaded',
            style: TextStyle(color: t.textMuted, fontSize: 11.5),
          ),
        ],
      ),
    );
  }

  Future<void> _pickArtifact(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset(0, box.size.height));
    final picked = await showAppPopupMenu<Artifact>(
      context: context,
      position: pos,
      items: [
        for (final a in artifacts)
          AppMenuItem<Artifact>(
            value: a,
            label: a.filename,
            icon: AppIcons.file,
          ),
      ],
    );
    if (picked != null) onChange(picked);
  }
}

// ─── Drop mode ───────────────────────────────────────────────────────────────
class _DragMode extends StatefulWidget {
  final Artifact artifact;
  final PlatformType platformType;
  final OnDragDone onDragDone;

  const _DragMode({
    required this.artifact,
    required this.platformType,
    required this.onDragDone,
  });

  @override
  State<_DragMode> createState() => _DragModeState();
}

class _DragModeState extends State<_DragMode> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l;
    return DropTarget(
      onDragEntered: (_) => setState(() => _hover = true),
      onDragExited: (_) => setState(() => _hover = false),
      onDragDone: (details) {
        setState(() => _hover = false);
        widget.onDragDone(details, widget.artifact, widget.platformType);
      },
      child: DropZone(
        active: _hover,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.upload,
              size: 28,
              color: _hover ? t.accent : t.textMuted,
            ),
            const SizedBox(height: 10),
            Text(
              _hover
                  ? 'Release to decode'
                  : l.dropTargetBoxTitle,
              style: TextStyle(
                color: t.text,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Plain text or .txt — multiple files supported',
              style: TextStyle(color: t.textMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Manual mode ─────────────────────────────────────────────────────────────
class _ManualMode extends StatelessWidget {
  final List<_ManualEntry> entries;
  final PlatformType platformType;
  final VoidCallback onAddEntry;
  final ValueChanged<_ManualEntry>? onRemoveEntry;
  final ValueChanged<_ManualEntry> onDecodeOne;
  final VoidCallback onDecodeAll;

  const _ManualMode({
    required this.entries,
    required this.platformType,
    required this.onAddEntry,
    required this.onRemoveEntry,
    required this.onDecodeOne,
    required this.onDecodeAll,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var i = 0; i < entries.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  _ManualBlock(
                    key: ValueKey(entries[i].id),
                    label: 'TRACE ${i + 1}',
                    entry: entries[i],
                    onDecode: () => onDecodeOne(entries[i]),
                    onRemove: onRemoveEntry == null
                        ? null
                        : () => onRemoveEntry!(entries[i]),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppTokens.s3),
        Row(
          children: [
            AppButton(
              kind: AppButtonKind.ghost,
              size: AppButtonSize.sm,
              icon: AppIcons.add,
              label: l.manualDecodePageAddTitle,
              onPressed: onAddEntry,
            ),
            const Spacer(),
            AppButton(
              kind: AppButtonKind.primary,
              size: AppButtonSize.md,
              label: '${l.manualDecodeAllTitle} (${entries.length})',
              onPressed: onDecodeAll,
            ),
          ],
        ),
      ],
    );
  }
}

class _ManualBlock extends StatefulWidget {
  final String label;
  final _ManualEntry entry;
  final VoidCallback onDecode;
  final VoidCallback? onRemove;

  const _ManualBlock({
    super.key,
    required this.label,
    required this.entry,
    required this.onDecode,
    required this.onRemove,
  });

  @override
  State<_ManualBlock> createState() => _ManualBlockState();
}

class _ManualBlockState extends State<_ManualBlock> {
  @override
  void initState() {
    super.initState();
    widget.entry.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.entry.controller.removeListener(_listener);
    super.dispose();
  }

  void _listener() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l;
    final text = widget.entry.controller.text;
    final lineCount = text.isEmpty ? 0 : '\n'.allMatches(text).length + 1;
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(AppTokens.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.s3, vertical: 6),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: t.divider)),
            ),
            child: Row(
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    color: t.textDim,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$lineCount lines',
                  style: TextStyle(
                    color: t.textDim,
                    fontSize: 11,
                    fontFamily: t.fontMono,
                  ),
                ),
                const Spacer(),
                if (widget.onRemove != null)
                  AppButton(
                    kind: AppButtonKind.ghost,
                    size: AppButtonSize.sm,
                    icon: AppIcons.trash,
                    onPressed: widget.onRemove,
                  ),
                const SizedBox(width: 4),
                AppButton(
                  kind: AppButtonKind.secondary,
                  size: AppButtonSize.sm,
                  label: 'Decode',
                  onPressed: text.isEmpty ? null : widget.onDecode,
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 110, maxHeight: 240),
            child: TextField(
              controller: widget.entry.controller,
              maxLines: null,
              expands: true,
              cursorColor: t.accent,
              cursorWidth: 1.5,
              style: TextStyle(
                color: t.codeText,
                fontFamily: t.fontMono,
                fontSize: 11.5,
                height: AppTokens.lhCode,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.s3, vertical: 10),
                border: InputBorder.none,
                hintText: l.decodeResultFieldHintText,
                hintStyle: TextStyle(
                  color: t.textDim,
                  fontFamily: t.fontMono,
                  fontSize: 11.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
