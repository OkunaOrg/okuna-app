import 'package:Okuna/translation/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

class MaterialLocalizationPtBR extends MaterialLocalizationPt {

  const MaterialLocalizationPtBR({
    String localeName = 'pt-BR',
    @required intl.DateFormat fullYearFormat,
    @required intl.DateFormat mediumDateFormat,
    @required intl.DateFormat longDateFormat,
    @required intl.DateFormat yearMonthFormat,
    @required intl.NumberFormat decimalFormat,
    @required intl.NumberFormat twoDigitZeroPaddedFormat,
  }) : super(
    localeName: localeName,
    fullYearFormat: fullYearFormat,
    mediumDateFormat: mediumDateFormat,
    longDateFormat: longDateFormat,
    yearMonthFormat: yearMonthFormat,
    decimalFormat: decimalFormat,
    twoDigitZeroPaddedFormat: twoDigitZeroPaddedFormat,
  );
}

class MaterialLocalizationPtBRDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const MaterialLocalizationPtBRDelegate();

  @override
  bool isSupported(Locale locale) {
    return supportedLocales.contains(locale);
  }

  @override
  Future<MaterialLocalizationPtBR> load(Locale locale) {
    intl.DateFormat fullYearFormat;
    intl.DateFormat mediumDateFormat;
    intl.DateFormat longDateFormat;
    intl.DateFormat yearMonthFormat;
    intl.NumberFormat decimalFormat;
    intl.NumberFormat twoDigitZeroPaddedFormat;
    decimalFormat = intl.NumberFormat.decimalPattern(locale.languageCode);
    twoDigitZeroPaddedFormat = intl.NumberFormat('00', locale.languageCode);
    fullYearFormat = intl.DateFormat.y(locale.languageCode);
    mediumDateFormat = intl.DateFormat.MMMEd(locale.languageCode);
    longDateFormat = intl.DateFormat.yMMMMEEEEd(locale.languageCode);
    yearMonthFormat = intl.DateFormat.yMMMM(locale.languageCode);

    return SynchronousFuture(MaterialLocalizationPtBR(
      fullYearFormat: fullYearFormat,
      mediumDateFormat: mediumDateFormat,
      longDateFormat: longDateFormat,
      yearMonthFormat: yearMonthFormat,
      decimalFormat: decimalFormat,
      twoDigitZeroPaddedFormat: twoDigitZeroPaddedFormat
    ));
  }
  @override
  bool shouldReload(MaterialLocalizationPtBRDelegate old) => false;
}

class CupertinoLocalizationPtBR extends CupertinoLocalizationPt {

  const CupertinoLocalizationPtBR({
    String localeName = 'pt-BR',
    @required intl.DateFormat fullYearFormat,
    @required intl.DateFormat dayFormat,
    @required intl.DateFormat mediumDateFormat,
    @required intl.DateFormat singleDigitHourFormat,
    @required intl.DateFormat singleDigitMinuteFormat,
    @required intl.DateFormat doubleDigitMinuteFormat,
    @required intl.DateFormat singleDigitSecondFormat,
    @required intl.NumberFormat decimalFormat,
  }) : super(
    localeName: localeName,
    fullYearFormat: fullYearFormat,
    dayFormat: dayFormat,
    mediumDateFormat: mediumDateFormat,
    singleDigitHourFormat: singleDigitHourFormat,
    singleDigitMinuteFormat: singleDigitMinuteFormat,
    doubleDigitMinuteFormat: doubleDigitMinuteFormat,
    singleDigitSecondFormat: singleDigitSecondFormat,
    decimalFormat: decimalFormat,
  );
}


class CupertinoLocalizationPtBRDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const CupertinoLocalizationPtBRDelegate();

  @override
  bool isSupported(Locale locale) {
    return supportedLocales.contains(locale);
  }

  @override
  Future<CupertinoLocalizationPtBR> load(Locale locale) {

    intl.DateFormat fullYearFormat;
    intl.DateFormat dayFormat;
    intl.DateFormat mediumDateFormat;
    intl.DateFormat singleDigitHourFormat;
    intl.DateFormat singleDigitMinuteFormat;
    intl.DateFormat doubleDigitMinuteFormat;
    intl.DateFormat singleDigitSecondFormat;
    intl.NumberFormat decimalFormat;

    fullYearFormat = intl.DateFormat.y(locale.languageCode);
    dayFormat = intl.DateFormat.d(locale.languageCode);
    mediumDateFormat = intl.DateFormat.MMMEd(locale.languageCode);
    singleDigitHourFormat = intl.DateFormat('HH', locale.languageCode);
    singleDigitMinuteFormat = intl.DateFormat.m(locale.languageCode);
    doubleDigitMinuteFormat = intl.DateFormat('mm', locale.languageCode);
    singleDigitSecondFormat = intl.DateFormat.s(locale.languageCode);
    decimalFormat = intl.NumberFormat.decimalPattern(locale.languageCode);

    return SynchronousFuture(CupertinoLocalizationPtBR(
      fullYearFormat: fullYearFormat,
      dayFormat: dayFormat,
      mediumDateFormat: mediumDateFormat,
      singleDigitHourFormat: singleDigitHourFormat,
      singleDigitMinuteFormat: singleDigitMinuteFormat,
      doubleDigitMinuteFormat: doubleDigitMinuteFormat,
      singleDigitSecondFormat: singleDigitSecondFormat,
      decimalFormat: decimalFormat,
    ));
  }
  @override
  bool shouldReload(CupertinoLocalizationPtBRDelegate old) => false;
}