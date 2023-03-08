import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:firebase_stacktrace_decoder/application/localization.dart';
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

  const EditProjectScreen({Key? key, this.project}) : super(key: key);

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _versionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final PlatformListController _platformListController;
  late final EditProjectBloc _editProjectBloc;
  var _isSavePressed = false;
  String? _preview;

  @override
  void initState() {
    super.initState();
    final project = widget.project;
    final hasSomePlatforms = project != null && project.hasPlatforms;
    _preview = project?.preview;
    _editProjectBloc = EditProjectBloc(
      projectLocalProvider: Get.find(),
      input: project,
    );
    _nameController.text = project?.name ?? '';
    _versionController.text = project?.version ?? '';
    _platformListController = PlatformListController(
        hasSomePlatforms ? List<Platform>.from(project.platforms) : []);
    _nameController.addListener(_textListener);
    _versionController.addListener(_textListener);
  }

  @override
  void dispose() {
    _nameController.removeListener(_textListener);
    _versionController.removeListener(_textListener);
    _nameController.dispose();
    _versionController.dispose();
    _platformListController.dispose();
    _scrollController.dispose();
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
            _buildPlatformList(l),
            _buildBottomPanel(context, l, project),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformList(AppLocalizations l) {
    return Expanded(
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PlatformList(
              controller: _platformListController,
              headerBuilder: (context) {
                return Row(
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTextField(
                            _nameController,
                            l,
                            label: l.editProjectScreenNameFieldTitle,
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(
                            _versionController,
                            l,
                            label: l.editProjectScreenVersionFieldTitle,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
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
    return Flexible(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            label: Text(label),
            border: const OutlineInputBorder(),
            errorText: canShowError ? errorText : null),
      ),
    );
  }

  Future<void> _onDeletePressed(BuildContext context) async {
    final l = context.l;
    final res = await AppDialog.showConfirm(context,
        title: l.deleteProjectDialogTitle, content: l.deleteProjectDialogText);
    if (res) {
      final project = widget.project;
      if (project != null) {
        final projectUid = project.uid;
        _editProjectBloc.deleteProject(projectUid);
      }
    }
  }

  void _onSavePressed(BuildContext context) {
    if (_nameController.text.isNotEmpty && _versionController.text.isNotEmpty) {
      final name = _nameController.text;
      final version = _versionController.text;
      final platforms = _platformListController.platforms;
      _editProjectBloc.saveProject(
          name: name,
          version: version,
          platforms: platforms,
          preview: _preview);
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
