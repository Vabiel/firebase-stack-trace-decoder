import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/widgets/ui/icons.dart';
import 'package:firebase_stacktrace_decoder/widgets/ui/surfaces.dart';
import 'package:flutter/material.dart';

class AppMenuItem<T> {
  final T value;
  final String label;
  final IconData? icon;
  final String? shortcut;
  final bool danger;
  final bool divider;

  const AppMenuItem({
    required this.value,
    required this.label,
    this.icon,
    this.shortcut,
    this.danger = false,
  }) : divider = false;

  const AppMenuItem.divider()
      : value = null as T,
        label = '',
        icon = null,
        shortcut = null,
        danger = false,
        divider = true;
}

/// Popup menu launcher: shows a small floating menu on tap. Returns the
/// chosen item's value or null on dismiss.
Future<T?> showAppPopupMenu<T>({
  required BuildContext context,
  required Offset position,
  required List<AppMenuItem<T>> items,
}) async {
  final t = context.tokens;
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  return showMenu<T>(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromLTWH(position.dx, position.dy, 0, 0),
      Offset.zero & overlay.size,
    ),
    color: t.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTokens.radius),
      side: BorderSide(color: t.border),
    ),
    items: [
      for (final item in items)
        if (item.divider)
          PopupMenuDivider(height: 9)
        else
          PopupMenuItem<T>(
            value: item.value,
            padding: EdgeInsets.zero,
            height: 32,
            child: _MenuRow(
              icon: item.icon,
              label: item.label,
              shortcut: item.shortcut,
              danger: item.danger,
            ),
          ),
    ],
  );
}

class _MenuRow extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String? shortcut;
  final bool danger;
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.shortcut,
    required this.danger,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final fg = danger ? t.danger : t.text;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          if (icon != null) ...[
            Opacity(
                opacity: 0.7,
                child: Icon(icon, size: 14, color: fg)),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: fg, fontSize: 13),
            ),
          ),
          if (shortcut != null) ...[
            const SizedBox(width: 8),
            Kbd(shortcut!),
          ],
        ],
      ),
    );
  }
}

/// Convenience: an icon-only "•••" affordance that opens a menu of items
/// when clicked. The menu opens anchored to the trigger.
class AppMenuButton<T> extends StatelessWidget {
  final List<AppMenuItem<T>> items;
  final ValueChanged<T> onSelected;
  final IconData icon;
  final String? tooltip;

  const AppMenuButton({
    super.key,
    required this.items,
    required this.onSelected,
    this.icon = AppIcons.more,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final btn = Builder(builder: (ctx) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) async {
            final box = ctx.findRenderObject() as RenderBox;
            final offset = box.localToGlobal(box.size.bottomLeft(Offset.zero));
            final value = await showAppPopupMenu<T>(
              context: ctx,
              position: offset,
              items: items,
            );
            if (value != null) onSelected(value);
          },
          child: SizedBox(
            width: 22,
            height: 22,
            child: Icon(icon, size: 14, color: t.textMuted),
          ),
        ),
      );
    });
    return tooltip != null ? Tooltip(message: tooltip!, child: btn) : btn;
  }
}
