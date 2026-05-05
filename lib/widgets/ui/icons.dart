import 'package:flutter/material.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';

/// Centralised icon mapping. Material's outline set is close enough to the
/// design's 1.5px stroke style; use these aliases everywhere instead of
/// referencing `Icons.*` directly so we can swap to a custom set later.
class AppIcons {
  AppIcons._();

  static const IconData add = Icons.add_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData more = Icons.more_horiz_rounded;
  static const IconData chevronRight = Icons.chevron_right_rounded;
  static const IconData chevronDown = Icons.expand_more_rounded;
  static const IconData chevronUp = Icons.expand_less_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData drag = Icons.drag_indicator_rounded;
  static const IconData upload = Icons.file_upload_outlined;
  static const IconData copy = Icons.content_copy_outlined;
  static const IconData save = Icons.save_outlined;
  static const IconData trash = Icons.delete_outline_rounded;
  static const IconData edit = Icons.edit_outlined;
  static const IconData folder = Icons.folder_outlined;
  static const IconData file = Icons.description_outlined;
  static const IconData image = Icons.image_outlined;
  static const IconData check = Icons.check_rounded;
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData info = Icons.info_outline_rounded;
  static const IconData reset = Icons.refresh_rounded;
  static const IconData paste = Icons.content_paste_outlined;
  static const IconData spinner = Icons.refresh_rounded;
  static const IconData lightMode = Icons.light_mode_outlined;
  static const IconData darkMode = Icons.dark_mode_outlined;
}

/// Maps a [PlatformType] to a small decorative glyph (used inside chips,
/// tab titles, and dialog rows). Material has reasonable matches for most;
/// a couple are approximations.
class PlatformGlyphs {
  PlatformGlyphs._();

  static IconData of(PlatformType t) {
    switch (t) {
      case PlatformType.android:
        return Icons.android_rounded;
      case PlatformType.ios:
        return Icons.phone_iphone_rounded;
      case PlatformType.linux:
        return Icons.terminal_rounded;
      case PlatformType.macos:
        return Icons.laptop_mac_rounded;
      case PlatformType.windows:
        return Icons.window_rounded;
      case PlatformType.fuchsia:
        return Icons.bubble_chart_rounded;
    }
  }
}
