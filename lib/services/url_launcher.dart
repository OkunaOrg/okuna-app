import 'package:Okuna/services/storage.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  static const keyAskToConfirmOpen = 'askToConfirmOpen';
  static const keyAskToConfirmExceptions = 'askToConfirmExceptions';

  OBStorage _storage;

  Future launchUrl(String url) async {
    bool canOpenUrl = await canLaunchUrl(url);

    if (canOpenUrl) {
      await launch(url);
    } else {
      throw UrlLauncherUnsupportedUrlException(url);
    }
  }

  Future<bool> canLaunchUrl(String url){
    return canLaunch(url);
  }

  void setStorageService(StorageService storageService) {
    _storage = storageService.getSystemPreferencesStorage(namespace: 'url');
  }

  void storeAskToConfirmOpen(bool ask, {String host}) async {
    if (host == null) {
      _storage?.set(keyAskToConfirmOpen, ask.toString());
    } else {
      String exceptions = await _storage?.get(keyAskToConfirmExceptions) ?? '';

      var hasException = exceptions.contains(";$host");

      if (!hasException && !ask) {
        exceptions += ";$host";
        _storage?.set(keyAskToConfirmExceptions, exceptions);
      } else if (hasException && ask){
        exceptions.replaceAll(";$host", "");
        _storage?.set(keyAskToConfirmExceptions, exceptions);
      }
    }
  }

  Future<bool> getAskToConfirmOpen({String host}) async {
    String ask = await _storage?.get(keyAskToConfirmOpen);
    bool shouldAsk = true;

    if (ask != null && ask.toLowerCase() == "false") {
      shouldAsk = false;
    } else if (host != null) {
      String exceptions = await _storage?.get(keyAskToConfirmExceptions);

      if (exceptions != null && exceptions.contains(host)) {
        shouldAsk = false;
      }
    }

    return shouldAsk;
  }
}

class UrlLauncherUnsupportedUrlException implements Exception {
  final String url;

  const UrlLauncherUnsupportedUrlException(this.url);

  String toString() =>
      'UrlLauncherUnsupportedUrlException: Unsupported url $url';
}
