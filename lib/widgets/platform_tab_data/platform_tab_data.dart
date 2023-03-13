import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/widgets/artifact_selector/artifact_selector.dart';
import 'package:firebase_stacktrace_decoder/widgets/draggable_decode_page/draggable_decode_page.dart';
import 'package:firebase_stacktrace_decoder/widgets/drop_target_box/drop_target_box.dart';
import 'package:firebase_stacktrace_decoder/widgets/manual_decode_page/manual_decode_page.dart';
import 'package:firebase_stacktrace_decoder/widgets/platform_selector/select_popup_menu.dart';
import 'package:flutter/material.dart';

class PlatformTabData extends StatefulWidget {
  final Platform platform;
  final OnDragDone onDragDone;
  final OnDecodeData onDecodeData;
  final DecodeMode decodeMode;

  const PlatformTabData({
    Key? key,
    required this.platform,
    required this.onDragDone,
    required this.onDecodeData,
    this.decodeMode = DecodeMode.manual,
  }) : super(key: key);

  @override
  State<PlatformTabData> createState() => _PlatformTabDataState();
}

class _PlatformTabDataState extends State<PlatformTabData>
    with AutomaticKeepAliveClientMixin<PlatformTabData> {
  late final _decodeModePageController =
      PageController(initialPage: widget.decodeMode.index);
  late DecodeMode _decodeMode = widget.decodeMode;

  final _draggablePageController = PageController();
  final _manualPageController = PageController();

  Artifact? _selected;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _draggablePageController.dispose();
    _manualPageController.dispose();
    _decodeModePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final platform = widget.platform;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _buildBody(context, platform),
    );
  }

  Widget _buildBody(BuildContext context, Platform platform) {
    final artifacts = platform.artifacts;
    return Column(
      children: [
        Row(
          children: [
            if (artifacts.length > 1)
              Expanded(
                child: ArtifactSelector(
                  artifacts: artifacts,
                  selected: _selected ?? artifacts.first,
                  onSelect: _onSelectArtifact,
                ),
              )
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    artifacts.first.filename,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            _buildModeSwitcher(context),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: PageView(
            controller: _decodeModePageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ManualDecodePage(
                manualPageController: _manualPageController,
                platformType: platform.type,
                artifacts: artifacts,
                onDecodeData: widget.onDecodeData,
              ),
              DraggableDecodePage(
                draggablePageController: _draggablePageController,
                artifacts: artifacts,
                onDragDone: widget.onDragDone,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateSelected(List<Artifact> artifacts) {
    if (artifacts.isNotEmpty) {
      final page = _decodeMode == DecodeMode.manual
          ? _manualPageController.page?.floor()
          : _draggablePageController.page?.floor();
      if (page != null && artifacts.length > page) {
        _selected = artifacts[page];
      }
    }
  }

  void _onSelectArtifact(int page) {
    // TODO: fix it

    setState(() {
      _decodeMode == DecodeMode.manual
          ? _manualPageController.jumpToPage(page)
          : _draggablePageController.jumpToPage(page);
      _updateSelected(widget.platform.artifacts);
    });
  }

  Widget _buildModeSwitcher(BuildContext context) {
    final l = context.l;
    return SelectPopupButton.radio<DecodeMode>(
        items: DecodeMode.values,
        selected: _decodeMode,
        builder: (_) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.settings),
          );
        },
        popupItemBuilder: (_, item) {
          return Text(item.isManualMode
              ? l.manualDecodeModeTitle
              : l.draggingDecodeModeTitle);
        },
        onChange: _onChangeMode,
        tooltip: l.selectDecodeModeTitle);
  }

  void _onChangeMode(DecodeMode mode) {
    _decodeMode = mode;
    final page = _decodeMode.index;
    _decodeModePageController.jumpToPage(page);
  }
}

enum DecodeMode { manual, dragging }

extension DecodeModeExteension on DecodeMode {
  bool get isManualMode => this == DecodeMode.manual;

  bool get isDraggingMode => this == DecodeMode.dragging;
}
