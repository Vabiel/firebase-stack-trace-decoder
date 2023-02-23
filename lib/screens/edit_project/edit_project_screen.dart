import 'dart:io' as io;

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/dialogs/confirm_dialog/confirm_dialog.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/widgets/platform_selector/platform_list.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    final project = widget.project;

    final hasSomePlatforms = project != null && project.hasPlatforms;
    _platformListController = PlatformListController(
        hasSomePlatforms ? List<Platform>.from(project.platforms) : []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _versionController.dispose();
    _platformListController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const aspectRatio = 4 / 3;
    final l = context.l;
    final project = widget.project;
    final isWindows = io.Platform.isWindows;
    final title = project != null
        ? l.editProjectScreenEditTitle
        : l.editProjectScreenNewTitle;
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          automaticallyImplyLeading: false,
          leading: !isWindows ? _buildCloseButton(context) : null,
          actions: isWindows
              ? [_buildCloseButton(context, withPadding: true)]
              : null,
        ),
        body: Column(
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
                  children: [
                    _buildTextField(_nameController,
                        label: l.editProjectScreenNameFieldTitle),
                    const SizedBox(width: 8),
                    _buildTextField(_versionController,
                        label: l.editProjectScreenVersionFieldTitle),
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
    return SizedBox(
      height: 56,
      child: SingleChildScrollView(
        child: Row(
          children: [
            const SizedBox(width: 8),
            if (project != null)
              _buildElevatedButton(
                backgroundColor: Colors.red,
                onPressed: () => _onDeletePressed(context),
                title: l.editProjectScreenDeleteButtonTitle,
              ),
            const Spacer(),
            _buildElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              title: l.editProjectScreenCancelButtonTitle,
            ),
            const SizedBox(width: 8),
            _buildElevatedButton(
              backgroundColor: Colors.green,
              onPressed: () => _onSavePressed(context),
              title: l.editProjectScreenSaveButtonTitle,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton(
    BuildContext context, {
    bool withPadding = false,
  }) {
    final l = context.l;
    return Padding(
      padding: withPadding ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
      child: IconButton(
        icon: const Icon(Icons.close),
        hoverColor: Colors.red,
        splashRadius: 20,
        onPressed: () => Navigator.of(context).pop(),
        tooltip: l.editProjectScreenCloseToolTip,
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

  Widget _buildTextField(TextEditingController controller,
      {required String label}) {
    // TODO: validate if empty before save
    return Flexible(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          label: Text(label),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _onDeletePressed(BuildContext context) async {
    final l = context.l;
    final res = await ConfirmDialog.show(context,
        title: l.deleteProjectDialogTitle, content: l.deleteProjectDialogText);
    if (res) {}
  }

  void _onSavePressed(BuildContext context) {}
}
