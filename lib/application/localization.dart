import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiple_localization/multiple_localization.dart';

import 'l10n/messages_all.dart';

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLangs.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return MultipleLocalizations.load(
      initializeMessages,
      locale,
      (l) => AppLocalizations(l),
      setDefaultLocale: true,
    );
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}

/// Application localization. Strings are declared via [Intl.message] using
/// English as the source language. Translations live in
/// `lib/application/l10n/messages_<lang>.dart` (one file per locale).
class AppLocalizations {
  static const supportedLangs = ['en', 'ru'];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final supportedLocales = supportedLangs.map((lang) => Locale(lang));

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  final String locale;
  AppLocalizations(this.locale);

  // ─── Common buttons ────────────────────────────────────────────────────────
  String get addButtonTitle => Intl.message('Add', name: 'addButtonTitle');
  String get deleteButtonTitle =>
      Intl.message('Delete', name: 'deleteButtonTitle');
  String get cancelButtonTitle =>
      Intl.message('Cancel', name: 'cancelButtonTitle');
  String get selectButtonTitle =>
      Intl.message('Select', name: 'selectButtonTitle');
  String get saveButtonTitle => Intl.message('Save', name: 'saveButtonTitle');
  String get yesButtonTitle => Intl.message('Yes', name: 'yesButtonTitle');
  String get okButtonTitle => Intl.message('OK', name: 'okButtonTitle');
  String get closeButtonTitle =>
      Intl.message('Close', name: 'closeButtonTitle');
  String get openButtonTitle => Intl.message('Open', name: 'openButtonTitle');
  String get copyButtonTitle => Intl.message('Copy', name: 'copyButtonTitle');
  String get clearButtonTitle =>
      Intl.message('Clear', name: 'clearButtonTitle');
  String get decodeButtonTitle =>
      Intl.message('Decode', name: 'decodeButtonTitle');
  String get replaceButtonTitle =>
      Intl.message('Replace', name: 'replaceButtonTitle');
  String get removeButtonTitle =>
      Intl.message('Remove', name: 'removeButtonTitle');
  String get editButtonTitle => Intl.message('Edit', name: 'editButtonTitle');

  // Legacy aliases.
  String get editTitle => editButtonTitle;
  String get removeTitle => removeButtonTitle;

  // ─── App ───────────────────────────────────────────────────────────────────
  String get decoderTitle => Intl.message('decoder', name: 'decoderTitle');
  String get settingsTitle => Intl.message('settings', name: 'settingsTitle');

  // ─── Projects list ─────────────────────────────────────────────────────────
  String get projectListTitle =>
      Intl.message('My projects', name: 'projectListTitle');
  String get projectListTooltipText =>
      Intl.message('Double click to select a project',
          name: 'projectListTooltipText');
  String get projectLisAddBtnTooltip =>
      Intl.message('Add new project', name: 'projectLisAddBtnTooltip');
  String get disableProjectTooltipText =>
      Intl.message('Add platform to select a project',
          name: 'disableProjectTooltipText');
  String get projectItemEmptyTitle =>
      Intl.message('empty project', name: 'projectItemEmptyTitle');
  String get editProjectTitle =>
      Intl.message('edit project', name: 'editProjectTitle');
  String get removeProjectTitle =>
      Intl.message('remove project', name: 'removeProjectTitle');
  String projectsCountText(int n) => Intl.plural(
        n,
        one: '$n project',
        other: '$n projects',
        name: 'projectsCountText',
        args: [n],
      );

