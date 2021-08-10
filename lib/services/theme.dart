import 'dart:io';
import 'dart:ui';

import 'package:Okuna/models/theme.dart';
import 'package:Okuna/services/storage.dart';
import 'package:Okuna/services/utils_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pigment/pigment.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';

class ThemeService {
  UtilsService _utilsService;

  Stream<OBTheme> get themeChange => _themeChangeSubject.stream;
  final _themeChangeSubject = ReplaySubject<OBTheme>(maxSize: 1);

  Random random = new Random();

  OBTheme _activeTheme;

  OBStorage _storage;

  List<OBTheme> _themes = [
    OBTheme(
        id: 1,
        name: 'Light',
        primaryTextColor: '#000000',
        secondaryTextColor: '#424242',
        primaryColor: '#f2f2f2',
        primaryAccentColor: '#000000,#000000',
        successColor: '#000000',
        successColorAccent: '#ffffff',
        dangerColor: '#FF3860',
        dangerColorAccent: '#ffffff',
        themePreview:
            'assets/images/theme-previews/theme-preview-white-gold.png'),
    OBTheme(
        id: 2,
        name: 'Dark',
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
  ];

  ThemeService() {
    _setActiveTheme(_themes[0]);
  }

  void setStorageService(StorageService storageService) {
    _storage = storageService.getSystemPreferencesStorage(namespace: 'theme');
    this._bootstrap();
  }

  void setUtilsService(UtilsService utilsService) {
    _utilsService = utilsService;
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
}
