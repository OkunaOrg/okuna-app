import 'dart:async';
import 'dart:convert';

import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class LocalizationService {
  LocalizationService(this.locale);

  Locale locale;

  static LocalizationService of(BuildContext context) {
    StreamSubscription _onLoggedInUserChangeSubscription;
    var openbookProvider = OpenbookProvider.of(context);
    _onLoggedInUserChangeSubscription =
        openbookProvider.userService.loggedInUserChange.listen((User newUser) {
      String _userLanguageCode = openbookProvider.userService.getLoggedInUser().language.code;
      Locale _currentLocale = Localizations.localeOf(context);
      if (_userLanguageCode != _currentLocale.languageCode) {
        print('Overriding locale ${_currentLocale.languageCode} with user locale: $_userLanguageCode');
        MyApp.setLocale(context, Locale(_userLanguageCode, ''));
      }
       _onLoggedInUserChangeSubscription.cancel();
    });

    return Localizations.of<LocalizationService>(context, LocalizationService);
  }

  Map<String, String> _sentences;

  Future<bool> load() async {
    String data = await rootBundle.loadString('assets/lang/${this.locale.languageCode}.json');
    Map<String, dynamic> _result = json.decode(data);

    this._sentences = new Map();
    _result.forEach((String key, dynamic value) {
      this._sentences[key] = value.toString();
    });

    return true;
  }

  String trans(String key) {
    return this._sentences[key];
  }

  Locale getLocale() {
    return locale;
  }

}
