import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:flutter/material.dart';

/// Themed radio matching the design (1.5px ring, accent fill when checked).
class AppRadio extends StatelessWidget {
  final bool checked;
  final String? label;
  final VoidCallback? onTap;

  const AppRadio({
    super.key,
    required this.checked,
    this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final disabled = onTap == null;

    return MouseRegion(
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Opacity(
          opacity: disabled ? 0.5 : 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: AppTokens.motionFast,
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: t.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: checked ? t.accent : t.borderStrong,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: AppTokens.motionFast,
                    width: checked ? 6 : 0,
                    height: checked ? 6 : 0,
                    decoration:
                        BoxDecoration(color: t.accent, shape: BoxShape.circle),
                  ),
                ),
              ),
              if (label != null) ...[
                const SizedBox(width: 8),
                Text(label!,
                    style: TextStyle(color: t.text, fontSize: 13)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AppCheckbox extends StatelessWidget {
  final bool checked;
  final String? label;
  final VoidCallback? onTap;

  const AppCheckbox({
    super.key,
    required this.checked,
    this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final disabled = onTap == null;
    return MouseRegion(
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Opacity(
          opacity: disabled ? 0.5 : 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: AppTokens.motionFast,
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: checked ? t.accent : t.surface,
                  border: Border.all(
                    color: checked ? t.accent : t.borderStrong,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(AppTokens.radiusSm),
                ),
                child: checked
                    ? Icon(Icons.check_rounded,
                        size: 11, color: t.textOnAccent)
                    : null,
              ),
              if (label != null) ...[
                const SizedBox(width: 8),
                Text(label!, style: TextStyle(color: t.text, fontSize: 13)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Toggle pill — used for the platform selector chips on the Edit Project
/// screen. When [on], paints with accent background.
class AppChip extends StatefulWidget {
  final bool on;
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool small;

  const AppChip({
    super.key,
    required this.on,
    required this.label,
    this.icon,
    this.onTap,
    this.small = false,
  });

  @override
  State<AppChip> createState() => _AppChipState();
}

class _AppChipState extends State<AppChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final h = widget.small ? 24.0 : 28.0;
    final fg = widget.on ? t.textOnAccent : t.text;
    final bg = widget.on
        ? t.accent
        : (_hover ? t.surface2 : t.surface);
    final border = widget.on ? t.accent : t.border;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppTokens.motionFast,
          curve: AppTokens.motionCurve,
          height: h,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(AppTokens.radius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Opacity(
                  opacity: widget.on ? 1.0 : 0.65,
                  child: Icon(widget.icon, size: 12, color: fg),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: fg,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.05,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Segmented control (e.g. "Drag & drop / Manual paste"). Reusable for any
/// 2+ option toggle.
class SegmentedToggle<T> extends StatelessWidget {
  final List<({T value, String label})> options;
  final T selected;
  final ValueChanged<T> onChanged;

  const SegmentedToggle({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: t.surface2,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(AppTokens.radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final o in options)
            _SegmentButton(
              label: o.label,
              active: o.value == selected,
              onTap: () => onChanged(o.value),
            ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _SegmentButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppTokens.motionFast,
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: active ? t.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTokens.radiusSm),
            boxShadow: active ? t.shadow1 : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? t.text : t.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
