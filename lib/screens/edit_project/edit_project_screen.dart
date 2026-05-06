import 'dart:io';

import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/application/uid_utils.dart';
import 'package:firebase_stacktrace_decoder/blocs/screens/edit_project/edit_project_bloc.dart';
import 'package:firebase_stacktrace_decoder/dialogs/app_dialog/app_dialog.dart';
import 'package:firebase_stacktrace_decoder/dialogs/file_picker_dialog/file_picker_dialog.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/widgets/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:string_ext/string_ext.dart';

class EditProjectScreen extends StatefulWidget {
  final Project? project;
  const EditProjectScreen({super.key, this.project});

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_VersionEditState> _versions = [];
  late final EditProjectBloc _bloc;
  bool _saveAttempted = false;
  String? _preview;

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    _preview = p?.preview;
    _bloc = EditProjectBloc(projectLocalProvider: Get.find(), input: p);
    _nameController.text = p?.name ?? '';
    _nameController.addListener(_textListener);

    final initial = p?.versions ?? const <ProjectVersion>[];
    if (initial.isEmpty) {
      _versions.add(_VersionEditState.empty());
    } else {
      for (final v in initial) {
        _versions.add(_VersionEditState.fromVersion(v));
      }
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_textListener);
    _nameController.dispose();
    _scrollController.dispose();
    for (final v in _versions) {
      v.dispose();
    }
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return BlocListener<EditProjectBloc, EditProjectState>(
      bloc: _bloc,
      listener: (context, state) async {
        final l = context.l;
        if (state is EditProjectActionComplete) {
          switch (state.result) {
            case ActionResult.saveSuccess:
            case ActionResult.deleteSuccess:
              Navigator.of(context).pop(state.result);
              break;
            case ActionResult.saveFailed:
              await AppDialog.showAlert(context,
                  content: l.saveProjectErrorText);
              break;
            case ActionResult.deleteFailed:
              await AppDialog.showAlert(context,
                  content: l.deleteProjectErrorText);
              break;
          }
        }
      },
      child: Column(
        children: [
          Expanded(child: _buildBody(l)),
          _buildFooter(context, l),
        ],
      ),
    );
  }

  Widget _buildBody(AppLocalizations l) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppTokens.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(l),
            const SizedBox(height: AppTokens.s4),
            SectionLabel(
              text: l.versionsSectionLabel,
              trailing: AppButton(
                kind: AppButtonKind.ghost,
                size: AppButtonSize.sm,
                icon: AppIcons.add,
                label: l.addVersionButtonTitle,
                onPressed: _onAddVersion,
              ),
            ),
            for (var i = 0; i < _versions.length; i++) ...[
              if (i > 0) const SizedBox(height: AppTokens.s2),
              _VersionCard(
                key: ValueKey(_versions[i].id),
                state: _versions[i],
                showError: _saveAttempted,
                canDelete: _versions.length > 1,
                onDelete: () => _onDeleteVersion(i),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l) {
    final t = context.tokens;
    final showError = _saveAttempted && _nameController.text.isEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PreviewPicker(
          preview: _preview,
          onChange: (v) => setState(() => _preview = v),
        ),
        const SizedBox(width: AppTokens.s4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  l.editProjectScreenNameFieldTitle.toUpperCase(),
                  style: TextStyle(
                    color: t.textDim,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              AppTextField(
                controller: _nameController,
                hintText: l.editProjectScreenNameFieldTitle,
                errorText: showError
                    ? l.filledTextError(l.editProjectScreenNameFieldTitle)
                    : null,
              ),
              const SizedBox(height: 4),
              Text(
                l.editProjectNameHelper,
                style: TextStyle(color: t.textDim, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, AppLocalizations l) {
    final t = context.tokens;
    final isEdit = widget.project != null;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.s4, vertical: AppTokens.s3),
      decoration: BoxDecoration(
        color: t.surface2,
        border: Border(top: BorderSide(color: t.divider)),
      ),
      child: Row(
        children: [
          if (isEdit)
            AppButton(
              kind: AppButtonKind.destructiveSecondary,
              icon: AppIcons.trash,
              label: l.deleteProjectButtonLabel,
              onPressed: () => _onDeletePressed(context),
            ),
          const Spacer(),
          AppButton(
            kind: AppButtonKind.ghost,
            label: l.cancelButtonTitle,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: AppTokens.s2),
          AppButton(
            kind: AppButtonKind.primary,
            label: l.saveButtonTitle,
            onPressed: () => _onSavePressed(context),
          ),
        ],
      ),
    );
  }

  void _onAddVersion() {
    setState(() => _versions.add(_VersionEditState.empty()));
  }

  void _onDeleteVersion(int index) {
    setState(() {
      final v = _versions.removeAt(index);
      v.dispose();
    });
  }

  Future<void> _onDeletePressed(BuildContext context) async {
    final l = context.l;
    final ok = await AppDialog.showConfirm(context,
        title: l.deleteProjectDialogTitle, content: l.deleteProjectDialogText);
    if (ok && widget.project != null) {
      _bloc.deleteProject(widget.project!.uid);
    }
  }

  void _onSavePressed(BuildContext context) {
    final hasName = _nameController.text.isNotEmpty;
    final allVersionsValid =
        _versions.every((v) => v.versionController.text.isNotEmpty);
    if (!hasName || !allVersionsValid) {
      setState(() => _saveAttempted = true);
      return;
    }
    final versions = [for (final s in _versions) s.toModel()];
    _bloc.saveProject(
      name: _nameController.text,
      versions: versions,
      preview: _preview,
    );
  }

  void _textListener() {
    if (_saveAttempted) setState(() {});
  }
}

// ─── Preview picker ─────────────────────────────────────────────────────────
class _PreviewPicker extends StatelessWidget {
  final String? preview;
  final ValueChanged<String?> onChange;

  const _PreviewPicker({required this.preview, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final hasPreview = preview != null && preview!.isNotEmpty;
    return SizedBox(
      width: 76,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: hasPreview
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppTokens.radiusSm),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: t.border),
                            borderRadius:
                                BorderRadius.circular(AppTokens.radiusSm),
                          ),
                          child: Image.file(
                            File(preview!),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _placeholder(context, error: true),
                          ),
                        ),
                      )
                    : _placeholder(context),
              ),
              Positioned(
                right: -4,
                bottom: -4,
                child: _editButton(context),
              ),
            ],
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: hasPreview ? () => onChange(null) : () => _pick(context),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                hasPreview
                    ? context.l.deleteButtonTitle
                    : context.l.addButtonTitle,
                style: TextStyle(
                  color: hasPreview ? t.danger : t.textMuted,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context, {bool error = false}) {
    final t = context.tokens;
    return Container(
      decoration: BoxDecoration(
        color: t.surface2,
        border: Border.all(
          color: error ? t.danger : t.borderStrong,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      ),
      child: Icon(
        error ? Icons.image_not_supported_outlined : AppIcons.image,
        size: 22,
        color: error ? t.danger : t.textDim,
      ),
    );
  }

  Widget _editButton(BuildContext context) {
    final t = context.tokens;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _pick(context),
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: t.surface,
            shape: BoxShape.circle,
            border: Border.all(color: t.border),
            boxShadow: t.shadow1,
          ),
          alignment: Alignment.center,
          child: Icon(AppIcons.edit, size: 11, color: t.textMuted),
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final l = context.l;
    final res = await FilePickerDialog.pickImage(
        dialogTitle: l.previewSelectorDialogTitle);
    if (res != null) onChange(res.path);
  }
}

