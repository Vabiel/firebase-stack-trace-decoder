import 'package:firebase_stacktrace_decoder/screens/edit_project/edit_project_screen.dart';
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

  String get editProjectScreenDeleteButtonTitle =>
      Intl.message('Delete', name: 'editProjectScreenDeleteButtonTitle');

  String get editProjectScreenCancelButtonTitle =>
      Intl.message('Cancel', name: 'editProjectScreenCancelButtonTitle');

  String get editProjectScreenSaveButtonTitle =>
      Intl.message('Save', name: 'editProjectScreenSaveButtonTitle');

  String get editProjectScreenYesButtonTitle =>
      Intl.message('Yes', name: 'editProjectScreenYesButtonTitle');

  String get deleteProjectDialogTitle =>
      Intl.message('Delete project', name: 'deleteProjectDialogTitle');

  String get deleteProjectDialogText =>
      Intl.message('Do you really want to do that?',
          name: 'deleteProjectDialogText');
}

extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this);
}
