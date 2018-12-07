import 'dart:math';

import 'package:Openbook/models/theme.dart';
import 'package:rxdart/rxdart.dart';

class ThemeService {
  static List OB_LOGO_COLORS = [
    '#48d9d9',
    '#5bc855',
    '#c1dc00',
    '#ffdd00',
    '#fbba00',
    '#f18700',
    '#ff6699',
    '#f93476'
  ];

  Stream<OBTheme> get themeChange => _themeChangeSubject.stream;
  final _themeChangeSubject = ReplaySubject<OBTheme>(maxSize: 1);

  Random random = new Random();
  OBTheme _activeTheme;

  ThemeService() {
    _setActiveTheme(OBTheme(
      primaryTextColor: '#000000',
      secondaryTextColor: '#2e2e2e',
      primaryColor: '#ffffff',
      primaryColorAccent: '#f20061',
      navigationBarBackgroundColor: '#ffffff',
      navigationTabsBackgroundColor: '#ffffff',
      buttonColor: '#fafafa',
      buttonTextColor: '#000000',
      primaryButtonColor: '#7ED321',
      primaryButtonTextColor: '#ffffff',
      dangerButtonColor: '#FF3860',
      dangerButtonTextColor: '#ffffff',
      iconColor: '#000000',
      activeIconColor: '#f20061',
    ));
  }

  String getRandomObLogoHexColor() {
    return OB_LOGO_COLORS[random.nextInt(OB_LOGO_COLORS.length)];
  }

  void _setActiveTheme(OBTheme theme) {
    _activeTheme = theme;
    _themeChangeSubject.add(theme);
  }

  OBTheme getActiveTheme() {
    return _activeTheme;
  }
}
