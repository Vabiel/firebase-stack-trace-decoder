import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/dialogs/file_picker_dialog/file_picker_dialog.dart';
import 'package:firebase_stacktrace_decoder/widgets/project_preview/project_preview.dart';
import 'package:flutter/material.dart';

class PreviewSelector extends StatefulWidget {
  final String? preview;
  final ValueChanged<String?> onChange;

  const PreviewSelector({
    Key? key,
    this.preview,
    required this.onChange,
  }) : super(key: key);

  @override
  State<PreviewSelector> createState() => _PreviewSelectorState();
}

class _PreviewSelectorState extends State<PreviewSelector> {
  static const double _previewSize = 96;

  String? _preview;

  @override
  void initState() {
    super.initState();
    _preview = widget.preview;
  }

  @override
  Widget build(BuildContext context) {
    return _buildSelector(context, _preview);
  }

  Widget _buildPicker(BuildContext context) {
    const borderColor = AppTheme.borderColor;
    final l = context.l;
    return SizedBox.square(
      dimension: _previewSize,
      child: DottedBorder(
        color: borderColor,
        strokeWidth: 3,
        dashPattern: const [5, 2.5],
        child: Center(
          child: Text(
            l.previewSelectorTitle,
            style: const TextStyle(color: borderColor),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(String preview) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ProjectPreview(
          preview: preview,
          previewSize: _previewSize,
        ),
        Positioned(
          right: -5,
          bottom: -5,
          child: _buildEditButton(),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return GestureDetector(
      onTap: _changePreview,
      child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.black)),
          child: const Icon(Icons.edit)),
    );
  }

  Widget _buildSelector(BuildContext context, String? preview) {
    final l = context.l;
    final hasPreview = preview != null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        hasPreview ? _buildPreview(preview) : _buildPicker(context),
        TextButton(
          onPressed: hasPreview ? _deletePreview : _changePreview,
          style: TextButton.styleFrom(
              foregroundColor: hasPreview ? Colors.red : Colors.green),
          child: Text(hasPreview ? l.deleteButtonTitle : l.addButtonTitle),
        )
      ],
    );
  }

  Future<void> _changePreview() async {
    final l = context.l;
    final res = await FilePickerDialog.pickImage(
        dialogTitle: l.previewSelectorDialogTitle);
    if (res != null) {
      setState(() {
        _preview = res.path;
        widget.onChange(_preview);
      });
    }
  }

  void _deletePreview() {
    setState(() {
      _preview = null;
      widget.onChange(_preview);
    });
  }
}
