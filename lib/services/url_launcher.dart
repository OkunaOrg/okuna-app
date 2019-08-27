import 'package:Okuna/services/bottom_sheet.dart';
import 'package:Okuna/services/url_parser.dart';
import 'package:Okuna/services/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  UserPreferencesService _preferencesService;
  BottomSheetService _bottomSheetService;
  UrlParserService _urlParserService;

  void setUserPreferencesService(UserPreferencesService preferencesService) {
    _preferencesService = preferencesService;
  }

  void setBottomSheetService(BottomSheetService bottomSheetService) {
    _bottomSheetService = bottomSheetService;
  }

  void setUrlParserService(UrlParserService urlParserService) {
    _urlParserService = urlParserService;
  }

  Future launchUrlWithoutConfirmation(String url) async {
    return await _launchUrl(url, showConfirmation: false);
  }

  Future launchUrlWithConfirmation(String url, BuildContext context) async {
    return await _launchUrl(url, context: context);
  }

  Future _launchUrl(String url,
      {bool showConfirmation = true, BuildContext context}) async {
    if (await canLaunchUrl(url)) {
      if (!showConfirmation || await requestConfirmation(url, context)) {
        await launch(url);
      }
    } else {
      throw UrlLauncherUnsupportedUrlException(url);
    }
  }

  Future<bool> canLaunchUrl(String url) {
    return canLaunch(url);
  }

  Future<bool> requestConfirmation(String url, BuildContext context) async {
    var parsedUrl = _urlParserService.parse(url);
    var approved;

    if (await _preferencesService.getAskToConfirmOpenUrl(host: parsedUrl)) {
      approved = await _bottomSheetService.showConfirmOpenUrl(
          link: parsedUrl, context: context);
    } else {
      approved = true;
    }

    return approved;
  }
}

class UrlLauncherUnsupportedUrlException implements Exception {
  final String url;

  const UrlLauncherUnsupportedUrlException(this.url);

  String toString() =>
      'UrlLauncherUnsupportedUrlException: Unsupported url $url';
}
