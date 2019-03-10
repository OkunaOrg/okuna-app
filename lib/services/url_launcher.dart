import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  Future launchUrl(String url) async {
    bool canLaunchUrl = await canLaunch(url);

    if (canLaunchUrl) {
      await launch(url);
    } else {
      throw UrlLauncherUnsupportedUrlException(url);
    }
  }
}

class UrlLauncherUnsupportedUrlException implements Exception {
  final String url;

  const UrlLauncherUnsupportedUrlException(this.url);

  String toString() =>
      'UrlLauncherUnsupportedUrlException: Unsupported url $url';
}
