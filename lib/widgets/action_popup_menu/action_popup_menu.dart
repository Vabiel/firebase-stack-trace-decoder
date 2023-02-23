import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:flutter/material.dart';

class ActionPopupMenu extends StatelessWidget {
  final String? removeActionTitle;
  final String? editActionTitle;
  final VoidCallback onRemoveActionSelect;
  final VoidCallback onEditActionSelect;

  const ActionPopupMenu({
    Key? key,
    required this.onRemoveActionSelect,
    required this.onEditActionSelect,
    this.removeActionTitle,
    this.editActionTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPopupMenu(context);
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<PopupMenuAction>(
      splashRadius: 28,
      onSelected: (action) {
        switch (action) {
          case PopupMenuAction.edit:
            onEditActionSelect();
            break;
          case PopupMenuAction.remove:
            onRemoveActionSelect();
            break;
        }
      },
      icon: const Icon(Icons.more_vert_rounded),
      itemBuilder: (context) => <PopupMenuEntry<PopupMenuAction>>[
        for (final action in PopupMenuAction.values)
          _buildPopupMenuItem(context, action)
      ],
    );
  }

  PopupMenuItem<PopupMenuAction> _buildPopupMenuItem(
    BuildContext context,
    PopupMenuAction action,
  ) {
    final l = context.l;
    switch (action) {
      case PopupMenuAction.edit:
        return PopupMenuItem<PopupMenuAction>(
          value: PopupMenuAction.edit,
          child: Text(editActionTitle ?? l.editTitle),
        );
      case PopupMenuAction.remove:
        return PopupMenuItem<PopupMenuAction>(
          value: PopupMenuAction.remove,
          child: Text(removeActionTitle ?? l.removeTitle),
        );
    }
  }
}

enum PopupMenuAction {
  edit,
  remove,
}
