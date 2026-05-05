import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:flutter/material.dart';

/// Plain surface card with 1px border and 6px radius.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.color,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? t.surface,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(AppTokens.radius),
      ),
      child: child,
    );
  }
}

/// 1px vertical line acting as a splitter handle. Wider hit-area via
/// MouseRegion + GestureDetector. Used inside [MultiSplitView] dividers.
class AppSplitter extends StatelessWidget {
  final Axis axis;
  const AppSplitter({super.key, this.axis = Axis.vertical});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final cursor = axis == Axis.vertical
        ? SystemMouseCursors.resizeColumn
        : SystemMouseCursors.resizeRow;
    return MouseRegion(
      cursor: cursor,
      child: Container(
        width: axis == Axis.vertical ? 1 : null,
        height: axis == Axis.horizontal ? 1 : null,
        color: t.border,
      ),
    );
  }
}

/// Subtle divider line.
class AppDivider extends StatelessWidget {
  final Axis axis;
  const AppDivider({super.key, this.axis = Axis.horizontal});
  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      width: axis == Axis.vertical ? 1 : null,
      height: axis == Axis.horizontal ? 1 : null,
      color: t.divider,
    );
  }
}

/// Uppercase mini-label used for section headers ("VERSIONS", "MY PROJECTS",
/// "SYMBOLS"). Optional trailing widget (e.g. "Add" button) and a hairline
/// fill that consumes leftover horizontal space.
class SectionLabel extends StatelessWidget {
  final String text;
  final Widget? trailing;
  final bool drawLine;
  final EdgeInsetsGeometry padding;

  const SectionLabel({
    super.key,
    required this.text,
    this.trailing,
    this.drawLine = true,
    this.padding = const EdgeInsets.only(bottom: 8),
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Text(
            text.toUpperCase(),
            style: TextStyle(
              color: t.textDim,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
          if (drawLine) ...[
            const SizedBox(width: 8),
            Expanded(child: Container(height: 1, color: t.divider)),
          ],
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Inline monospace text — used for filenames, paths, version labels.
class Mono extends StatelessWidget {
  final String text;
  final bool dim;
  final double size;
  final TextOverflow overflow;
  const Mono(
    this.text, {
    super.key,
    this.dim = false,
    this.size = 11.5,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Text(
      text,
      maxLines: 1,
      overflow: overflow,
      softWrap: false,
      style: TextStyle(
        color: dim ? t.textMuted : t.text,
        fontFamily: t.fontMono,
        fontSize: size,
        height: 1.2,
      ),
    );
  }
}

/// Tiny keyboard-cap glyph used in empty states and popup-menu shortcuts.
class Kbd extends StatelessWidget {
  final String label;
  const Kbd(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      constraints: const BoxConstraints(minWidth: 18),
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(
          top: BorderSide(color: t.border),
          left: BorderSide(color: t.border),
          right: BorderSide(color: t.border),
          bottom: BorderSide(color: t.border, width: 1.5),
        ),
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: t.textMuted,
          fontFamily: t.fontMono,
          fontSize: 11,
          height: 1.0,
        ),
      ),
    );
  }
}

/// Hoverable / selectable list row. Background swaps to surface2 on hover,
/// accentSoft + 1px border when selected.
class AppListRow extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final bool selected;
  final bool dim;
  final EdgeInsetsGeometry padding;

  const AppListRow({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.selected = false,
    this.dim = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  });

  @override
  State<AppListRow> createState() => _AppListRowState();
}

class _AppListRowState extends State<AppListRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final bg = widget.selected
        ? t.accentSoft
        : (_hover ? t.surface2 : Colors.transparent);
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onDoubleTap: widget.onDoubleTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: AppTokens.motionFast,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(
              color: widget.selected ? t.border : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(AppTokens.radius),
          ),
          child: Opacity(opacity: widget.dim ? 0.55 : 1, child: widget.child),
        ),
      ),
    );
  }
}