  // ─── Edit project screen ───────────────────────────────────────────────────
  String get editProjectScreenCloseToolTip =>
      Intl.message('Close window', name: 'editProjectScreenCloseToolTip');
  String get editProjectScreenNewTitle =>
      Intl.message('Create project', name: 'editProjectScreenNewTitle');
  String get editProjectScreenEditTitle =>
      Intl.message('Edit project', name: 'editProjectScreenEditTitle');
  String get editProjectScreenNameFieldTitle =>
      Intl.message('Name', name: 'editProjectScreenNameFieldTitle');
  String get editProjectScreenVersionFieldTitle =>
      Intl.message('Version', name: 'editProjectScreenVersionFieldTitle');
  String get editProjectNameHelper =>
      Intl.message('The display name shown in the sidebar.',
          name: 'editProjectNameHelper');
  String get editProjectVersionPlaceholder => '1.0.0';
  String get versionsSectionLabel =>
      Intl.message('Versions', name: 'versionsSectionLabel');
  String get addVersionButtonTitle =>
      Intl.message('Add version', name: 'addVersionButtonTitle');
  String get deleteVersionTooltip =>
      Intl.message('Delete version', name: 'deleteVersionTooltip');
  String get deleteProjectButtonLabel =>
      Intl.message('Delete project', name: 'deleteProjectButtonLabel');
  String get addArtifactButtonTitle =>
      Intl.message('Add artifact', name: 'addArtifactButtonTitle');
  String artifactsCountText(int n) => Intl.plural(
        n,
        one: '$n artifact',
        other: '$n artifacts',
        name: 'artifactsCountText',
        args: [n],
      );

  // ─── Platforms ─────────────────────────────────────────────────────────────
  String get platformSelectorTitle =>
      Intl.message('Platforms', name: 'platformSelectorTitle');
  String get platformSelectorTooltip =>
      Intl.message('Select platform', name: 'platformSelectorTooltip');
  String get platformSelectorDialogTitle =>
      Intl.message('Select artifacts', name: 'platformSelectorDialogTitle');
  String get platformSelectorEditDialogTitle =>
      Intl.message('Select artifact', name: 'platformSelectorEditDialogTitle');
  String platformListItemAddTooltip(String platformName) =>
      Intl.message('add $platformName artifact',
          name: 'platformListItemAddTooltip', args: [platformName]);

  // ─── Confirm / alert dialogs ───────────────────────────────────────────────
  String get deleteProjectDialogTitle =>
      Intl.message('Delete project', name: 'deleteProjectDialogTitle');
  String get deleteProjectDialogText =>
      Intl.message('Do you really want to do that?',
          name: 'deleteProjectDialogText');
  String get saveProjectErrorText =>
      Intl.message('An error has occurred while saving a project',
          name: 'saveProjectErrorText');
  String get deleteProjectErrorText =>
      Intl.message('An error has occurred while deleting a project',
          name: 'deleteProjectErrorText');
  String get saveDecodeResultErrorText =>
      Intl.message('An error has occurred while saving decode result',
          name: 'saveDecodeResultErrorText');
  String filledTextError(String fieldName) =>
      Intl.message('$fieldName must be filled',
          name: 'filledTextError', args: [fieldName]);

  // ─── Preview / file picker ─────────────────────────────────────────────────
  String get previewSelectorTitle =>
      Intl.message('Preview', name: 'previewSelectorTitle');
  String get previewSelectorDialogTitle =>
      Intl.message('Select preview', name: 'previewSelectorDialogTitle');

  // ─── Workspace / drop zone ─────────────────────────────────────────────────
  String get workspaceSymbolsLabel =>
      Intl.message('SYMBOLS', name: 'workspaceSymbolsLabel');
  String get workspaceSymbolsLoaded =>
      Intl.message('Symbols loaded', name: 'workspaceSymbolsLoaded');
  String get dropTargetBoxTitle =>
      Intl.message('Drag-and-drop stacktrace files to start decoding',
          name: 'dropTargetBoxTitle');
  String get dropZoneReleaseLabel =>
      Intl.message('Release to decode', name: 'dropZoneReleaseLabel');
  String get dropZoneSubtitle => Intl.message(
      'Plain text or .txt — multiple files supported',
      name: 'dropZoneSubtitle');
  String get dropZoneBrowseHint =>
      Intl.message('or browse files…', name: 'dropZoneBrowseHint');

  // ─── Manual decoding ───────────────────────────────────────────────────────
  String get selectDecodeModeTitle =>
      Intl.message('Select decode mode', name: 'selectDecodeModeTitle');
  String get manualDecodeModeTitle =>
      Intl.message('Manual', name: 'manualDecodeModeTitle');
  String get draggingDecodeModeTitle =>
      Intl.message('Dragging', name: 'draggingDecodeModeTitle');
  String get manualDecodePageAddTitle =>
      Intl.message('Add stack trace', name: 'manualDecodePageAddTitle');
  String get manualDecodeStackTraceTitle =>
      Intl.message('Decode stack trace', name: 'manualDecodeStackTraceTitle');
  String get manualDecodeAllTitle =>
      Intl.message('Decode all', name: 'manualDecodeAllTitle');
  String get decodeResultFieldHintText =>
      Intl.message('Paste your stack trace here',
          name: 'decodeResultFieldHintText');
  String manualBlockLabel(int n) =>
      Intl.message('TRACE $n', name: 'manualBlockLabel', args: [n]);
  String linesCountText(int n) => Intl.plural(
        n,
        one: '$n line',
        other: '$n lines',
        name: 'linesCountText',
        args: [n],
      );

