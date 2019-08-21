import 'package:Okuna/services/storage.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
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

  void storeAskToConfirmOpen(bool ask) {
    _storage?.set('askToConfirmOpen', ask.toString());
  }

  Future<bool> getAskToConfirmOpen() async {
    String ask = await _storage?.get('askToConfirmOpen');

    return ask != null ? ask.toLowerCase() == "true" : true;
  }
}

class UrlLauncherUnsupportedUrlException implements Exception {
  final String url;

  const UrlLauncherUnsupportedUrlException(this.url);

  String toString() =>
      'UrlLauncherUnsupportedUrlException: Unsupported url $url';
}
