import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:flutter/material.dart';

class ProjectsList extends StatelessWidget {
  static const double _projectIconSize = 56;

  final ScrollController scrollController;
  final List<Project> projects;
  final ValueChanged<Project> onProjectTap;
  final ValueChanged<Project> onRemovePress;
  final ValueChanged<Project> onEditPress;

  const ProjectsList({
    Key? key,
    required this.scrollController,
    required this.projects,
    required this.onProjectTap,
    required this.onRemovePress,
    required this.onEditPress,
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
    final itemCount = projects.length;
    final items = projects;
    return FadingEdgeScrollView.fromScrollView(
      child: ListView.builder(
        controller: scrollController,
        itemBuilder: (context, index) {
          final project = items[index];
          return _buildProjectItem(context, project);
        },
        itemCount: itemCount,
      ),
    );
  }

  Widget _buildProjectItem(BuildContext context, Project project) {
    final l = context.l;
    final platforms = project.platforms;
    return Card(
      child: ListTile(
        enabled: project.isNotEmpty,
        onTap: () => onProjectTap(project),
        // TODO: custom icon
        leading: const FlutterLogo(size: _projectIconSize),
        title: Text(project.name),
        subtitle: Text(project.isNotEmpty
            ? _getProjectPlatforms(platforms)
            : l.projectItemEmptyTitle),
        trailing: _buildPopupMenu(l, project),
      ),
    );
  }

  Widget _buildPopupMenu(AppLocalizations l, Project project) {
    return PopupMenuButton<_PopupMenuAction>(
      splashRadius: _projectIconSize / 2,
      onSelected: (action) {
        switch (action) {
          case _PopupMenuAction.editProject:
            onEditPress(project);
            break;
          case _PopupMenuAction.removeProject:
            onRemovePress(project);
            break;
        }
      },
      icon: const Icon(Icons.more_vert_rounded),
      itemBuilder: (context) => <PopupMenuEntry<_PopupMenuAction>>[
        for (final action in _PopupMenuAction.values)
          _buildPopupMenuItem(action, l)
      ],
    );
  }

  PopupMenuItem<_PopupMenuAction> _buildPopupMenuItem(
      _PopupMenuAction action, AppLocalizations l) {
    switch (action) {
      case _PopupMenuAction.editProject:
        return PopupMenuItem<_PopupMenuAction>(
          value: _PopupMenuAction.editProject,
          child: Text(l.editProjectTitle),
        );
      case _PopupMenuAction.removeProject:
        return PopupMenuItem<_PopupMenuAction>(
          value: _PopupMenuAction.removeProject,
          child: Text(l.removeProjectTitle),
        );
    }
  }

  String _getProjectPlatforms(List<Platform> platforms) {
    final usedPlatforms = platforms.map((e) => e.type.name).join(', ');
    return usedPlatforms;
  }
}

enum _PopupMenuAction {
  editProject,
  removeProject,
}
