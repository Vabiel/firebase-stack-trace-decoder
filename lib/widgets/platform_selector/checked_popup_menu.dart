import 'package:flutter/material.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext, T);
typedef PopupItemChange<T> = void Function(T, bool);

class CheckboxPopupButton<T> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItems;
  final WidgetBuilder builder;
  final ItemBuilder<T>? popupItemBuilder;
  final PopupItemChange<T> onChange;
  final String? tooltip;

  const CheckboxPopupButton({
    super.key,
    required this.items,
    required this.builder,
    required this.onChange,
    this.popupItemBuilder,
    this.tooltip,
    this.selectedItems = const [],
  });

  @override
  State<CheckboxPopupButton<T>> createState() => _CheckboxPopupButtonState<T>();
}

class _CheckboxPopupButtonState<T> extends State<CheckboxPopupButton<T>> {
  var _selectedItems = <T>[];

  @override
  void initState() {
    super.initState();
    final selectedItems = widget.selectedItems;
    if (selectedItems.isNotEmpty) {
      _selectedItems = selectedItems;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      tooltip: widget.tooltip,
      itemBuilder: _buildItems,
      child: widget.builder(context),
    );
  }

  List<PopupMenuEntry<T>> _buildItems(BuildContext context) {
    final itemBuilder = widget.popupItemBuilder;
    return [
      for (final item in widget.items)
        PopupMenuItem<T>(
          value: item,
          padding: EdgeInsets.zero,
          child: _CheckboxTitle(
            onChange: (value) {
              final isAlreadySelected = _selectedItems.contains(item);
              setState(() {
                isAlreadySelected
                    ? _selectedItems.remove(item)
                    : _selectedItems.add(item);
                widget.onChange(item, value);
              });
            },
            value: _selectedItems.contains(item),
            title: itemBuilder != null
                ? itemBuilder(context, item)
                : Text(item.toString()),
          ),
        )
    ];
  }
}

class _CheckboxTitle extends StatefulWidget {
  final bool value;
  final Widget title;
  final ValueChanged<bool> onChange;

  const _CheckboxTitle({
    Key? key,
    required this.value,
    required this.title,
    required this.onChange,
  }) : super(key: key);

  @override
  State<_CheckboxTitle> createState() => _CheckboxTitleState();
}

class _CheckboxTitleState extends State<_CheckboxTitle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _value = value;
            widget.onChange(_value);
          });
        }
      },
      value: _value,
      title: widget.title,
    );
  }
}
