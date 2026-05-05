import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/application/uid_utils.dart';
import 'package:firebase_stacktrace_decoder/blocs/screens/edit_project/edit_project_bloc.dart';
import 'package:firebase_stacktrace_decoder/dialogs/app_dialog/app_dialog.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/widgets/platform_selector/platform_list.dart';
import 'package:firebase_stacktrace_decoder/widgets/preview_selector/preview_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class EditProjectScreen extends StatefulWidget {
  final Project? project;

  const EditProjectScreen({super.key, this.project});

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_VersionEditorState> _versionStates = [];
  late final EditProjectBloc _editProjectBloc;
  var _isSavePressed = false;
  String? _preview;

  @override
  void initState() {
    super.initState();
    final project = widget.project;
    _preview = project?.preview;
    _editProjectBloc = EditProjectBloc(
      projectLocalProvider: Get.find(),
      input: project,
    );
    _nameController.text = project?.name ?? '';
    _nameController.addListener(_textListener);

    final initialVersions = project?.versions ?? const <ProjectVersion>[];
    if (initialVersions.isEmpty) {
      _versionStates.add(_VersionEditorState.empty());
    } else {
      for (final v in initialVersions) {
        _versionStates.add(_VersionEditorState.fromVersion(v));
      }
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_textListener);
    _nameController.dispose();
    _scrollController.dispose();
    for (final v in _versionStates) {
      v.dispose();
    }
    _editProjectBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final project = widget.project;
    return BlocListener<EditProjectBloc, EditProjectState>(
      bloc: _editProjectBloc,
      listener: (context, state) async {
        final l = context.l;
        if (state is EditProjectActionComplete) {
          final result = state.result;
          switch (result) {
            case ActionResult.saveSuccess:
            case ActionResult.deleteSuccess:
              Navigator.of(context).pop(result);
              break;
            case ActionResult.saveFailed:
              await _showAlertDialog(context, l.saveProjectErrorText);
              break;
            case ActionResult.deleteFailed:
              await _showAlertDialog(context, l.deleteProjectErrorText);
              break;
          }
        }
      },
      child: ClipRect(
        child: Column(
          children: [
            _buildHeader(l),
            Expanded(child: _buildVersions(l)),
            _buildBottomPanel(context, l, project),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PreviewSelector(
            preview: _preview,
            onChange: (preview) {
              setState(() {
                _preview = preview;
              });
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTextField(
              _nameController,
              l,
              label: l.editProjectScreenNameFieldTitle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersions(AppLocalizations l) {
    return FadingEdgeScrollView.fromSingleChildScrollView(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              for (var i = 0; i < _versionStates.length; i++)
                _VersionEditor(
                  key: ValueKey(_versionStates[i].id),
                  state: _versionStates[i],
                  canDelete: _versionStates.length > 1,
                  showError: _isSavePressed,
                  onDelete: () => _onDeleteVersion(i),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: _onAddVersion,
                    icon: const Icon(Icons.add),
                    label: Text(l.addVersionButtonTitle),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel(
      BuildContext context, AppLocalizations l, Project? project) {
    return ClipRect(
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            const SizedBox(width: 8),
            if (project != null)
              _buildElevatedButton(
                backgroundColor: Colors.red,
                onPressed: () => _onDeletePressed(context),
                title: l.deleteButtonTitle,
              ),
            const Spacer(),
            _buildElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              title: l.cancelButtonTitle,
            ),
            const SizedBox(width: 8),
            _buildElevatedButton(
              backgroundColor: Colors.green,
              onPressed: () => _onSavePressed(context),
              title: l.saveButtonTitle,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildElevatedButton({
    required String title,
    Color? backgroundColor,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        minimumSize: const Size(120, 40),
        backgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    AppLocalizations l, {
    required String label,
  }) {
    final bool canShowError = _isSavePressed && controller.text.isEmpty;
    final errorText = l.filledTextError(label);
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        border: const OutlineInputBorder(),
        errorText: canShowError ? errorText : null,
      ),
    );
  }

  void _onAddVersion() {
    setState(() {
      _versionStates.add(_VersionEditorState.empty());
    });
  }

  void _onDeleteVersion(int index) {
    setState(() {
      _versionStates.removeAt(index).dispose();
    });
  }

  Future<void> _onDeletePressed(BuildContext context) async {
    final l = context.l;
    final res = await AppDialog.showConfirm(context,
        title: l.deleteProjectDialogTitle, content: l.deleteProjectDialogText);
    if (res) {
      final project = widget.project;
      if (project != null) {
        _editProjectBloc.deleteProject(project.uid);
      }
    }
  }

  void _onSavePressed(BuildContext context) {
    final hasName = _nameController.text.isNotEmpty;
    final allVersionsValid =
        _versionStates.every((v) => v.versionController.text.isNotEmpty);
    if (hasName && allVersionsValid) {
      final versions = [
        for (final state in _versionStates) state.toModel(),
      ];
      _editProjectBloc.saveProject(
        name: _nameController.text,
        versions: versions,
        preview: _preview,
      );
    } else {
      setState(() {
        _isSavePressed = true;
      });
    }
  }

  void _textListener() {
    if (_isSavePressed) {
      setState(() {});
    }
  }

  Future<void> _showAlertDialog(BuildContext context, String content) {
    return AppDialog.showAlert(context, content: content);
  }
}

class _VersionEditorState {
  final String id;
  final String? existingUid;
  final TextEditingController versionController;
  final PlatformListController platformListController;

  _VersionEditorState._({
    required this.id,
    required this.existingUid,
    required this.versionController,
    required this.platformListController,
  });

  factory _VersionEditorState.empty() {
    return _VersionEditorState._(
      id: UidUtils.v4,
      existingUid: null,
      versionController: TextEditingController(),
      platformListController: PlatformListController([]),
    );
  }

  factory _VersionEditorState.fromVersion(ProjectVersion v) {
    return _VersionEditorState._(
      id: v.uid,
      existingUid: v.uid,
      versionController: TextEditingController(text: v.version),
      platformListController:
          PlatformListController(List<Platform>.from(v.platforms)),
    );
  }

  ProjectVersion toModel() {
    return ProjectVersion(
      uid: existingUid ?? UidUtils.v4,
      version: versionController.text,
      platforms: platformListController.platforms,
    );
  }

  void dispose() {
    versionController.dispose();
    platformListController.dispose();
  }
}

class _VersionEditor extends StatefulWidget {
  final _VersionEditorState state;
  final bool canDelete;
  final bool showError;
  final VoidCallback onDelete;

  const _VersionEditor({
    super.key,
    required this.state,
    required this.canDelete,
    required this.showError,
    required this.onDelete,
  });

  @override
  State<_VersionEditor> createState() => _VersionEditorWidgetState();
}

class _VersionEditorWidgetState extends State<_VersionEditor> {
  @override
  void initState() {
    super.initState();
    widget.state.versionController.addListener(_listener);
  }

  @override
  void dispose() {
    widget.state.versionController.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    if (widget.showError) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: PlatformList(
          controller: widget.state.platformListController,
          headerBuilder: (context) {
            final canShowError =
                widget.showError && widget.state.versionController.text.isEmpty;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.state.versionController,
                    decoration: InputDecoration(
                      label: Text(l.editProjectScreenVersionFieldTitle),
                      border: const OutlineInputBorder(),
                      errorText: canShowError
                          ? l.filledTextError(
                              l.editProjectScreenVersionFieldTitle)
                          : null,
                    ),
                  ),
                ),
                if (widget.canDelete)
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    tooltip: l.deleteVersionTooltip,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
