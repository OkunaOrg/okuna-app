import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  Future launchUrl(String url) async {
    bool canOpenUrl = await canLaunchUrl(url);

    if (canOpenUrl) {
      await launch(
        url,
        universalLinksOnly: true,
        forceSafariVC: false,
      );
    } else {
      try {
        await launch(url);
      } on Exception {
        await launch(url, forceWebView: true);
      }
      throw UrlLauncherUnsupportedUrlException(url);
    }
  }

  Future<bool> canLaunchUrl(String url) {
    return canLaunch(url);
  }
}

class UrlLauncherUnsupportedUrlException implements Exception {
  final String url;

  const UrlLauncherUnsupportedUrlException(this.url);

  String toString() =>
      'UrlLauncherUnsupportedUrlException: Unsupported url $url';
}
