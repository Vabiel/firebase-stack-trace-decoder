import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/widgets/ui/ui.dart';
import 'package:flutter/material.dart';

class AppDialog {
  AppDialog._();

  static Future<bool> showConfirm(
    BuildContext context, {
    required String title,
    required String content,
    String? positiveBtnTitle,
    String? negativeBtnTitle,
    bool danger = true,
  }) async {
    final l = context.l;
    final res = await showAppDialog<bool>(
      context: context,
      builder: (ctx) => AppDialogFrame(
        title: title,
        width: 420,
        danger: danger,
        onClose: () => Navigator.of(ctx).pop(false),
        footer: [
          const Spacer(),
          AppButton(
            kind: AppButtonKind.ghost,
            label: negativeBtnTitle ?? l.cancelButtonTitle,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          AppButton(
            kind: danger ? AppButtonKind.destructive : AppButtonKind.primary,
            label: positiveBtnTitle ?? l.yesButtonTitle,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
        child: _DialogText(content),
      ),
    );
    return res ?? false;
  }

  static Future<void> showAlert(
    BuildContext context, {
    required String content,
    String? title,
    bool danger = false,
  }) async {
    final l = context.l;
    await showAppDialog<void>(
      context: context,
      builder: (ctx) => AppDialogFrame(
        title: title ?? l.decodeDialogErrorTitle,
        width: 420,
        danger: danger,
        onClose: () => Navigator.of(ctx).pop(),
        footer: [
          const Spacer(),
          AppButton(
            kind: AppButtonKind.primary,
            label: 'OK',
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
        child: _DialogText(content),
      ),
    );
  }

  /// Shows a wide modal that hosts a custom screen body. The body manages its
  /// own footer / scroll / form state — this wrapper only provides chrome.
  static Future<Object?> showForm(
    BuildContext context, {
    required String title,
    required Widget body,
    double width = 720,
    double height = 560,
  }) {
    final t = context.tokens;
    return showGeneralDialog<Object?>(
      context: context,
      barrierColor: t.overlay,
      barrierDismissible: true,
      barrierLabel: title,
      pageBuilder: (_, __, ___) => _FormFrame(
          title: title, body: body, width: width, height: height),
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween(begin: 0.97, end: 1.0)
                .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 180),
    );
  }
}

class _DialogText extends StatelessWidget {
  final String text;
  const _DialogText(this.text);
  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Text(
      text,
      style: TextStyle(color: t.text, fontSize: 13, height: 1.5),
    );
  }
}

class _FormFrame extends StatelessWidget {
  final String title;
  final Widget body;
  final double width;
  final double height;
  const _FormFrame(
      {required this.title,
      required this.body,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
          maxHeight: height,
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: t.surface,
              border: Border.all(color: t.border),
              borderRadius: BorderRadius.circular(AppTokens.radius),
              boxShadow: t.shadow3,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTokens.radius),
              child: Column(
                children: [
                  _FormHeader(title: title),
                  Expanded(child: body),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormHeader extends StatelessWidget {
  final String title;
  const _FormHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.s4, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: t.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: t.text,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.1,
              ),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: SizedBox(
                width: 24,
                height: 24,
                child: Icon(AppIcons.close, size: 14, color: t.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
