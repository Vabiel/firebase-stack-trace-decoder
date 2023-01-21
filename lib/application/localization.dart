
import 'package:flutter/material.dart';
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
  static const supportedLangs = [/*'en', */ 'ru'];

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
}
