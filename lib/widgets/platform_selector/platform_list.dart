import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/dialogs/file_picker_dialog/file_picker_dialog.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/widgets/action_popup_menu/action_popup_menu.dart';
import 'package:firebase_stacktrace_decoder/widgets/platform_selector/platform_selector.dart';
import 'package:flutter/material.dart';
import 'package:list_ext/list_ext.dart';
import 'package:string_ext/string_ext.dart';
import 'package:uuid/uuid.dart';

class PlatformList extends StatefulWidget {
  final WidgetBuilder headerBuilder;
  final PlatformListController controller;

  const PlatformList({
    Key? key,
    required this.headerBuilder,
    required this.controller,
  }) : super(key: key);

  @override
  State<PlatformList> createState() => _PlatformSelectorState();
}

class _PlatformSelectorState extends State<PlatformList> {
  static const _notFound = -1;

  late final PlatformListController _controller;

  final _uid = const Uuid();
  var _platforms = <Platform>[];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    final platforms = _controller.platforms;
    if (platforms.isNotEmpty) {
      _platforms = platforms;
    }
    _controller.addListener(_controllerListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Column(
      children: [
        SizedBox(
          height: 70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: widget.headerBuilder(context)),
              const SizedBox(width: 8),
              _buildPlatformSelector(context),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final platform in _platforms)
          if (platform.isActive) _buildPlatformItem(l, platform)
      ],
    );
  }

  Widget _buildPlatformSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: PlatformSelector(
        platforms: _platforms,
        onChange: _onPlatformChange,
      ),
    );
  }

  Widget _buildPlatformItem(AppLocalizations l, Platform platform) {
    final platformName = platform.name;
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xff9b9b9b)),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(platformName),
            const Spacer(),
            IconButton(
              color: Colors.green,
              splashRadius: 20,
              onPressed: () async => _onAddArtifacts(l, platform),
              icon: const Icon(Icons.add_circle),
              tooltip: l.platformListItemAddTooltip(platformName),
            )
          ],
        ),
        children: [
          for (final artifact in platform.artifacts)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Card(
                child: ListTile(
                  title: Text(artifact.fileName),
                  subtitle: Text(artifact.filePath),
                  trailing: ActionPopupMenu(
                    onRemoveActionSelect: () =>
                        _onRemoveArtifact(platform, artifact),
                    onEditActionSelect: () async {
                      await _onEditArtifact(l, platform, artifact);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onAddArtifacts(AppLocalizations l, Platform platform) async {
    final res = await FilePickerDialog.pickSymbols(
        dialogTitle: l.platformSelectorEditDialogTitle);
    if (res != null && res.files.isNotEmpty) {
      final paths = res.files
          .map((f) => f.path)
          .where((path) => path.isNotNullNorEmpty)
          .cast<String>();
      if (paths.isNotEmpty) {
        final artifacts = _getArtifacts(platform)
          ..addAll([
            for (final path in paths) Artifact(uid: _getUid(), filePath: path)
          ]);
        final updatedPlatform = platform.copyWith(artifacts: artifacts);
        _controller.updatePlatform(platform, updatedPlatform);
      }
    }
  }

  Future<void> _onEditArtifact(
      AppLocalizations l, Platform platform, Artifact artifact) async {
    final res = await FilePickerDialog.pickSymbol(
        dialogTitle: l.platformSelectorDialogTitle);
    if (res != null && res.files.isNotEmpty) {
      final file = res.files.first;
      final path = file.path;
      if (path.isNotNullNorEmpty) {
        final artifacts = _getArtifacts(platform);
        final index = artifacts.indexOf(artifact);
        if (index != _notFound) {
          artifacts[index] = artifact.copyWith(filePath: path!);
          final updatedPlatform = platform.copyWith(artifacts: artifacts);
          _controller.updatePlatform(platform, updatedPlatform);
        }
      }
    }
  }

  void _onRemoveArtifact(Platform platform, Artifact artifact) {
    final artifacts = _getArtifacts(platform)..remove(artifact);
    final updatedPlatform = platform.copyWith(artifacts: artifacts);
    _controller.updatePlatform(platform, updatedPlatform);
  }

  void _onPlatformChange(PlatformType type, bool isChecked) {
    final isActive = isChecked;
    final platform = _platforms.firstWhereOrNull((e) => e.type == type);
    if (platform != null) {
      final updatedPlatform = platform.copyWith(isActive: isActive);
      _controller.updatePlatform(platform, updatedPlatform);
    } else if (isActive) {
      final createdPlatform = Platform(uid: _getUid(), type: type);
      _controller.addPlatform(createdPlatform);
    }
  }

  void _controllerListener() {
    setState(() {
      _platforms = _controller.platforms;
    });
  }

  List<Artifact> _getArtifacts(Platform platform) =>
      List<Artifact>.from(platform.artifacts);

  String _getUid() => _uid.v4();
}

class PlatformListController extends ValueNotifier<List<Platform>> {
  static const _notFoundIndex = -1;

  PlatformListController(super.value);

  List<Platform> get platforms => value;

  void updatePlatform(Platform oldValue, Platform newValue) {
    final index = platforms.indexOf(oldValue);
    if (index != _notFoundIndex) {
      value[index] = newValue;
      notifyListeners();
    }
  }

  void addPlatform(Platform platform) {
    value.add(platform);
    notifyListeners();
  }

  void removePlatform(Platform platform) {
    value.remove(platform);
    notifyListeners();
  }
}
