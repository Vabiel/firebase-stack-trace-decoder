import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/blocs/screens/edit_project/edit_project_bloc.dart';
import 'package:firebase_stacktrace_decoder/blocs/screens/main/main_screen_bloc.dart';
import 'package:firebase_stacktrace_decoder/dialogs/app_dialog/app_dialog.dart';
import 'package:firebase_stacktrace_decoder/dialogs/select_platform_dialog/select_platform_dialog.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/screens/decode_result/decode_result.dart';
import 'package:firebase_stacktrace_decoder/screens/edit_project/edit_project_screen.dart';
import 'package:firebase_stacktrace_decoder/widgets/drop_target_box/drop_target_box.dart';
import 'package:firebase_stacktrace_decoder/widgets/platform_tab_data/platform_tab_data.dart';
import 'package:firebase_stacktrace_decoder/widgets/projects_list/projects_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:tabbed_view/tabbed_view.dart';

import 'package:flutter/material.dart' hide MenuBar;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _controller = TabbedViewController([]);
  final _scrollController = ScrollController();
  final _selectProjectController = ScrollController();
  late final MainScreenBloc _mainScreenBloc =
      MainScreenBloc(Get.find(), Get.find(), Get.find())..shown();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _selectProjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe9e9e9),
      // appBar: MenuBar.horizontal(),
      body: BlocListener<MainScreenBloc, MainScreenState>(
        bloc: _mainScreenBloc,
        listener: (context, state) async {
          context.loaderOverlay.hide();
          if (state is MainScreenDecodeInProgress) {
            context.loaderOverlay.show();
          } else if (state is MainScreenDecodeSuccess) {
            await _showDecodeResultScreen(context, state.decodeList);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MultiSplitView(
            initialAreas: [Area(weight: 0.35)],
            children: [
              _buildProjectList(),
              _buildTabbedView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabbedView() {
    return TabbedViewTheme(
      data: TabbedViewThemeData.classic(
        borderColor: AppTheme.borderColor,
      ),
      child: TabbedView(
        controller: _controller,
      ),
    );
  }

  Widget _buildProjectList() {
    return Container(
      decoration: AppTheme.boxBorder,
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
        bloc: _mainScreenBloc,
        buildWhen: (prev, current) => current is MainScreenLoadSuccess,
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
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<ActionResult?> _showEditProjectScreen(BuildContext context,
      [Project? project]) async {
    final l = context.l;
    final title = project != null
        ? l.editProjectScreenEditTitle
        : l.editProjectScreenNewTitle;
    final res = await AppDialog.showForm(
      context,
      title: title,
      body: EditProjectScreen(
        project: project,
      ),
    );
    if (res != null && res is ActionResult) {
      return res;
    }
    return null;
  }

  Future<void> _showDecodeResultScreen(
      BuildContext context, List<DecodeResult> decodeList) async {
    final l = context.l;
    await AppDialog.showForm(
      context,
      title: l.decodeResultScreenTitle,
      body: DecodeResultScreen(
        decodeList: decodeList,
      ),
    );
  }

  Future<void> _onRemovePressed(BuildContext context, Project project) async {
    final l = context.l;
    final res = await AppDialog.showConfirm(context,
        title: l.deleteProjectDialogTitle, content: l.deleteProjectDialogText);
    if (res) {
      _mainScreenBloc.removeProject(project.uid);
    }
  }

  Future<void> _onChangeProject(BuildContext context,
      [Project? project]) async {
    final res = await _showEditProjectScreen(context, project);
    if (res != null) {
      _mainScreenBloc.changeProject();
    }
  }

  Future<void> _onSelectProject(BuildContext context, Project project) async {
    final platform = await SelectPlatformDialog.show(context, project: project);
    if (platform != null) {
      final tabIndex = _controller.tabs.indexWhere((e) => e.value == platform);
      if (tabIndex != -1) {
        _controller.selectedIndex = tabIndex;
      } else {
        final tabText = '${project.name}-${platform.name}';
        _controller.addTab(
          TabData(
            value: platform,
            text: tabText,
            keepAlive: true,
            content: PlatformTabData(
              platform: platform,
              onDragDone: _mainScreenBloc.decodeDragging,
              onDecodeData: _mainScreenBloc.decodeManual,
            ),
          ),
        );
        _controller.selectedIndex = _controller.tabs.length - 1;
      }
    }
  }
}