// ─── Version state ──────────────────────────────────────────────────────────
class _VersionEditState {
  final String id;
  final String? existingUid;
  final TextEditingController versionController;
  final ValueNotifier<List<Platform>> platforms;

  _VersionEditState._({
    required this.id,
    required this.existingUid,
    required this.versionController,
    required this.platforms,
  });

  factory _VersionEditState.empty() {
    return _VersionEditState._(
      id: UidUtils.v4,
      existingUid: null,
      versionController: TextEditingController(),
      platforms: ValueNotifier(const []),
    );
  }

  factory _VersionEditState.fromVersion(ProjectVersion v) {
    return _VersionEditState._(
      id: v.uid,
      existingUid: v.uid,
      versionController: TextEditingController(text: v.version),
      platforms: ValueNotifier(List<Platform>.from(v.platforms)),
    );
  }

  ProjectVersion toModel() {
    return ProjectVersion(
      uid: existingUid ?? UidUtils.v4,
      version: versionController.text,
      platforms: platforms.value,
    );
  }

  void dispose() {
    versionController.dispose();
    platforms.dispose();
  }
}

// ─── Version card ───────────────────────────────────────────────────────────
class _VersionCard extends StatefulWidget {
  final _VersionEditState state;
  final bool showError;
  final bool canDelete;
  final VoidCallback onDelete;

