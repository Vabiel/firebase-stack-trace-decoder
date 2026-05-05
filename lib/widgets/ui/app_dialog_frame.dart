import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/widgets/ui/icons.dart';
import 'package:flutter/material.dart';

/// Standard dialog chrome: title bar (with optional danger glyph + close
/// button), scrollable body, optional footer with subtle surface2 fill.
class AppDialogFrame extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? footer;
  final double width;
  final bool danger;
  final VoidCallback? onClose;

  const AppDialogFrame({
    super.key,
    required this.title,
    required this.child,
    this.footer,
    this.width = 560,
    this.danger = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(t),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(child: child),
                  ),
                ),
                if (footer != null) _buildFooter(t),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildHeader(AppTokens t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: t.divider)),
      ),
      child: Row(
        children: [
          if (danger) ...[
            Icon(AppIcons.warning, size: 14, color: t.danger),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: t.text,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.1,
                height: 1.2,
              ),
            ),
          ),
          if (onClose != null)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onClose,
                behavior: HitTestBehavior.opaque,
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

  Widget _buildFooter(AppTokens t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: t.surface2,
        border: Border(top: BorderSide(color: t.divider)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < footer!.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            footer![i],
          ],
        ],
      ),
    );
  }
}

/// Helper: wraps a dialog body in a barrier matching design tokens.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool barrierDismissible = true,
}) {
  final t = context.tokens;
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: t.overlay,
    builder: builder,
  );
}
