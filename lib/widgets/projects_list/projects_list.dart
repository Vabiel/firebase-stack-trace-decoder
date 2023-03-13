import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/widgets/action_popup_menu/action_popup_menu.dart';
import 'package:firebase_stacktrace_decoder/widgets/buttons/buttons.dart';
import 'package:firebase_stacktrace_decoder/widgets/project_preview/project_preview.dart';
import 'package:flutter/material.dart';
import 'package:string_ext/string_ext.dart';

class ProjectsList extends StatelessWidget {
  final ScrollController scrollController;
  final List<Project> projects;
  final ValueChanged<Project> onProjectSelect;
  final ValueChanged<Project> onRemovePress;
  final ValueChanged<Project> onEditPress;
  final VoidCallback onAddProject;

  const ProjectsList({
    Key? key,
    required this.scrollController,
    required this.projects,
    required this.onProjectSelect,
    required this.onRemovePress,
    required this.onEditPress,
    required this.onAddProject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _buildProjectsList(context)),
        const SizedBox(height: 8)
      ],
    );
  }

  Widget _buildProjectsList(BuildContext context) {
    final l = context.l;
    final itemCount = projects.length;
    final items = projects;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(4),
              topLeft: Radius.circular(4),
            ),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.projectListTitle),
              AddButton(
                onPressed: onAddProject,
                tooltip: l.projectLisAddBtnTooltip,
              )
            ],
          ),
        ),
        const Divider(height: 1.5),
        Expanded(
          child: FadingEdgeScrollView.fromScrollView(
            child: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) {
                final project = items[index];
                return _ProjectListItem(
                  project: project,
                  onRemovePress: () => onRemovePress(project),
                  onEditPress: () => onEditPress(project),
                  onDoubleTap: () => onProjectSelect(project),
                );
              },
              itemCount: itemCount,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectListItem extends StatelessWidget {
  final Project project;
  final VoidCallback onRemovePress;
  final VoidCallback onEditPress;
  final VoidCallback onDoubleTap;

  const _ProjectListItem({
    Key? key,
    required this.project,
    required this.onRemovePress,
    required this.onEditPress,
    required this.onDoubleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final preview = project.preview;
    final isEnabled = project.hasPlatforms;
    final platformsColor =
        isEnabled ? const Color(0xff878787) : const Color(0xffb8b8b8);
    final nameColor =
        isEnabled ? const Color(0xff222222) : const Color(0xff858585);
    final nameStyle = TextStyle(color: nameColor, fontSize: 16);
    final platformsStyle = TextStyle(fontSize: 14, color: platformsColor);

    final itemColor = isEnabled ? null : const Color(0xfff4f4f4);
    return ClipRect(
      child: Tooltip(
        message:
            isEnabled ? l.projectListTooltipText : l.disableProjectTooltipText,
        child: GestureDetector(
          onDoubleTap: isEnabled ? onDoubleTap : null,
          child: ClipRRect(
            child: Card(
              color: itemColor,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 80),
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8, end: 16),
                  child: Row(
                    children: [
                      if (preview.isNotNullNorEmpty)
                        ProjectPreview(
                          preview: preview!,
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildText(
                                '${project.name} (${project.version})',
                                style: nameStyle,
                              ),
                              Text(
                                _getPlatformsTitle(isEnabled, l),
                                style: platformsStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildPopupMenu(l, project),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getPlatformsTitle(bool isEnabled, AppLocalizations l) {
    return isEnabled
        ? project.platforms
            .where((p) => p.isActive)
            .map((e) => e.name)
            .join(', ')
        : l.projectItemEmptyTitle;
  }

  Widget _buildText(String title, {required TextStyle style}) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.fade,
      softWrap: false,
      style: style,
    );
  }

  Widget _buildPopupMenu(AppLocalizations l, Project project) {
    return ActionPopupMenu(
      removeActionTitle: l.removeProjectTitle,
      editActionTitle: l.editProjectTitle,
      onRemoveActionSelect: onRemovePress,
      onEditActionSelect: onEditPress,
      iconColor: const Color(0xff8c8c8c),
    );
  }
}
