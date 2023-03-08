import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';

class SelectPlatformDialog {
  static Future<Platform?> show(
    BuildContext context, {
    required Project project,
  }) async {
    final platforms = project.platforms.where((p) => p.isActive).toList();
    final res = await showDialog<Platform?>(
      context: context,
      builder: (BuildContext context) {
        final l = context.l;
        Platform? platform;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(l.platformSelectorTooltip),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final item in platforms)
                  RadioListTile<Platform>(
                    value: item,
                    groupValue: platform,
                    title: Text(item.name),
                    onChanged: (value) {
                      setState(() => platform = value);
                    },
                  )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(l.cancelButtonTitle)),
              TextButton(
                  onPressed: platform != null
                      ? () => Navigator.of(context).pop(platform)
                      : null,
                  child: Text(l.selectButtonTitle)),
            ],
          );
        });
      },
    );
    return res;
  }

  SelectPlatformDialog._();
}
