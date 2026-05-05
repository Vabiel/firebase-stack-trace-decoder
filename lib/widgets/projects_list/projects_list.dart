import 'package:firebase_stacktrace_decoder/application/localization.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/application/theme_controller.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/widgets/project_preview/project_preview.dart';
import 'package:firebase_stacktrace_decoder/widgets/ui/ui.dart';
import 'package:flutter/material.dart';

/// Sidebar with the project list. Header row + scrollable rows + footer
/// counter. Visual matches the Claude Design handoff.
class ProjectsList extends StatelessWidget {
  final ScrollController scrollController;
  final List<Project> projects;
  final ValueChanged<Project> onProjectSelect;
  final ValueChanged<Project> onRemovePress;
  final ValueChanged<Project> onEditPress;
  final VoidCallback onAddProject;

  const ProjectsList({
    super.key,
    required this.scrollController,
    required this.projects,
    required this.onProjectSelect,
    required this.onRemovePress,
    required this.onEditPress,
    required this.onAddProject,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        Expanded(child: _buildList()),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l = context.l;
    final t = context.tokens;
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.s3),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: t.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l.projectListTitle.toUpperCase(),
              style: TextStyle(
                color: t.textDim,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
          AppButton.iconOnly(
            icon: AppIcons.add,
            size: AppButtonSize.sm,
            tooltip: l.projectLisAddBtnTooltip,
            onPressed: onAddProject,
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Padding(
      padding: const EdgeInsets.all(AppTokens.s1 + 2),
      child: ListView.separated(
        controller: scrollController,
        itemCount: projects.length,
        separatorBuilder: (_, __) => const SizedBox(height: 2),
        itemBuilder: (context, i) {
          final p = projects[i];
          return _ProjectRow(
            project: p,
            onDoubleTap: () => onProjectSelect(p),
            onRemove: () => onRemovePress(p),
            onEdit: () => onEditPress(p),
          );
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final t = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.s3, vertical: 4),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: t.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${projects.length} project${projects.length == 1 ? '' : 's'}',
              style: TextStyle(color: t.textDim, fontSize: 11),
            ),
          ),
          const _ThemeToggle(),
        ],
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance,
      builder: (_, mode, __) {
        final IconData icon;
        final String tooltip;
        switch (mode) {
          case ThemeMode.light:
            icon = AppIcons.lightMode;
            tooltip = 'Light theme — switch to dark';
            break;
          case ThemeMode.dark:
            icon = AppIcons.darkMode;
            tooltip = 'Dark theme — switch to system';
            break;
          case ThemeMode.system:
            icon = Icons.brightness_auto_outlined;
            tooltip = 'System theme — switch to light';
            break;
        }
        return AppButton.iconOnly(
          icon: icon,
          size: AppButtonSize.sm,
          tooltip: tooltip,
          onPressed: ThemeController.instance.cycle,
        );
      },
    );
  }
}

class _ProjectRow extends StatefulWidget {
  final Project project;
  final VoidCallback onDoubleTap;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  const _ProjectRow({
    required this.project,
    required this.onDoubleTap,
    required this.onRemove,
    required this.onEdit,
  });

  @override
  State<_ProjectRow> createState() => _ProjectRowState();
}

class _ProjectRowState extends State<_ProjectRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l;
    final p = widget.project;
    final enabled = p.hasPlatforms;

    final row = AppListRow(
      onDoubleTap: enabled ? widget.onDoubleTap : null,
      dim: !enabled,
      child: Row(
        children: [
          _Preview(preview: p.preview, seed: p.name),
          const SizedBox(width: AppTokens.s3),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: enabled ? t.text : t.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _summary(p, l),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: enabled ? t.textMuted : t.textDim,
                    fontSize: 11.5,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          AnimatedOpacity(
            duration: AppTokens.motionFast,
            opacity: _hover ? 1 : 0,
            child: AppMenuButton<_MenuAction>(
              tooltip: enabled
                  ? l.projectListTooltipText
                  : l.disableProjectTooltipText,
              items: [
                AppMenuItem<_MenuAction>(
                  value: _MenuAction.edit,
                  label: l.editProjectTitle,
                  icon: AppIcons.edit,
                ),
                const AppMenuItem<_MenuAction>.divider(),
                AppMenuItem<_MenuAction>(
                  value: _MenuAction.remove,
                  label: l.removeProjectTitle,
                  icon: AppIcons.trash,
                  danger: true,
                ),
              ],
              onSelected: (a) {
                switch (a) {
                  case _MenuAction.edit:
                    widget.onEdit();
                    break;
                  case _MenuAction.remove:
                    widget.onRemove();
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Tooltip(
        message: enabled
            ? l.projectListTooltipText
            : l.disableProjectTooltipText,
        child: row,
      ),
    );
  }

  String _summary(Project p, AppLocalizations l) {
    if (!p.hasPlatforms) return l.projectItemEmptyTitle;
    return p.activeVersions
        .map((v) {
          final platforms = v.platforms
              .where((pl) => pl.isActive)
              .map((e) => e.name)
              .join(', ');
          return '${v.version}: $platforms';
        })
        .join(' • ');
  }
}

enum _MenuAction { edit, remove }

class _Preview extends StatelessWidget {
  final String? preview;
  final String seed;
  const _Preview({required this.preview, required this.seed});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    if (preview != null && preview!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: t.border),
            borderRadius: BorderRadius.circular(AppTokens.radiusSm),
          ),
          child: ProjectPreview(preview: preview!, previewSize: 40),
        ),
      );
    }
    return _Monogram(seed: seed);
  }
}

/// Deterministic monogram thumbnail for projects without a preview image.
class _Monogram extends StatelessWidget {
  final String seed;
  const _Monogram({required this.seed});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final letter =
        seed.isNotEmpty ? seed.characters.first.toUpperCase() : '?';
    final hue = _hashHue(seed);
    final bg = HSLColor.fromAHSL(1.0, hue,
        Theme.of(context).brightness == Brightness.dark ? 0.22 : 0.30, 0.92).toColor();
    final fg = HSLColor.fromAHSL(1.0, hue, 0.50,
            Theme.of(context).brightness == Brightness.dark ? 0.65 : 0.42)
        .toColor();
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? bg.withValues(alpha: 0.4) : bg,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(AppTokens.radiusSm),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          color: fg,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static double _hashHue(String s) {
    var h = 0;
    for (var i = 0; i < s.length; i++) {
      h = (h * 31 + s.codeUnitAt(i)) & 0x7fffffff;
    }
    return (h % 360).toDouble();
  }
}
