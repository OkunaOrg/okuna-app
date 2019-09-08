import 'package:Okuna/main.dart';
import 'package:Okuna/models/theme.dart';
import 'package:Okuna/services/storage.dart';
import 'package:Okuna/services/theme_value_parser.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';

class ThemeService {
  Stream<OBTheme> get themeChange => _themeChangeSubject.stream;
  final _themeChangeSubject = ReplaySubject<OBTheme>(maxSize: 1);

  Random random = new Random();

  OBTheme _activeTheme;

  OBStorage _storage;
  ThemeValueParserService _themeValueParserService;

  TextStyle _defaultTextStyle;

  List<OBTheme> _themes = [
    OBTheme(
        id: 1,
        name: 'White Gold',
        primaryTextColor: '#505050',
        secondaryTextColor: '#676767',
        primaryColor: '#ffffff',
        primaryAccentColor: '#e9a039,#f0c569',
        successColor: '#7ED321',
        successColorAccent: '#ffffff',
        dangerColor: '#FF3860',
        dangerColorAccent: '#ffffff',
        themePreview:
            'assets/images/theme-previews/theme-preview-white-gold.png'),
    OBTheme(
        id: 2,
        name: 'Dark Gold',
        primaryTextColor: '#ffffff',
        secondaryTextColor: '#b3b3b3',
        primaryColor: '#000000',
        primaryAccentColor: '#e9a039,#f0c569',
        successColor: '#7ED321',
        successColorAccent: '#ffffff',
        dangerColor: '#FF3860',
        dangerColorAccent: '#ffffff',
        themePreview:
            'assets/images/theme-previews/theme-preview-dark-gold.png'),
    OBTheme(
        id: 3,
        name: 'Light',
        primaryTextColor: '#505050',
        secondaryTextColor: '#676767',
        primaryColor: '#ffffff',
        primaryAccentColor: '#ffdd00,#f93476',
        successColor: '#7ED321',
        successColorAccent: '#ffffff',
        dangerColor: '#FF3860',
        dangerColorAccent: '#ffffff',
        themePreview: 'assets/images/theme-previews/theme-preview-white.png'),
    OBTheme(
        id: 4,
        name: 'Dark',
        primaryTextColor: '#ffffff',
        secondaryTextColor: '#b3b3b3',
        primaryColor: '#000000',
        primaryAccentColor: '#ffdd00,#f93476',
        successColor: '#7ED321',
        successColorAccent: '#ffffff',
        dangerColor: '#FF3860',
        dangerColorAccent: '#ffffff',
        themePreview: 'assets/images/theme-previews/theme-preview-dark.png'),
    OBTheme(
        id: 5,
        name: 'Light Blue',
        primaryAccentColor: '#045DE9, #7bd1e0',
        primaryTextColor: '#505050',
        secondaryTextColor: '#676767',
        primaryColor: '#ffffff',
        successColor: '#7ED321',
        successColorAccent: '#ffffff',
        dangerColor: '#FF3860',
        dangerColorAccent: '#ffffff',
        themePreview:
            'assets/images/theme-previews/theme-preview-light-blue.png'),
    OBTheme(
        id: 6,
        name: 'Space Blue',
        primaryTextColor: '#ffffff',
        secondaryTextColor: '#b3b3b3',
        primaryColor: '#232323',
        primaryAccentColor: '#045DE9, #7bd1e0',
        successColor: '#7ED321',
        successColorAccent: '#ffffff',
        dangerColor: '#FF3860',
        dangerColorAccent: '#ffffff',
        themePreview:
            'assets/images/theme-previews/theme-preview-space-blue.png'),
    OBTheme(
        id: 7,
        name: 'Light Rose',
        primaryAccentColor: '#D4418E, #ff84af',
        primaryTextColor: '#505050',
        secondaryTextColor: '#676767',
        primaryColor: '#ffffff',
        successColor: '#7ED321',
        successColorAccent: '#ffffff',
        dangerColor: '#FF3860',
        dangerColorAccent: '#ffffff',
        themePreview:
            'assets/images/theme-previews/theme-preview-light-rose.png'),
    OBTheme(
        id: 8,
        name: 'Space Rose',
        primaryTextColor: '#ffffff',
        secondaryTextColor: '#b3b3b3',
        primaryColor: '#232323',
        primaryAccentColor: '#D4418E, #ff84af',
        successColor: '#7ED321',
        successColorAccent: '#ffffff',
        dangerColor: '#FF3860',
        dangerColorAccent: '#ffffff',
        themePreview:
            'assets/images/theme-previews/theme-preview-space-rose.png'),
    OBTheme(
        id: 9,
        name: 'Light Royale',
        primaryAccentColor: '#5F0A87, #B621FE',
        primaryTextColor: '#505050',
        secondaryTextColor: '#676767',
        primaryColor: '#ffffff',
        successColor: '#7ED321',
        successColorAccent: '#ffffff',
        dangerColor: '#FF3860',
        dangerColorAccent: '#ffffff',
        themePreview:
        'assets/images/theme-previews/theme-preview-light-royale.png'),
    OBTheme(
        id: 10,
        name: 'Space Royale',
        primaryTextColor: '#ffffff',
        secondaryTextColor: '#b3b3b3',
        primaryColor: '#232323',
        primaryAccentColor: '#5F0A87, #B621FE',
        successColor: '#7ED321',
        successColorAccent: '#ffffff',
        dangerColor: '#FF3860',
        dangerColorAccent: '#ffffff',
        themePreview:
        'assets/images/theme-previews/theme-preview-space-royale.png'),
    OBTheme(
        id: 11,
        name: 'Light Cinnabar',
        primaryAccentColor: '#A71D31, #F53844',
        primaryTextColor: '#505050',
        secondaryTextColor: '#676767',
        primaryColor: '#ffffff',
        successColor: '#7ED321',
        successColorAccent: '#ffffff',
        dangerColor: '#FF3860',
        dangerColorAccent: '#ffffff',
        themePreview:
            'assets/images/theme-previews/theme-preview-light-cinnabar.png'),
    OBTheme(
        id: 12,
        name: 'Space Cinnabar',
        primaryTextColor: '#ffffff',
        secondaryTextColor: '#b3b3b3',
        primaryColor: '#232323',
        primaryAccentColor: '#A71D31, #F53844',
        successColor: '#7ED321',
        successColorAccent: '#ffffff',
        dangerColor: '#FF3860',
        dangerColorAccent: '#ffffff',
        themePreview:
            'assets/images/theme-previews/theme-preview-space-cinnabar.png'),
  ];

