import 'dart:async';

import 'package:Okuna/services/localization.dart';
import 'package:Okuna/translation/constants.dart';
import 'package:flutter/material.dart';

class LocalizationServiceDelegate
    extends LocalizationsDelegate<LocalizationService> {

  const LocalizationServiceDelegate();

  @override
  bool isSupported(Locale locale) {
    return supportedLocales.contains(locale);
  }

  @override
  Future<LocalizationService> load(Locale locale) async {
    if (locale == null || isSupported(locale) == false) {
      print('*app_locale_delegate* fallback to locale ');

      locale = Locale('en', 'US'); // fallback to default language
    }
    print('Setting localisation service with ${locale.languageCode}');
    LocalizationService localizations = new LocalizationService(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationServiceDelegate old) => false;
}
