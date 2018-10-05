import 'dart:async';

import 'package:Openbook/services/localization.dart';
import 'package:flutter/material.dart';

class LocalizationServiceDelegate extends LocalizationsDelegate<LocalizationService> {
  const LocalizationServiceDelegate();

  @override
  bool isSupported(Locale locale) => ['es', 'en'].contains(locale.languageCode);

  @override
  Future<LocalizationService> load(Locale locale) async {
    LocalizationService localizations = new LocalizationService(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationServiceDelegate old) => false;
}