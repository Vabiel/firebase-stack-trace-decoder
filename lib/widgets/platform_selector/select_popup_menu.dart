import 'package:flutter/material.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext, T);
typedef PopupItemChange<T> = void Function(T, bool);

class SelectPopupButton<T> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItems;
  final WidgetBuilder builder;
  final ItemBuilder<T>? popupItemBuilder;
  final PopupItemChange<T> onChange;
  final String? tooltip;
  final PopupMode mode;

  const SelectPopupButton._({
    super.key,
    required this.items,
    required this.builder,
    required this.onChange,
    required this.mode,
    this.popupItemBuilder,
    this.tooltip,
    this.selectedItems = const [],
  });

  static SelectPopupButton<T> radio<T>({
    Key? key,
    required List<T> items,
    required WidgetBuilder builder,
    required PopupItemChange<T> onChange,
    ItemBuilder<T>? popupItemBuilder,
    String? tooltip,
    T? selected,
  }) {
    return SelectPopupButton<T>._(
      key: key,
      items: items,
      builder: builder,
      onChange: onChange,
      popupItemBuilder: popupItemBuilder,
      tooltip: tooltip,
      selectedItems: selected != null ? [selected] : const [],
      mode: PopupMode.radioList,
    );
  }

  static SelectPopupButton<T> checkBox<T>({
    Key? key,
    required List<T> items,
    required WidgetBuilder builder,
    required PopupItemChange<T> onChange,
    List<T> selectedItems = const [],
    ItemBuilder<T>? popupItemBuilder,
    String? tooltip,
  }) {
    return SelectPopupButton<T>._(
      key: key,
      items: items,
      builder: builder,
      onChange: onChange,
      popupItemBuilder: popupItemBuilder,
      tooltip: tooltip,
      selectedItems: selectedItems,
      mode: PopupMode.checkboxList,
    );
  }

  @override
  State<SelectPopupButton<T>> createState() => _SelectPopupButtonState<T>();
}

class _SelectPopupButtonState<T> extends State<SelectPopupButton<T>> {
  late final _selectedItems = [...widget.selectedItems];
  late final _radioNotifier = _RadioNotifier<T?>(
      _selectedItems.isNotEmpty ? _selectedItems.first : null);

  @override
  void dispose() {
    _radioNotifier.dispose();
    super.dispose();
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
    final mode = widget.mode;
    final itemBuilder = widget.popupItemBuilder;
    return [
      for (final item in widget.items)
        PopupMenuItem<T>(
          value: item,
          padding: EdgeInsets.zero,
          child: mode.isCheckboxList
              ? _buildCheckboxTitle(context, item, itemBuilder)
              : _buildRadioTitle(context, item, itemBuilder),
        )
    ];
  }

  Widget _buildCheckboxTitle(
      BuildContext context, T item, ItemBuilder<T>? itemBuilder) {
    return _CheckboxTitle(
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
    );
  }

  Widget _buildRadioTitle(
      BuildContext context, T item, ItemBuilder<T>? itemBuilder) {
    return _RadioTitle<T>(
      notifier: _radioNotifier,
      onChange: (value) {
        final isAlreadySelected = _selectedItems.contains(value);
        setState(() {
          if (isAlreadySelected) {
            _selectedItems.clear();
          } else {
            _selectedItems.clear();
            _selectedItems.add(value);
          }
          _radioNotifier.setGroupValue(value);
          widget.onChange(item, true);
        });
      },
      value: item,
      title: itemBuilder != null
          ? itemBuilder(context, item)
          : Text(item.toString()),
    );
  }
}

class _RadioNotifier<T> extends ValueNotifier<T?> {
  _RadioNotifier(super.value);

  void setGroupValue(T? val) {
    value = val;
    notifyListeners();
  }
}

class _RadioTitle<T> extends StatefulWidget {
  final T value;
  final Widget title;
  final ValueChanged<T> onChange;
  final _RadioNotifier<T?> notifier;

  const _RadioTitle({
    Key? key,
    required this.value,
    required this.title,
    required this.onChange,
    required this.notifier,
  }) : super(key: key);

  @override
  State<_RadioTitle<T>> createState() => _RadioTitleState<T>();
}

class _RadioTitleState<T> extends State<_RadioTitle<T>> {
  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_onGroupChange);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onGroupChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      groupValue: widget.notifier.value,
      onChanged: (value) {
        if (value != null) {
          widget.onChange(value);
        }
      },
      value: widget.value,
      title: widget.title,
    );
  }

  void _onGroupChange() {
    setState(() {});
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
  late bool _value = widget.value;

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

enum PopupMode { checkboxList, radioList }

extension PopupModeExtension on PopupMode {
  bool get isCheckboxList => this == PopupMode.checkboxList;

  bool get isRadioList => this == PopupMode.radioList;
}
