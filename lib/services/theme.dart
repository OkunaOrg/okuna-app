import 'package:Openbook/models/theme.dart';
import 'package:rxdart/rxdart.dart';

class ThemeService {
  Stream<OBTheme> get themeChange => _themeChangeSubject.stream;
  final _themeChangeSubject = ReplaySubject<OBTheme>(maxSize: 1);

  OBTheme _activeTheme;

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
    ),
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
    ),
    OBTheme(
      id: 3,
      name: 'Openbook',
      primaryTextColor: '#505050',
      secondaryTextColor: '#676767',
      primaryColor: '#ffffff',
      primaryAccentColor: '#ffdd00,f93476',
      successColor: '#7ED321',
      successColorAccent: '#ffffff',
      dangerColor: '#FF3860',
      dangerColorAccent: '#ffffff',
    ),
    OBTheme(
      id: 2,
      name: 'Dark Gold',
      primaryTextColor: '#ffffff',
      secondaryTextColor: '#b3b3b3',
      primaryColor: '#000000',
      primaryAccentColor: '#ffdd00,f93476',
      successColor: '#7ED321',
      successColorAccent: '#ffffff',
      dangerColor: '#FF3860',
      dangerColorAccent: '#ffffff',
    ),
  ];

  ThemeService() {
    _setActiveTheme(_themes[0]);
  }

  void _setActiveTheme(OBTheme theme) {
    _activeTheme = theme;
    _themeChangeSubject.add(theme);
  }

  OBTheme getActiveTheme() {
    return _activeTheme;
  }
}