  const _VersionCard({
    super.key,
    required this.state,
    required this.showError,
    required this.canDelete,
    required this.onDelete,
  });

  @override
  State<_VersionCard> createState() => _VersionCardState();
}

class _VersionCardState extends State<_VersionCard> {
  static const _allTypes = PlatformType.values;
  final Set<String> _expandedPlatformUids = {};

  @override
  void initState() {
    super.initState();
    widget.state.versionController.addListener(_listener);
    widget.state.platforms.addListener(_listener);
    for (final p in widget.state.platforms.value) {
      if (p.isActive) _expandedPlatformUids.add(p.uid);
    }
  }

  @override
  void dispose() {
    widget.state.versionController.removeListener(_listener);
    widget.state.platforms.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l;
    final platforms = widget.state.platforms.value;
    final activePlatforms =
        platforms.where((p) => p.isActive).toList();

    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(AppTokens.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTokens.s3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l.editProjectScreenVersionFieldTitle.toUpperCase(),
                      style: TextStyle(
                        color: t.textDim,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(width: AppTokens.s3),
                    SizedBox(
                      width: 160,
                      child: AppTextField(
                        controller: widget.state.versionController,
                        mono: true,
                        hintText: l.editProjectVersionPlaceholder,
                        errorText: widget.showError &&
                                widget.state.versionController.text.isEmpty
                            ? l.filledTextError(
                                l.editProjectScreenVersionFieldTitle)
                            : null,
                      ),
                    ),
                    const Spacer(),
                    if (widget.canDelete)
                      AppButton(
                        kind: AppButtonKind.ghost,
                        size: AppButtonSize.sm,
                        icon: AppIcons.trash,
                        tooltip: l.deleteVersionTooltip,
                        onPressed: widget.onDelete,
                      ),
                  ],
                ),
                const SizedBox(height: AppTokens.s3),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final type in _allTypes)
                      AppChip(
                        on: platforms.any(
                            (p) => p.type == type && p.isActive),
                        label: type.name,
                        icon: PlatformGlyphs.of(type),
                        onTap: () => _togglePlatform(type),
                      ),
                  ],
                ),
              ],
            ),
          ),
          for (final p in activePlatforms)
            _PlatformSection(
              key: ValueKey(p.uid),
              platform: p,
              expanded: _expandedPlatformUids.contains(p.uid),
              onToggleExpand: () => setState(() {
                if (_expandedPlatformUids.contains(p.uid)) {
                  _expandedPlatformUids.remove(p.uid);
                } else {
                  _expandedPlatformUids.add(p.uid);
                }
              }),
              onUpdatePlatform: (u) => _updatePlatform(p, u),
            ),
        ],
      ),
    );
  }

  void _togglePlatform(PlatformType type) {
    final list = List<Platform>.from(widget.state.platforms.value);
    final idx = list.indexWhere((p) => p.type == type);
    if (idx == -1) {
      final created = Platform(uid: UidUtils.v4, type: type, isActive: true);
      list.add(created);
      _expandedPlatformUids.add(created.uid);
    } else {
      final p = list[idx];
      if (p.isActive && !p.hasArtifacts) {
        // No artifacts and being deactivated → remove entirely.
        list.removeAt(idx);
        _expandedPlatformUids.remove(p.uid);
      } else {
        list[idx] = p.copyWith(isActive: !p.isActive);
        if (!p.isActive) _expandedPlatformUids.add(p.uid);
      }
    }
    widget.state.platforms.value = list;
  }

  void _updatePlatform(Platform old, Platform updated) {
    final list = List<Platform>.from(widget.state.platforms.value);
    final idx = list.indexOf(old);
    if (idx != -1) {
      list[idx] = updated;
      widget.state.platforms.value = list;
    }
  }
}

