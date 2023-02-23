import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:flutter/material.dart';

typedef DialogResult<T> = T;

class ConfirmDialog {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String content,
    String? positiveBtnTitle,
    String? negativeBtnTitle,
  }) async {
    final l = context.l;
    final res = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child:
                Text(negativeBtnTitle ?? l.editProjectScreenCancelButtonTitle),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(positiveBtnTitle ?? l.editProjectScreenYesButtonTitle),
          ),
        ],
      ),
    );
    return res ?? false;
  }
}
