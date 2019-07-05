import 'dart:async';

import 'package:Openbook/services/localization.dart';
import 'package:flutter/material.dart';

class LocalizationServiceDelegate
    extends LocalizationsDelegate<LocalizationService> {

  const LocalizationServiceDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en',
            'es',
            'nl',
            'ar',
            'zh',
            'zh-TW',
            'cs',
            'da',
            'fi',
            'fr',
            'de',
            'he',
            'hi',
            'id',
            'it',
            'ja',
            'ko',
            'ms',
            'no',
            'fa',
            'pl',
            'pt',
            'ru',
            'sv',
            'tr' ]
        .contains(locale.languageCode);
  }

  @override
  Future<LocalizationService> load(Locale locale) async {
    if (locale == null || isSupported(locale) == false) {
      print('*app_locale_delegate* fallback to locale ');

      locale = Locale('en', 'US'); // fallback to default language
    }

    LocalizationService localizations = new LocalizationService(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationServiceDelegate old) => false;
}
