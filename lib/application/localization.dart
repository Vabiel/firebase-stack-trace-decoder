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
        initializeMessages, locale, (l) => AppLocalizations(l),
        setDefaultLocale: true);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

/// Application localization.
///
/// When adding a new field, you must insert it
/// to a specific section. For example: `bookings`.
/// When adding, consider the section (for example: `bookingsYourParamName`).
/// In the `common` section, the name is omitted (eg: `buttonOk`).
class AppLocalizations {
  /// Languages supported by the application.
  static const supportedLangs = [
    'en', /*'ru'*/
  ];

  /// [LocalizationsDelegate] which uses [AppLocalizations.load]
  /// to instantiate the class.
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// Languages supported by the application.
  static final supportedLocales = supportedLangs.map((lang) => Locale(lang));

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  final String locale;

  AppLocalizations(this.locale);

  String get decoderTitle => Intl.message('decoder', name: 'decoderTitle');

  String get settingsTitle => Intl.message('settings', name: 'settingsTitle');

  String get projectItemEmptyTitle =>
      Intl.message('empty project', name: 'projectItemEmptyTitle');

  String get editProjectTitle =>
      Intl.message('edit project', name: 'editProjectTitle');

  String get removeProjectTitle =>
      Intl.message('remove project', name: 'removeProjectTitle');

  String get editTitle => Intl.message('edit', name: 'editTitle');

  String get removeTitle => Intl.message('remove', name: 'removeTitle');

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

  String get addButtonTitle => Intl.message('Add', name: 'addButtonTitle');

  String get deleteButtonTitle =>
      Intl.message('Delete', name: 'deleteButtonTitle');

  String get cancelButtonTitle =>
      Intl.message('Cancel', name: 'cancelButtonTitle');

  String get selectButtonTitle =>
      Intl.message('Select', name: 'selectButtonTitle');

  String get saveButtonTitle => Intl.message('Save', name: 'saveButtonTitle');

  String get yesButtonTitle => Intl.message('Yes', name: 'yesButtonTitle');

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

  String get projectListTooltipText =>
      Intl.message('Double click to select a project',
          name: 'projectListTooltipText');

  String get projectListTitle =>
      Intl.message('My projects', name: 'projectListTitle');

  String get projectLisAddBtnTooltip =>
      Intl.message('Add new project', name: 'projectLisAddBtnTooltip');

  String get disableProjectTooltipText =>
      Intl.message('Add platform to select a project',
          name: 'disableProjectTooltipText');

  String get previewSelectorDialogTitle =>
      Intl.message('Select preview', name: 'previewSelectorDialogTitle');

  String get dropTargetBoxTitle =>
      Intl.message('Drag-and-drop stacktrace files to start decoding',
          name: 'dropTargetBoxTitle');

  String get decodeResultScreenTitle =>
      Intl.message('Decode result', name: 'decodeResultScreenTitle');

  String get decodeResultScreenSaveTitle =>
      Intl.message('Save result', name: 'decodeResultScreenSaveTitle');

  String get decodeResultScreenSaveAllTitle =>
      Intl.message('Save all files', name: 'decodeResultScreenSaveAllTitle');

  String get previewSelectorTitle =>
      Intl.message('Preview', name: 'previewSelectorTitle');
}

extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this);
}