  ThemeService() {
    _setActiveTheme(_themes[2]);
    // Make sure this is the same as in lib/main.dart _getDefaultTextTheme()
    var fontFamilyFallback = ['NunitoSans', 'DejaVuSans'];
    if (isOnDesktop) {
      fontFamilyFallback = ['NunitoSans', 'Emoji', 'DejaVuSans'];
    }
    _defaultTextStyle = TextStyle(
        fontFamily: 'NunitoSans',
        fontFamilyFallback: fontFamilyFallback,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal);
  }

  void setStorageService(StorageService storageService) {
    _storage = storageService.getSystemPreferencesStorage(namespace: 'theme');
    this._bootstrap();
  }

  void setThemeValueParserService(
      ThemeValueParserService themeValueParserService) {
    _themeValueParserService = themeValueParserService;
  }

  void setActiveTheme(OBTheme theme) {
    _setActiveTheme(theme);
    _storeActiveThemeId(theme.id);
  }

  void _bootstrap() async {
    int activeThemeId = await _getStoredActiveThemeId();
    if (activeThemeId != null) {
      OBTheme activeTheme = await _getThemeWithId(activeThemeId);
      _setActiveTheme(activeTheme);
    }
  }

  void _setActiveTheme(OBTheme theme) {
    _activeTheme = theme;
    _themeChangeSubject.add(theme);
  }

  void _storeActiveThemeId(int themeId) {
    if (_storage != null) _storage.set('activeThemeId', themeId.toString());
  }

  Future<OBTheme> _getThemeWithId(int id) async {
    return _themes.firstWhere((OBTheme theme) {
      return theme.id == id;
    });
  }

  Future<int> _getStoredActiveThemeId() async {
    String activeThemeId = await _storage.get('activeThemeId');
    return activeThemeId != null ? int.parse(activeThemeId) : null;
  }

  OBTheme getActiveTheme() {
    return _activeTheme;
  }

  bool isActiveTheme(OBTheme theme) {
    return theme.id == this.getActiveTheme().id;
  }

  List<OBTheme> getCuratedThemes() {
    return _themes.toList();
  }

  String generateRandomHexColor() {
    int length = 6;
    String chars = '0123456789ABCDEF';
    String hex = '#';
    while (length-- > 0) hex += chars[(random.nextInt(16)) | 0];
    return hex;
  }

  TextStyle getDefaultTextStyle() {
    return _defaultTextStyle;
  }

  TextStyle getTextStyle(TextStyle custom) {
    return _defaultTextStyle.merge(custom);
  }

  TextStyle getThemedTextStyle(OBTheme theme) {
    return getTextStyle(TextStyle(
        color: _themeValueParserService.parseColor(theme.primaryTextColor)));
  }
}
