import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:flutter/material.dart';

typedef DialogResult<T> = T;

class AppDialog {
  static Future<bool> showConfirm(
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

  static Future<void> showAlert(
    BuildContext context, {
    required String content,
    String? title,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: title != null ? Text(title) : null,
        content: GestureDetector(
          child: Text(content),
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
