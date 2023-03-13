import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:flutter/material.dart';

class DecodeResultField extends StatelessWidget {
  final TextEditingController controller;
  final List<CustomMenuAction> contextMenuActions;
  final String? errorText;

  const DecodeResultField({
    Key? key,
    required this.controller,
    this.contextMenuActions = const [],
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TextField(
      contextMenuBuilder:
          (BuildContext context, EditableTextState editableTextState) {
        final List<ContextMenuButtonItem> buttonItems =
            editableTextState.contextMenuButtonItems;
        for (final menuAction in contextMenuActions) {
          buttonItems.add(ContextMenuButtonItem(
              label: menuAction.label,
              onPressed: menuAction.closeMenuAfterTap
                  ? () {
                      menuAction.onPressed();
                      ContextMenuController.removeAny();
                    }
                  : menuAction.onPressed));
        }
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: editableTextState.contextMenuAnchors,
          buttonItems: buttonItems,
        );
      },
      controller: controller,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      expands: true,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        hintText: l.decodeResultFieldHintText,
        contentPadding: const EdgeInsets.all(16.0),
        border: const OutlineInputBorder(),
        errorText: errorText,
      ),
    );
  }
}

class CustomMenuAction {
  final String label;
  final VoidCallback onPressed;
  final bool closeMenuAfterTap;

  const CustomMenuAction({
    required this.label,
    required this.onPressed,
    this.closeMenuAfterTap = true,
  });

  @override
  String toString() {
    return 'CustomMenuItem{label: $label, onPressed: $onPressed,'
        ' closeMenuAfterTap: $closeMenuAfterTap,}';
  }
}
