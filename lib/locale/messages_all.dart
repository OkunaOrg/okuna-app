// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that looks up messages for specific locales by
// delegating to the appropriate library.

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
// ignore: implementation_imports
import 'package:intl/src/intl_helpers.dart';

import 'messages_ar.dart' as messages_ar;
import 'messages_cs.dart' as messages_cs;
import 'messages_da.dart' as messages_da;
import 'messages_de.dart' as messages_de;
import 'messages_en.dart' as messages_en;
import 'messages_es.dart' as messages_es;
import 'messages_fa.dart' as messages_fa;
import 'messages_fi.dart' as messages_fi;
import 'messages_fr.dart' as messages_fr;
import 'messages_he.dart' as messages_he;
import 'messages_hi.dart' as messages_hi;
import 'messages_id.dart' as messages_id;
import 'messages_it.dart' as messages_it;
import 'messages_ja.dart' as messages_ja;
import 'messages_ko.dart' as messages_ko;
import 'messages_ms.dart' as messages_ms;
import 'messages_nl.dart' as messages_nl;
import 'messages_no.dart' as messages_no;
import 'messages_pl.dart' as messages_pl;
import 'messages_pt.dart' as messages_pt;
import 'messages_ru.dart' as messages_ru;
import 'messages_sv.dart' as messages_sv;
import 'messages_tr.dart' as messages_tr;
import 'messages_zh-TW.dart' as messages_zh_tw;
import 'messages_zh.dart' as messages_zh;

typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
// ignore: unnecessary_new
  'ar': () => new Future.value(null),
// ignore: unnecessary_new
  'cs': () => new Future.value(null),
// ignore: unnecessary_new
  'da': () => new Future.value(null),
// ignore: unnecessary_new
  'de': () => new Future.value(null),
// ignore: unnecessary_new
  'en': () => new Future.value(null),
// ignore: unnecessary_new
  'es': () => new Future.value(null),
// ignore: unnecessary_new
  'fa': () => new Future.value(null),
// ignore: unnecessary_new
  'fi': () => new Future.value(null),
// ignore: unnecessary_new
  'fr': () => new Future.value(null),
// ignore: unnecessary_new
  'he': () => new Future.value(null),
// ignore: unnecessary_new
  'hi': () => new Future.value(null),
// ignore: unnecessary_new
  'id': () => new Future.value(null),
// ignore: unnecessary_new
  'it': () => new Future.value(null),
// ignore: unnecessary_new
  'ja': () => new Future.value(null),
// ignore: unnecessary_new
  'ko': () => new Future.value(null),
// ignore: unnecessary_new
  'ms': () => new Future.value(null),
// ignore: unnecessary_new
  'nl': () => new Future.value(null),
// ignore: unnecessary_new
  'no': () => new Future.value(null),
// ignore: unnecessary_new
  'pl': () => new Future.value(null),
// ignore: unnecessary_new
  'pt': () => new Future.value(null),
// ignore: unnecessary_new
  'ru': () => new Future.value(null),
// ignore: unnecessary_new
  'sv': () => new Future.value(null),
// ignore: unnecessary_new
  'tr': () => new Future.value(null),
// ignore: unnecessary_new
  'zh_TW': () => new Future.value(null),
// ignore: unnecessary_new
  'zh': () => new Future.value(null),
};

MessageLookupByLibrary _findExact(localeName) {
  switch (localeName) {
    case 'ar':
      return messages_ar.messages;
    case 'cs':
      return messages_cs.messages;
    case 'da':
      return messages_da.messages;
    case 'de':
      return messages_de.messages;
    case 'en':
      return messages_en.messages;
    case 'es':
      return messages_es.messages;
    case 'fa':
      return messages_fa.messages;
    case 'fi':
      return messages_fi.messages;
    case 'fr':
      return messages_fr.messages;
    case 'he':
      return messages_he.messages;
    case 'hi':
      return messages_hi.messages;
    case 'id':
      return messages_id.messages;
    case 'it':
      return messages_it.messages;
    case 'ja':
      return messages_ja.messages;
    case 'ko':
      return messages_ko.messages;
    case 'ms':
      return messages_ms.messages;
    case 'nl':
      return messages_nl.messages;
    case 'no':
      return messages_no.messages;
    case 'pl':
      return messages_pl.messages;
    case 'pt':
      return messages_pt.messages;
    case 'ru':
      return messages_ru.messages;
    case 'sv':
      return messages_sv.messages;
    case 'tr':
      return messages_tr.messages;
    case 'zh_TW':
      return messages_zh_tw.messages;
    case 'zh':
      return messages_zh.messages;
    default:
      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
Future<bool> initializeMessages(String localeName) async {
  var availableLocale = Intl.verifiedLocale(
    localeName,
    (locale) => _deferredLibraries[locale] != null,
    onFailure: (_) => null);
  if (availableLocale == null) {
    // ignore: unnecessary_new
    return new Future.value(false);
  }
  var lib = _deferredLibraries[availableLocale];
  // ignore: unnecessary_new
  await (lib == null ? new Future.value(false) : lib());
  // ignore: unnecessary_new
  initializeInternalMessageLookup(() => new CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);
  // ignore: unnecessary_new
  return new Future.value(true);
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary _findGeneratedMessagesFor(locale) {
  var actualLocale = Intl.verifiedLocale(locale, _messagesExistFor,
      onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