// ─── Platform section (artifacts) ───────────────────────────────────────────
class _PlatformSection extends StatelessWidget {
  final Platform platform;
  final bool expanded;
  final VoidCallback onToggleExpand;
  final ValueChanged<Platform> onUpdatePlatform;

  const _PlatformSection({
    super.key,
    required this.platform,
    required this.expanded,
    required this.onToggleExpand,
    required this.onUpdatePlatform,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l;

    return Container(
      decoration: BoxDecoration(
        color: t.surface2,
        border: Border(top: BorderSide(color: t.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggleExpand,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.s3, vertical: AppTokens.s2),
                child: Row(
                  children: [
                    Icon(
                      expanded
                          ? AppIcons.chevronDown
                          : AppIcons.chevronRight,
                      size: 14,
                      color: t.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Icon(PlatformGlyphs.of(platform.type),
                        size: 14, color: t.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      platform.name,
                      style: TextStyle(
                          color: t.text,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l.artifactsCountText(platform.artifacts.length),
                      style: TextStyle(color: t.textDim, fontSize: 11),
                    ),
                    const Spacer(),
                    AppButton(
                      kind: AppButtonKind.ghost,
                      size: AppButtonSize.sm,
                      icon: AppIcons.add,
                      label: l.addArtifactButtonTitle,
                      tooltip: l.platformListItemAddTooltip(platform.name),
                      onPressed: () => _onAddArtifacts(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded && platform.artifacts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppTokens.s3, 0, AppTokens.s3, AppTokens.s3),
              child: Column(
                children: [
                  for (final a in platform.artifacts)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: _ArtifactRow(
                        artifact: a,
                        onEdit: () => _onEditArtifact(context, a),
                        onRemove: () => _onRemoveArtifact(a),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onAddArtifacts(BuildContext context) async {
    final l = context.l;
    final res = await FilePickerDialog.pickSymbols(
        dialogTitle: l.platformSelectorEditDialogTitle);
    if (res == null || res.files.isEmpty) return;
    final paths = res.files
        .map((f) => f.path)
        .where((p) => p.isNotNullNorEmpty)
        .cast<String>();
    if (paths.isEmpty) return;
    final artifacts = List<Artifact>.from(platform.artifacts);
    for (final p in paths) {
      artifacts.add(Artifact(uid: UidUtils.v4, filePath: p));
    }
    onUpdatePlatform(platform.copyWith(artifacts: artifacts));
  }

  Future<void> _onEditArtifact(BuildContext context, Artifact artifact) async {
    final l = context.l;
    final res = await FilePickerDialog.pickSymbol(
        dialogTitle: l.platformSelectorDialogTitle);
    if (res == null || res.files.isEmpty) return;
    final newPath = res.files.first.path;
    if (!newPath.isNotNullNorEmpty) return;
    final artifacts = List<Artifact>.from(platform.artifacts);
    final i = artifacts.indexOf(artifact);
    if (i == -1) return;
    artifacts[i] = artifact.copyWith(filePath: newPath!);
    onUpdatePlatform(platform.copyWith(artifacts: artifacts));
  }

  void _onRemoveArtifact(Artifact artifact) {
    final artifacts = List<Artifact>.from(platform.artifacts)..remove(artifact);
    onUpdatePlatform(platform.copyWith(artifacts: artifacts));
  }
}

class _ArtifactRow extends StatelessWidget {
  final Artifact artifact;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _ArtifactRow({
    required this.artifact,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.s2, vertical: 6),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      ),
      child: Row(
        children: [
          Icon(AppIcons.file, size: 14, color: t.textMuted),
          const SizedBox(width: 8),
          Mono(artifact.filename, size: 11.5),
          const SizedBox(width: 8),
          Expanded(child: Mono(artifact.filePath, size: 11, dim: true)),
          AppButton(
            kind: AppButtonKind.ghost,
            size: AppButtonSize.sm,
            icon: AppIcons.edit,
            tooltip: context.l.replaceButtonTitle,
            onPressed: onEdit,
          ),
          AppButton(
            kind: AppButtonKind.ghost,
            size: AppButtonSize.sm,
            icon: AppIcons.trash,
            tooltip: context.l.removeButtonTitle,
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
