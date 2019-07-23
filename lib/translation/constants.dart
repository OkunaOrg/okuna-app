import 'dart:core';
import 'dart:ui';

const supportedLocales = [
  const Locale('en', 'US'),
// const Locale('nl', 'NL'),
// const Locale('ar', 'SA'),
// const Locale('zh', 'CN'),
// const Locale('zh-TW', 'TW'),
// const Locale('cs', 'CZ'),
// const Locale('da', 'DK'),
// const Locale('fi', 'FI'),
// const Locale('fr', 'FR'),
// const Locale('de', 'DE'),
// const Locale('he', 'IL'),
// const Locale('hi', 'IN'),
// const Locale('id', 'ID'),
// const Locale('it', 'IT'),
// const Locale('ja', 'JP'),
// const Locale('ko', 'KR'),
// const Locale('ms', 'MY'),
// const Locale('no', 'NO'),
// const Locale('fa', 'IR'),
// const Locale('pl', 'PL'),
// const Locale('pt', 'BR'),
// const Locale('ru', 'RU'),
// const Locale('sv', 'SE'),
// const Locale('tr', 'TR'),
];

var supportedLanguages = supportedLocales.map((Locale locale) => locale.languageCode).toList();

