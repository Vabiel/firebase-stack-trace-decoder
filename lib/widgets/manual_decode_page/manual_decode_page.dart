import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/application/uid_utils.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/widgets/decode_result_field/decode_result_field.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

typedef OnDecodeData = void Function(Artifact, List<String>);

class ManualDecodePage extends StatefulWidget {
  final PageController manualPageController;
  final List<Artifact> artifacts;
  final OnDecodeData onDecodeData;

  const ManualDecodePage({
    Key? key,
    required this.manualPageController,
    required this.artifacts,
    required this.onDecodeData,
  }) : super(key: key);

  @override
  State<ManualDecodePage> createState() => _ManualDecodePageState();
}

class _ManualDecodePageState extends State<ManualDecodePage>
    with AutomaticKeepAliveClientMixin<ManualDecodePage> {
  final Map<String, TabbedViewController> _controllers = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controllers.forEach((uid, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: widget.manualPageController,
      children: [
        for (final artifact in widget.artifacts)
          _TextTab(
            artifact: artifact,
            controller: _createController(),
            onDecodeData: widget.onDecodeData,
          ),
        // DecodeResult(controller: TextEditingController(text: artifact.uid)),
      ],
    );
  }

  TabbedViewController _createController() {
    final uid = UidUtils.v4;
    _controllers[uid] = TabbedViewController([]);
    return _controllers[uid]!;
  }
}

class _TextTab extends StatefulWidget {
  final Artifact artifact;
  final TabbedViewController controller;
  final OnDecodeData onDecodeData;

  const _TextTab({
    Key? key,
    required this.artifact,
    required this.controller,
    required this.onDecodeData,
  }) : super(key: key);

  @override
  State<_TextTab> createState() => _TextTabState();
}

class _TextTabState extends State<_TextTab>
    with AutomaticKeepAliveClientMixin<_TextTab> {
  static const _emptyStr = '';

  static const _pattern = '#[0-9][0-9] abs 0 virt';
  static final _checkLineRegExp = RegExp(_pattern, caseSensitive: false);
  late final _controller = widget.controller;

  final Map<String, TextEditingController> _controllers = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controllers.forEach((uid, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = context.l;
    return TabbedViewTheme(
      data: TabbedViewThemeData.classic(
        borderColor: AppTheme.borderColor,
      ),
      child: TabbedView(
          controller: _controller,
          onTabClose: _onTabClose,
          tabsAreaButtonsBuilder: (context, tabsCount) {
            return [
              if (tabsCount > 1)
                TabButton(
                  icon: IconProvider.data(Icons.play_arrow),
                  toolTip: l.decodeResultScreenSaveAllTitle,
                  onPressed: _onDecodeAllPressed,
                ),
              TabButton(
                icon: IconProvider.data(Icons.add),
                toolTip: l.manualDecodePageAddTitle,
                onPressed: () => _onAddTab(l),
              ),
            ];
          }),
    );
  }

  String _prepareText(String text) {
    const space = '    ';
    if (text.isNotEmpty) {
      final buffer = StringBuffer();
      final lines = text.split('\n');
      for (final line in lines) {
        final trimmedLine = line.trim();
        final isValidLine = _checkLineRegExp.hasMatch(trimmedLine);
        if (isValidLine) {
          buffer.writeln('$space$trimmedLine');
        }
      }
      return buffer.isNotEmpty ? buffer.toString() : _emptyStr;
    }
    return _emptyStr;
  }

  void _onDecodeTabPressed(String uid) {
    final controller = _controllers[uid];
    if (controller != null) {
      final text = controller.text;
      final stackTrace = _prepareText(text);
      if (stackTrace.isNotEmpty) {
        widget.onDecodeData(widget.artifact, [stackTrace]);
      }
    }
  }

  void _onDecodeAllPressed() {
    final stackTraceList = [];
    _controllers.forEach((uid, controller) {
      final stackTrace = _prepareText(controller.text);
      if (stackTrace.isNotEmpty) {
        stackTraceList.add(stackTrace);
      }
    });
  }

  void _onTabClose(int index, TabData tabData) {
    final uid = tabData.value as String;
    final hasController = _controllers.containsKey(uid);
    if (hasController) {
      final controller = _controllers[uid]!;
      controller.dispose();
      _controllers.remove(uid);
    }
  }

  void _onAddTab(AppLocalizations l) {
    final uid = UidUtils.v4;
    _controllers[uid] = TextEditingController();
    _controller.addTab(
      TabData(
        value: uid,
        text: '#${_controller.tabs.length}',
        keepAlive: true,
        buttons: [
          TabButton(
            icon: IconProvider.data(Icons.play_arrow),
            toolTip: l.manualDecodeStackTraceTitle,
            onPressed: () => _onDecodeTabPressed(uid),
          ),
        ],
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DecodeResultField(controller: _controllers[uid]!),
        ),
      ),
    );
    _controller.selectedIndex = _controller.tabs.length - 1;
  }
}
