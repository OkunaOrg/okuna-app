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

  List<OBTheme> _themes = [
    OBTheme(
      id: 1,
      name: 'Not Optional',
      primaryTextColor: '#ffffff',
      secondaryTextColor: '#efefef',
      primaryColor: '#3343c2',
      primaryAccentColor: '#fffc00',
      successColor: '#7ED321',
      successColorAccent: '#ffffff',
      dangerColor: '#FF3860',
      dangerColorAccent: '#ffffff',
    ),
    OBTheme(
      id: 2,
      name: 'Space Blue',
      primaryTextColor: '#ffffff',
      secondaryTextColor: '#efefef',
      primaryColor: '#3343c2',
      primaryAccentColor: '#fffc00',
      successColor: '#7ED321',
      successColorAccent: '#ffffff',
      dangerColor: '#FF3860',
      dangerColorAccent: '#ffffff',
    ),
    OBTheme(
      id: 3,
      name: 'Nocturnal',
      primaryTextColor: '#ffffff',
      secondaryTextColor: '#efefef',
      primaryColor: '#3343c2',
      primaryAccentColor: '#fffc00',
      successColor: '#7ED321',
      successColorAccent: '#ffffff',
      dangerColor: '#FF3860',
      dangerColorAccent: '#ffffff',
    ),
    OBTheme(
      id: 3,
      name: 'Nocturnal',
      primaryTextColor: '#ffffff',
      secondaryTextColor: '#efefef',
      primaryColor: '#3343c2',
      primaryAccentColor: '#fffc00',
      successColor: '#7ED321',
      successColorAccent: '#ffffff',
      dangerColor: '#FF3860',
      dangerColorAccent: '#ffffff',
    ),
    OBTheme(
      id: 4,
      name: 'Gold',
      primaryTextColor: '#ffffff',
      secondaryTextColor: '#efefef',
      primaryColor: '#3343c2',
      primaryAccentColor: '#fffc00',
      successColor: '#7ED321',
      successColorAccent: '#ffffff',
      dangerColor: '#FF3860',
      dangerColorAccent: '#ffffff',
    ),
  ];

  ThemeService() {
    _setActiveTheme(_themes[1]);
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
