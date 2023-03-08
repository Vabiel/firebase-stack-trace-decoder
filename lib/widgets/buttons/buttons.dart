import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:flutter/material.dart';

class CloseBtn extends StatelessWidget {
  final VoidCallback? onPressed;

  const CloseBtn({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return ActionIconButton(
      hoverColor: Colors.red,
      icon: Icons.close,
      tooltip: l.editProjectScreenCloseToolTip,
      onPressed: onPressed,
    );
  }
}

class AddButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String tooltip;

  const AddButton({
    Key? key,
    this.onPressed,
    required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionIconButton(
      iconColor: Colors.green,
      icon: Icons.add_circle,
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}

class ActionIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? iconColor;
  final Color? hoverColor;

  const ActionIconButton({
    Key? key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.iconColor,
    this.hoverColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: iconColor,
      hoverColor: hoverColor,
      splashRadius: 20,
      onPressed: onPressed,
      icon: Icon(icon),
      tooltip: tooltip,
    );
  }
}
