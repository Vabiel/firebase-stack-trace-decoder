## v1.0.0 - 2026-05-06

### Added

- Multi-version support: a single project now holds multiple versions, each with its own platforms and artifacts (no more separate project per app release)
- Brand-new visual design system: light + dark themes, single accent ("ink"), 6px radius, desktop-dense typography, full token set exposed via `AppTokens` (`ThemeExtension`)
- In-house widget library under `lib/widgets/ui/`: `AppButton`, `AppTextField`/`AppTextArea`, `AppRadio`/`AppCheckbox`, `AppChip`, `SegmentedToggle`, `AppCard`, `AppSplitter`, `SectionLabel`, `Mono`, `Kbd`, `AppListRow`, `AppDialogFrame`, `EmptyState`, `DropZone` (custom `CustomPainter` dashed border), `CodeBlock`, `AppMenuButton`/popup menu, `TabStrip`, `LoadingCard`, plus `AppIcons` and `PlatformGlyphs`
- Redesigned **Main screen**: sidebar with monogrammed project rows + theme toggle; Xcode-style tab strip with per-tab close; empty state with keyboard-shortcut hints
- Redesigned **Workspace** (per-tab): top `ArtifactBar` with symbols dropdown and "loaded" indicator, segmented `Drag & drop / Manual paste` toggle, dashed drop zone with `⌘O` browse hint, manual mode with stack-trace cards, per-card and bulk decode
- Redesigned **Edit Project** dialog: chip-based platform toggles, expandable per-platform artifact rows (mono filename + dim path), `Add version` / `Add artifact` flows
- Redesigned **Select Platform** dialog: radio rows grouped under mono version headers, `accentSoft` highlight for the selected combo
- Redesigned **Decode Result** dialog: collapsible result cards with mode badge, frame count, Copy/Save buttons, footer "Save all files"
- Floating loader card replacing the fullscreen overlay
- Theme toggle (light / dark / system) in the sidebar footer, persisted via Hive
- Keyboard shortcuts: `⌘N` create project, `⌘W` close active tab, `⌘O` browse files in drop zone
- Russian (`ru`) translations for the entire UI; new strings added to `AppLocalizations` with proper `Intl.plural` rules for Russian

### Changed

- Upgrade to Flutter 3.38 / Dart 3.10
- Migrate from `hive` (unmaintained) to `hive_ce`; adapters registered via generated `hive_registrar.g.dart`
- Bump all dependencies to current majors (`file_picker` 8, `intl` 0.20, `multi_split_view` 3, `multiple_localization` 0.6, `loader_overlay` 4, `flutter_lints` 5, `uuid` 4, etc.)
- `EditProjectScreen` redesigned around a list of version cards with per-version platform/artifact editing
- Platform selector dialog groups platforms by version
- Skip the "Select platform" dialog when a project has exactly one active (version, platform) combo
- Migrated `RadioListTile` to the new `RadioGroup` ancestor pattern
- Replaced ad-hoc `ElevatedButton`/`TextButton` styling with the new `AppButton`
- `AppDialog.showAlert/showConfirm/showForm` rebuilt around `AppDialogFrame` (no more Material `AlertDialog`/`AppBar` wrapper)
- `loader_overlay` configured at `MaterialApp.builder` level so the overlay can read theme tokens
- `MultiSplitView` divider replaced with a 1px line via `dividerBuilder`

### Removed

- `Project.version` and `Project.platforms` (replaced by `Project.versions: List<ProjectVersion>`)
- `tabbed_view` package (replaced by in-house `TabStrip`)
- `dotted_border` package (replaced by `DropZone`'s `CustomPainter`)
- `lib/widgets/buttons/`, `widgets/preview_selector/`, `widgets/platform_selector/`, `widgets/platform_tab_data/`, `widgets/draggable_decode_page/`, `widgets/manual_decode_page/`, `widgets/drop_target_box/`, `widgets/artifact_selector/`, `widgets/decode_result_field/` — superseded by the new widget library and `WorkspaceView`

### Notes

- Old Hive boxes are incompatible with the new schema and are dropped on first launch (no migration)

## v0.2.0 - 2023-08-10

- Support Flutter 3.10

## v0.1.1 - 2023-03-12

### Added

- Support manual decoding

## v0.1.0 - 2023-03-08

- The first version with dragging decoding