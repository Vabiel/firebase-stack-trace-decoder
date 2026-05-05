import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/blocs/screens/edit_project/edit_project_bloc.dart';
import 'package:firebase_stacktrace_decoder/blocs/screens/main/main_screen_bloc.dart';
import 'package:firebase_stacktrace_decoder/dialogs/app_dialog/app_dialog.dart';
import 'package:firebase_stacktrace_decoder/dialogs/select_platform_dialog/select_platform_dialog.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/screens/decode_result/decode_result.dart';
import 'package:firebase_stacktrace_decoder/screens/edit_project/edit_project_screen.dart';
import 'package:firebase_stacktrace_decoder/widgets/projects_list/projects_list.dart';
import 'package:firebase_stacktrace_decoder/widgets/ui/ui.dart';
import 'package:firebase_stacktrace_decoder/widgets/workspace/workspace.dart';
import 'package:flutter/material.dart' hide MenuBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:multi_split_view/multi_split_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _scrollController = ScrollController();
  late final MainScreenBloc _mainScreenBloc =
      MainScreenBloc(Get.find(), Get.find(), Get.find())..shown();

  /// Open tabs. Each entry is a (project, version, platform) triple. The
  /// `platform`/`version` instances must be the live ones from the project
  /// list — that's how the workspace picks up artifact updates.
  final List<_OpenTab> _tabs = [];
  String? _activeTabId;

  @override
  void dispose() {
    _scrollController.dispose();
    _mainScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Scaffold(
      backgroundColor: t.bg,
      body: BlocListener<MainScreenBloc, MainScreenState>(
        bloc: _mainScreenBloc,
        listener: (context, state) async {
          context.loaderOverlay.hide();
          if (state is MainScreenDecodeInProgress) {
            context.loaderOverlay.show();
          } else if (state is MainScreenDecodeSuccess) {
            await _showDecodeResultScreen(context, state.decodeList);
          } else if (state is MainScreenLoadSuccess) {
            // Drop tabs whose backing platform/version no longer exists.
            _reconcileTabs(state.projects);
          }
        },
        child: MultiSplitView(
          initialAreas: [
            Area(size: 280, min: 220, builder: (_, __) => _buildSidebar()),
            Area(flex: 1, builder: (_, __) => _buildContent()),
          ],
          dividerBuilder: (_, __, ___, ____, _____, ______) =>
              Container(width: 1, color: t.border),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    final t = context.tokens;
    return Container(
      decoration: BoxDecoration(
        color: t.bg,
        border: Border(right: BorderSide(color: t.border)),
      ),
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
        bloc: _mainScreenBloc,
        buildWhen: (_, c) => c is MainScreenLoadSuccess,
        builder: (context, state) {
          if (state is MainScreenLoadSuccess) {
            return ProjectsList(
              scrollController: _scrollController,
              projects: state.projects,
              onAddProject: () => _onChangeProject(context),
              onEditPress: (p) => _onChangeProject(context, p),
              onRemovePress: (p) => _onRemovePressed(context, p),
              onProjectSelect: (p) => _onSelectProject(context, p),
            );
          }
          return const Center(child: CircularProgressIndicator(strokeWidth: 1.5));
        },
      ),
    );
  }

  Widget _buildContent() {
    final t = context.tokens;
    return Container(
      color: t.surface,
      child: Column(
        children: [
          if (_tabs.isNotEmpty)
            TabStrip<String>(
              tabs: [
                for (final tab in _tabs)
                  AppTab<String>(
                    id: tab.id,
                    title: tab.title,
                    icon: PlatformGlyphs.of(tab.platform.type),
                  ),
              ],
              activeId: _activeTabId,
              onSelect: (id) => setState(() => _activeTabId = id),
              onClose: _onCloseTab,
            )
          else
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: AppTokens.s3),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: t.bg,
                border: Border(bottom: BorderSide(color: t.border)),
              ),
              child: Text(
                'No tabs open',
                style: TextStyle(color: t.textDim, fontSize: 11.5),
              ),
            ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_tabs.isEmpty) {
      final l = context.l;
      return EmptyState(
        title: 'Open a project to start decoding',
        body: 'Double-click any project in the sidebar, or create a new one.',
        action: AppButton(
          kind: AppButtonKind.primary,
          icon: AppIcons.add,
          label: l.editProjectScreenNewTitle,
          onPressed: () => _onChangeProject(context),
        ),
      );
    }
    final activeIndex = _tabs.indexWhere((t) => t.id == _activeTabId);
    return IndexedStack(
      index: activeIndex == -1 ? 0 : activeIndex,
      sizing: StackFit.expand,
      children: [
        for (final tab in _tabs)
          KeyedSubtree(
            key: ValueKey(tab.id),
            child: WorkspaceView(
              version: tab.version,
              platform: tab.platform,
              onDragDone: _mainScreenBloc.decodeDragging,
              onDecodeData: _mainScreenBloc.decodeManual,
            ),
          ),
      ],
    );
  }

  // ── Tab management ────────────────────────────────────────────────────────
  void _reconcileTabs(List<Project> projects) {
    if (_tabs.isEmpty) return;
    final live = <String, _OpenTab>{};
    for (final p in projects) {
      for (final v in p.versions) {
        for (final pl in v.platforms.where((pl) => pl.isActive)) {
          live[_tabIdOf(p, v, pl)] = _OpenTab(
            id: _tabIdOf(p, v, pl),
            title: '${p.name} ${v.version} — ${pl.name}',
            project: p,
            version: v,
            platform: pl,
          );
        }
      }
    }
    setState(() {
      final removed = <String>[];
      for (var i = 0; i < _tabs.length; i++) {
        final updated = live[_tabs[i].id];
        if (updated == null) {
          removed.add(_tabs[i].id);
        } else {
          _tabs[i] = updated;
        }
      }
      _tabs.removeWhere((t) => removed.contains(t.id));
      if (!_tabs.any((t) => t.id == _activeTabId)) {
        _activeTabId = _tabs.isNotEmpty ? _tabs.last.id : null;
      }
    });
  }

  void _onCloseTab(String id) {
    setState(() {
      _tabs.removeWhere((t) => t.id == id);
      if (_activeTabId == id) {
        _activeTabId = _tabs.isNotEmpty ? _tabs.last.id : null;
      }
    });
  }

  static String _tabIdOf(Project p, ProjectVersion v, Platform pl) =>
      '${p.uid}/${v.uid}/${pl.uid}';

  // ── Project actions ───────────────────────────────────────────────────────
  Future<ActionResult?> _showEditProjectScreen(BuildContext context,
      [Project? project]) async {
    final l = context.l;
    final title = project != null
        ? l.editProjectScreenEditTitle
        : l.editProjectScreenNewTitle;
    final res = await AppDialog.showForm(
      context,
      title: title,
      body: EditProjectScreen(project: project),
    );
    if (res != null && res is ActionResult) return res;
    return null;
  }

  Future<void> _showDecodeResultScreen(
      BuildContext context, List<DecodeResult> decodeList) async {
    final l = context.l;
    await AppDialog.showForm(
      context,
      title: l.decodeResultScreenTitle,
      body: DecodeResultScreen(decodeList: decodeList),
    );
  }

  Future<void> _onRemovePressed(BuildContext context, Project project) async {
    final l = context.l;
    final res = await AppDialog.showConfirm(context,
        title: l.deleteProjectDialogTitle, content: l.deleteProjectDialogText);
    if (res) _mainScreenBloc.removeProject(project.uid);
  }

  Future<void> _onChangeProject(BuildContext context,
      [Project? project]) async {
    final res = await _showEditProjectScreen(context, project);
    if (res != null) _mainScreenBloc.changeProject();
  }

  Future<void> _onSelectProject(BuildContext context, Project project) async {
    final result = await SelectPlatformDialog.show(context, project: project);
    if (result == null) return;
    final id = _tabIdOf(project, result.version, result.platform);
    final existing = _tabs.indexWhere((t) => t.id == id);
    if (existing != -1) {
      setState(() => _activeTabId = id);
      return;
    }
    setState(() {
      _tabs.add(_OpenTab(
        id: id,
        title:
            '${project.name} ${result.version.version} — ${result.platform.name}',
        project: project,
        version: result.version,
        platform: result.platform,
      ));
      _activeTabId = id;
    });
  }
}

class _OpenTab {
  final String id;
  final String title;
  final Project project;
  final ProjectVersion version;
  final Platform platform;

  const _OpenTab({
    required this.id,
    required this.title,
    required this.project,
    required this.version,
    required this.platform,
  });
}
