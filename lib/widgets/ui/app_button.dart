import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:flutter/material.dart';

enum AppButtonKind {
  primary,
  secondary,
  ghost,
  destructive,
  destructiveSecondary,
}

enum AppButtonSize { sm, md, lg }

/// Single button widget covering all kinds and sizes used throughout the app.
/// Replaces ad-hoc `ElevatedButton.styleFrom(…)` callers.
class AppButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final IconData? iconRight;
  final AppButtonKind kind;
  final AppButtonSize size;
  final VoidCallback? onPressed;
  final bool busy;
  final String? tooltip;

  const AppButton({
    super.key,
    this.label,
    this.icon,
    this.iconRight,
    this.kind = AppButtonKind.secondary,
    this.size = AppButtonSize.md,
    this.onPressed,
    this.busy = false,
    this.tooltip,
  });

  /// Square icon-only button (transparent, hover-tinted). For toolbar bits.
  const AppButton.iconOnly({
    super.key,
    required IconData this.icon,
    this.size = AppButtonSize.md,
    this.onPressed,
    this.tooltip,
  })  : label = null,
        iconRight = null,
        kind = AppButtonKind.ghost,
        busy = false;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final disabled = widget.onPressed == null;
    final h = _height(widget.size);
    final pad = _padding(widget.size, widget.label != null);
    final fontSize = widget.size == AppButtonSize.sm ? 12.0 : 13.0;

    final palette = _palette(t, widget.kind, _hover, _pressed);

    Widget child = AnimatedContainer(
      duration: AppTokens.motionFast,
      curve: AppTokens.motionCurve,
      height: h,
      padding: pad,
      constraints: BoxConstraints(
        minWidth: widget.label == null ? h : 0,
      ),
      decoration: BoxDecoration(
        color: palette.bg,
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(AppTokens.radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.busy)
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation(palette.fg),
              ),
            )
          else if (widget.icon != null)
            Icon(widget.icon, size: 14, color: palette.fg),
          if ((widget.icon != null || widget.busy) && widget.label != null)
            const SizedBox(width: 6),
          if (widget.label != null)
            Text(
              widget.label!,
              style: TextStyle(
                color: palette.fg,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.05,
                height: 1.0,
              ),
            ),
          if (widget.iconRight != null) ...[
            const SizedBox(width: 6),
            Icon(widget.iconRight, size: 14, color: palette.fg.withValues(alpha: 0.7)),
          ],
        ],
      ),
    );

    child = AnimatedOpacity(
      duration: AppTokens.motionFast,
      opacity: disabled ? 0.5 : 1,
      child: child,
    );

    final interactive = MouseRegion(
      cursor:
          disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
        onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
        onTapCancel: disabled ? null : () => setState(() => _pressed = false),
        onTap: disabled ? null : widget.onPressed,
        child: child,
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: interactive);
    }
    return interactive;
  }

  static double _height(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.sm:
        return AppTokens.controlHSm;
      case AppButtonSize.md:
        return AppTokens.controlH;
      case AppButtonSize.lg:
        return AppTokens.controlHLg;
    }
  }

  static EdgeInsets _padding(AppButtonSize size, bool hasLabel) {
    if (!hasLabel) return EdgeInsets.zero;
    switch (size) {
      case AppButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 10);
      case AppButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: 12);
      case AppButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 14);
    }
  }

  static _ButtonPalette _palette(
      AppTokens t, AppButtonKind kind, bool hover, bool pressed) {
    switch (kind) {
      case AppButtonKind.primary:
        return _ButtonPalette(
          bg: pressed
              ? t.accentHover
              : (hover ? t.accentHover : t.accent),
          fg: t.textOnAccent,
          border: t.accent,
        );
      case AppButtonKind.secondary:
        return _ButtonPalette(
          bg: hover ? t.surface2 : t.surface,
          fg: t.text,
          border: pressed ? t.borderStrong : t.border,
        );
      case AppButtonKind.ghost:
        return _ButtonPalette(
          bg: hover ? t.surface2 : Colors.transparent,
          fg: t.text,
          border: Colors.transparent,
        );
      case AppButtonKind.destructive:
        return _ButtonPalette(
          bg: t.danger,
          fg: Colors.white,
          border: t.danger,
        );
      case AppButtonKind.destructiveSecondary:
        return _ButtonPalette(
          bg: hover ? t.dangerSoft : t.surface,
          fg: t.danger,
          border: t.border,
        );
    }
  }
}

class _ButtonPalette {
  final Color bg;
  final Color fg;
  final Color border;
  const _ButtonPalette({required this.bg, required this.fg, required this.border});
}
