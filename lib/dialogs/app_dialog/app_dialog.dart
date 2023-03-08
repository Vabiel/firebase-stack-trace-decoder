import 'dart:io';

import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/widgets/buttons/buttons.dart';
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
            child: Text(negativeBtnTitle ?? l.cancelButtonTitle),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(positiveBtnTitle ?? l.yesButtonTitle),
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

  static Future<Object?> showForm(
    BuildContext context, {
    required String title,
    required Widget body,
    double? aspectRatio,
  }) {
    const defaultAspectRatio = 4 / 3;
    final ratio = aspectRatio ?? defaultAspectRatio;
    final isWindows = Platform.isWindows;
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, anim, anim2) {
        return body;
      },
      transitionBuilder: (context, anim, anim2, child) {
        var curve = Curves.easeInOut.transform(anim.value);
        return Transform.scale(
          scale: curve,
          child: Dialog(
            child: AspectRatio(
              aspectRatio: ratio,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(title),
                  automaticallyImplyLeading: false,
                  leading: !isWindows ? _buildCloseButton(context) : null,
                  actions: isWindows
                      ? [_buildCloseButton(context, withPadding: true)]
                      : null,
                ),
                body: child,
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static Widget _buildCloseButton(
    BuildContext context, {
    bool withPadding = false,
  }) {
    return Padding(
      padding: withPadding ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
      child: CloseBtn(
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
