import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/blocs/screens/decode_result/decode_result_bloc.dart';
import 'package:firebase_stacktrace_decoder/dialogs/app_dialog/app_dialog.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/widgets/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DecodeResultScreen extends StatefulWidget {
  final List<DecodeResult> decodeList;

  const DecodeResultScreen({super.key, this.decodeList = const []});

  @override
  State<DecodeResultScreen> createState() => _DecodeResultScreenState();
}

class _DecodeResultScreenState extends State<DecodeResultScreen> {
  late final _bloc = DecodeResultBloc(Get.find())..shown();
  late final List<bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded =
        List.generate(widget.decodeList.length, (i) => i == 0);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = context.tokens;
    return BlocListener<DecodeResultBloc, DecodeResultState>(
      bloc: _bloc,
      listener: (context, state) async {
        context.loaderOverlay.hide();
        if (state is DecodeResultSaveInProcess) {
          context.loaderOverlay.show();
        } else if (state is DecodeResultSaveSuccess) {
          await launchUrlString('file:${state.folderPath}');
        } else if (state is DecodeResultSaveFailed) {
          await AppDialog.showAlert(context,
              content: l.saveDecodeResultErrorText);
        }
      },
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTokens.s4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < widget.decodeList.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppTokens.s2),
                    _ResultBlock(
                      result: widget.decodeList[i],
                      expanded: _expanded[i],
                      onToggle: () =>
                          setState(() => _expanded[i] = !_expanded[i]),
                      onSave: () => _bloc.saveFile(widget.decodeList[i]),
                    ),
                  ],
                ],
              ),
            ),
          ),
          _buildFooter(context, l, t),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, AppLocalizations l, AppTokens t) {
    final count = widget.decodeList.length;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.s4, vertical: AppTokens.s3),
      decoration: BoxDecoration(
        color: t.surface2,
        border: Border(top: BorderSide(color: t.divider)),
      ),
      child: Row(
        children: [
          Text(
            '$count of $count decoded',
            style: TextStyle(color: t.textMuted, fontSize: 12),
          ),
          const Spacer(),
          AppButton(
            kind: AppButtonKind.ghost,
            label: 'Close',
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: AppTokens.s2),
          if (count > 1)
            AppButton(
              kind: AppButtonKind.secondary,
              icon: AppIcons.folder,
              label: l.decodeResultScreenSaveAllTitle,
              onPressed: () => _bloc.saveAllFiles(widget.decodeList),
            ),
        ],
      ),
    );
  }
}

class _ResultBlock extends StatelessWidget {
  final DecodeResult result;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onSave;

  const _ResultBlock({
    required this.result,
    required this.expanded,
    required this.onToggle,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final lineCount = '\n'.allMatches(result.result).length + 1;
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(AppTokens.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggle,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppTokens.s3, vertical: 8),
                decoration: BoxDecoration(
                  border: expanded
                      ? Border(bottom: BorderSide(color: t.divider))
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      expanded
                          ? AppIcons.chevronDown
                          : AppIcons.chevronRight,
                      size: 14,
                      color: t.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Icon(AppIcons.file, size: 14, color: t.textMuted),
                    const SizedBox(width: 8),
                    Flexible(child: Mono(result.filename, size: 12)),
                    const SizedBox(width: 8),
                    _ModeBadge(mode: result.mode),
                    const SizedBox(width: 8),
                    Text(
                      '$lineCount lines',
                      style: TextStyle(color: t.textDim, fontSize: 11),
                    ),
                    const Spacer(),
                    AppButton(
                      kind: AppButtonKind.ghost,
                      size: AppButtonSize.sm,
                      icon: AppIcons.copy,
                      label: 'Copy',
                      onPressed: () => Clipboard.setData(
                          ClipboardData(text: result.result)),
                    ),
                    const SizedBox(width: 4),
                    AppButton(
                      kind: AppButtonKind.secondary,
                      size: AppButtonSize.sm,
                      icon: AppIcons.save,
                      label: 'Save',
                      onPressed: onSave,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded)
            CodeBlock(
              text: result.result,
              height: 280,
              borderRadius: BorderRadius.zero,
              border: const Border(),
            ),
        ],
      ),
    );
  }
}

class _ModeBadge extends StatelessWidget {
  final DecodeMode mode;
  const _ModeBadge({required this.mode});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final label = mode.isManual ? 'manual' : 'drag-n-drop';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: t.surface2,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: t.textMuted,
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
