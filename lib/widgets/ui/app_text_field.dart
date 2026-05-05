import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/widgets/ui/icons.dart';
import 'package:flutter/material.dart';

/// Single-line text field rendered to spec: 30px tall, 6px radius, 1px border,
/// monospace toggle, optional prefix/suffix slots.
class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final bool mono;
  final bool autofocus;
  final IconData? prefixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.errorText,
    this.mono = false,
    this.autofocus = false,
    this.prefixIcon,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focus = FocusNode()..addListener(() => setState(() {}));

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final invalid = widget.errorText != null;
    final focused = _focus.hasFocus;
    final borderColor = invalid
        ? t.danger
        : (focused ? t.focus : t.border);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: AppTokens.motionFast,
          curve: AppTokens.motionCurve,
          height: AppTokens.controlH,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: t.surface,
            border: Border.all(color: borderColor, width: focused ? 1.5 : 1),
            borderRadius: BorderRadius.circular(AppTokens.radius),
          ),
          child: Row(
            children: [
              if (widget.prefixIcon != null) ...[
                Icon(widget.prefixIcon, size: 14, color: t.textDim),
                const SizedBox(width: 6),
              ] else if (widget.prefix != null) ...[
                widget.prefix!,
                const SizedBox(width: 6),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  autofocus: widget.autofocus,
                  onChanged: widget.onChanged,
                  onSubmitted:
                      widget.onSubmitted == null ? null : (_) => widget.onSubmitted!(),
                  style: TextStyle(
                    color: t.text,
                    fontSize: widget.mono ? 12 : 13,
                    fontFamily: widget.mono ? t.fontMono : t.fontUi,
                    height: 1.0,
                  ),
                  cursorColor: t.accent,
                  cursorWidth: 1.5,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: t.textDim,
                      fontSize: widget.mono ? 12 : 13,
                      fontFamily: widget.mono ? t.fontMono : t.fontUi,
                    ),
                  ),
                ),
              ),
              if (widget.suffix != null) ...[
                const SizedBox(width: 6),
                widget.suffix!,
              ],
            ],
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: TextStyle(color: t.danger, fontSize: 12),
          ),
        ],
      ],
    );
  }
}

/// Multi-line monospace text area for stack-trace input.
class AppTextArea extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int minLines;
  final int? maxLines;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const AppTextArea({
    super.key,
    this.controller,
    this.hintText,
    this.minLines = 5,
    this.maxLines,
    this.readOnly = false,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      decoration: BoxDecoration(
        color: t.codeBg,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(AppTokens.radius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        readOnly: readOnly,
        onChanged: onChanged,
        minLines: minLines,
        maxLines: maxLines,
        cursorColor: t.accent,
        cursorWidth: 1.5,
        style: TextStyle(
          color: t.codeText,
          fontFamily: t.fontMono,
          fontSize: 11.5,
          height: AppTokens.lhCode,
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: t.textDim,
            fontFamily: t.fontMono,
            fontSize: 11.5,
          ),
        ),
      ),
    );
  }
}

/// Looks like a select / combobox trigger. Doesn't manage its own menu —
/// callers wire up tap to show their own popup.
class AppDropdownButton extends StatelessWidget {
  final String value;
  final IconData? prefixIcon;
  final VoidCallback? onPressed;
  final double? width;

  const AppDropdownButton({
    super.key,
    required this.value,
    this.prefixIcon,
    this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: AppTokens.controlH,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: t.surface,
            border: Border.all(color: t.border),
            borderRadius: BorderRadius.circular(AppTokens.radius),
          ),
          child: Row(
            mainAxisSize: width == null ? MainAxisSize.min : MainAxisSize.max,
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: 14, color: t.textDim),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: t.text, fontSize: 13, fontFamily: t.fontUi),
                ),
              ),
              const SizedBox(width: 6),
              Icon(AppIcons.chevronDown, size: 14, color: t.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
