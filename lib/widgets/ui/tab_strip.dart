import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/widgets/ui/icons.dart';
import 'package:flutter/material.dart';

class AppTab<T> {
  final T id;
  final String title;
  final IconData? icon;
  const AppTab({required this.id, required this.title, this.icon});
}

/// Xcode-style tab bar with a 2px accent underline on the active tab.
/// Each tab has its own close button. Optional trailing "+" affordance.
class TabStrip<T> extends StatelessWidget {
  final List<AppTab<T>> tabs;
  final T? activeId;
  final ValueChanged<T>? onSelect;
  final ValueChanged<T>? onClose;
  final VoidCallback? onNew;

  const TabStrip({
    super.key,
    required this.tabs,
    required this.activeId,
    this.onSelect,
    this.onClose,
    this.onNew,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: t.bg,
        border: Border(bottom: BorderSide(color: t.border)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          for (final tab in tabs)
            _TabItem<T>(
              tab: tab,
              active: tab.id == activeId,
              onSelect: onSelect,
              onClose: onClose,
            ),
          if (onNew != null)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onNew,
                child: SizedBox(
                  width: 32,
                  height: 36,
                  child: Icon(AppIcons.add, size: 14, color: t.textMuted),
                ),
              ),
            ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}

class _TabItem<T> extends StatefulWidget {
  final AppTab<T> tab;
  final bool active;
  final ValueChanged<T>? onSelect;
  final ValueChanged<T>? onClose;

  const _TabItem({
    required this.tab,
    required this.active,
    required this.onSelect,
    required this.onClose,
  });

  @override
  State<_TabItem<T>> createState() => _TabItemState<T>();
}

class _TabItemState<T> extends State<_TabItem<T>> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => widget.onSelect?.call(widget.tab.id),
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 260),
              padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
              decoration: BoxDecoration(
                color: widget.active
                    ? t.surface
                    : (_hover ? t.surface2 : Colors.transparent),
                border: Border(right: BorderSide(color: t.border)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.tab.icon != null) ...[
                    Opacity(
                      opacity: 0.85,
                      child: Icon(widget.tab.icon,
                          size: 12,
                          color: widget.active ? t.text : t.textMuted),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      widget.tab.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.active ? t.text : t.textMuted,
                        fontSize: 12.5,
                        fontWeight:
                            widget.active ? FontWeight.w500 : FontWeight.w400,
                        letterSpacing: -0.05,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (widget.onClose != null)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => widget.onClose!(widget.tab.id),
                      child: Opacity(
                        opacity: widget.active ? 0.8 : 0.5,
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: Icon(AppIcons.close,
                              size: 12, color: t.textMuted),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (widget.active)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(height: 2, color: t.accent),
              ),
          ],
        ),
      ),
    );
  }
}