  // ─── Decode dialogs ────────────────────────────────────────────────────────
  String get decodeDialogErrorTitle =>
      Intl.message('Decoding error', name: 'decodeDialogErrorTitle');
  String get decodeDialogWarningTitle =>
      Intl.message('Warning', name: 'decodeDialogWarningTitle');
  String get decodeDialogEmptyTitle =>
      Intl.message('Empty stack trace', name: 'decodeDialogEmptyTitle');
  String get decodeDialogInvalidTitle =>
      Intl.message('Invalid stack trace', name: 'decodeDialogInvalidTitle');
  String get decodeDialogConfirmText => Intl.message(
      'One or more stack traces are invalid or empty.\nDo you want to continue decoding?',
      name: 'decodeDialogConfirmText');
  String get decodeDialogEmptyListTitle =>
      Intl.message('Enter valid stack trace',
          name: 'decodeDialogEmptyListTitle');

  // ─── Decode result screen ──────────────────────────────────────────────────
  String get decodeResultScreenTitle =>
      Intl.message('Decode result', name: 'decodeResultScreenTitle');
  String get decodeResultScreenSaveTitle =>
      Intl.message('Save result', name: 'decodeResultScreenSaveTitle');
  String get decodeResultScreenSaveAllTitle =>
      Intl.message('Save all files', name: 'decodeResultScreenSaveAllTitle');
  String decodeResultDecodedSummary(int total) =>
      Intl.message('$total of $total decoded',
          name: 'decodeResultDecodedSummary', args: [total]);
  String get decodeResultModeManualBadge =>
      Intl.message('manual', name: 'decodeResultModeManualBadge');
  String get decodeResultModeDragBadge =>
      Intl.message('drag-n-drop', name: 'decodeResultModeDragBadge');

  // ─── Main screen ───────────────────────────────────────────────────────────
  String get mainNoTabsOpen =>
      Intl.message('No tabs open', name: 'mainNoTabsOpen');
  String get mainEmptyTitle => Intl.message('Open a project to start decoding',
      name: 'mainEmptyTitle');
  String get mainEmptyBody => Intl.message(
      'Double-click any project in the sidebar, or create a new one.',
      name: 'mainEmptyBody');
  String get shortcutHintNewProject =>
      Intl.message('Create a new project', name: 'shortcutHintNewProject');
  String get shortcutHintCloseTab =>
      Intl.message('Close the active tab', name: 'shortcutHintCloseTab');

  // ─── Select platform dialog ────────────────────────────────────────────────
  String selectPlatformDialogTitle(String projectName) =>
      Intl.message('Open $projectName',
          name: 'selectPlatformDialogTitle', args: [projectName]);
  String get selectPlatformDialogBody => Intl.message(
      'Pick a version and platform to decode against.',
      name: 'selectPlatformDialogBody');

  // ─── Loader ────────────────────────────────────────────────────────────────
  String get loaderDecodeTitle =>
      Intl.message('Decoding traces', name: 'loaderDecodeTitle');
  String get loaderDecodeSubtitle =>
      Intl.message('Running flutter symbolize…', name: 'loaderDecodeSubtitle');

  // ─── Theme toggle ──────────────────────────────────────────────────────────
  String get themeToggleLightTooltip =>
      Intl.message('Light theme — switch to dark',
          name: 'themeToggleLightTooltip');
  String get themeToggleDarkTooltip =>
      Intl.message('Dark theme — switch to system',
          name: 'themeToggleDarkTooltip');
  String get themeToggleSystemTooltip =>
      Intl.message('System theme — switch to light',
          name: 'themeToggleSystemTooltip');
}

extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this);
}
