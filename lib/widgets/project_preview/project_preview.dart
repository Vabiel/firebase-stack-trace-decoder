import 'dart:io';

import 'package:flutter/material.dart';

class ProjectPreview extends StatelessWidget {
  final double previewSize;
  final String preview;

  const ProjectPreview({
    Key? key,
    required this.preview,
    this.previewSize = 64,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(File(preview),
        width: previewSize,
        height: previewSize,
        fit: BoxFit.contain, errorBuilder: (_, error, stack) {
      String errorText;
      if (error is PathNotFoundException) {
        errorText = error.message;
      } else if (error is FileSystemException) {
        errorText = error.message;
      } else {
        errorText = error.toString();
      }
      return Tooltip(
        message: errorText,
        child: Icon(
          Icons.image_not_supported_outlined,
          size: previewSize,
          color: Colors.red,
        ),
      );
    });
  }
}
