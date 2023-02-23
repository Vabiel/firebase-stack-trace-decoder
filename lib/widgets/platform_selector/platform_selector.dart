import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/widgets/platform_selector/checked_popup_menu.dart';
import 'package:flutter/material.dart';

class PlatformSelector extends StatelessWidget {
  final List<Platform> platforms;
  final PopupItemChange<PlatformType> onChange;

  const PlatformSelector(
      {Key? key, required this.onChange, this.platforms = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final selectedPlatforms =
        platforms.where((p) => p.isActive).map((e) => e.type).toList();
    return CheckboxPopupButton<PlatformType>(
      items: PlatformType.values,
      selectedItems: selectedPlatforms,
      onChange: onChange,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(l.platformSelectorTitle),
            const SizedBox(width: 4),
            const Icon(Icons.settings),
          ],
        ),
      ),
      popupItemBuilder: (context, item) => Text(item.name),
      tooltip: l.platformSelectorTooltip,
    );
  }
}
