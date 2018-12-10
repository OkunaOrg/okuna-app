import 'package:Openbook/models/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:rxdart/rxdart.dart';

class ThemeService {
  Stream<OBTheme> get themeChange => _themeChangeSubject.stream;
  final _themeChangeSubject = ReplaySubject<OBTheme>(maxSize: 1);

  OBTheme _activeTheme;

  List<OBTheme> _themes = [
    OBTheme(
      id: 1,
      name: 'Not Optional',
      primaryTextColor: '#ffffff',
      secondaryTextColor: '#efefef',
      primaryColor: '#3343c2',
      primaryAccentColor: '#f7ff00,#db36a4',
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
      primaryColor: '#19182a',
      primaryAccentColor: '#f7ff00,#db36a4',
      successColor: '#7ED321',
      successColorAccent: '#ffffff',
      dangerColor: '#FF3860',
      dangerColorAccent: '#ffffff',
    ),
    OBTheme(
      id: 3,
      name: 'Gold',
      primaryTextColor: '#505050',
      secondaryTextColor: '#676767',
      primaryColor: '#ffffff',
      primaryAccentColor: '#e9a039,#f0c569',
      successColor: '#7ED321',
      successColorAccent: '#ffffff',
      dangerColor: '#FF3860',
      dangerColorAccent: '#ffffff',
    ),
    OBTheme(
      id: 3,
      name: 'Mint',
      primaryTextColor: '#ffffff',
      secondaryTextColor: '#cecece',
      primaryColor: '#333333',
      primaryAccentColor: '#f7ff00,#db36a4',
      successColor: '#7ED321',
      successColorAccent: '#ffffff',
      dangerColor: '#FF3860',
      dangerColorAccent: '#ffffff',
    ),
    OBTheme(
      id: 4,
      name: 'Deep Space',
      primaryTextColor: '#ffffff',
      secondaryTextColor: '#efefef',
      primaryColor: '#000000,#434343',
      primaryAccentColor: '#f7ff00,#db36a4',
      successColor: '#7ED321',
      successColorAccent: '#ffffff',
      dangerColor: '#FF3860',
      dangerColorAccent: '#ffffff',
    ),
    OBTheme(
      id: 4,
      name: 'Gold Haze',
      primaryTextColor: '#ffffff',
      secondaryTextColor: '#efefef',
      primaryColor: '#000000',
      primaryAccentColor: '#f7ff00,#db36a4',
      successColor: '#7ED321',
      successColorAccent: '#ffffff',
      dangerColor: '#FF3860',
      dangerColorAccent: '#ffffff',
    )
  ];

  ThemeService() {
    _setActiveTheme(_themes[2]);
  }

  void _setActiveTheme(OBTheme theme) {
    _activeTheme = theme;
    _themeChangeSubject.add(theme);
  }

  OBTheme getActiveTheme() {
    return _activeTheme;
  }
}
