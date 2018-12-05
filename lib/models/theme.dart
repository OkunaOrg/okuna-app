import 'package:dcache/dcache.dart';
import 'package:rxdart/rxdart.dart';

class OBTheme {
  int id;
  String homeAccentColor;
  String searchAccentColor;
  String notificationsAccentColor;
  String communitiesAccentColor;
  String menuAccentColor;

  Stream<OBTheme> get updateChange => _updateChangeSubject.stream;
  final _updateChangeSubject = ReplaySubject<OBTheme>(maxSize: 1);

  OBTheme(
      {this.homeAccentColor,
      this.searchAccentColor,
      this.notificationsAccentColor,
      this.communitiesAccentColor,
      this.menuAccentColor}) {
    _notifyUpdate();
  }

  factory OBTheme.fromJson(Map<String, dynamic> json) {
    int themeId = json['id'];

    OBTheme theme = getThemeWithIdFromCache(themeId);

    if (theme != null) {
      theme.updateFromJson(json);
      return theme;
    }

    theme = _makeFromJson(json);
    addToCache(theme);
    return theme;
  }

  static OBTheme _makeFromJson(json) {
    return OBTheme(
        homeAccentColor: json['home_accent_color'],
        searchAccentColor: json['search_accent_color'],
        notificationsAccentColor: json['notifications_accent_color'],
        communitiesAccentColor: json['communities_accent_color'],
        menuAccentColor: json['menu_accent_color']);
  }

  static final SimpleCache<int, OBTheme> cache =
      LruCache(storage: SimpleStorage(size: 10));

  static OBTheme getThemeWithIdFromCache(int themeId) {
    return cache.get(themeId);
  }

  static void addToCache(OBTheme theme) {
    cache.set(theme.id, theme);
  }

  static void clearCache() {
    cache.clear();
  }

  void updateFromJson(json) {
    homeAccentColor = json['home_accent_color'];
    searchAccentColor = json['search_accent_color'];
    notificationsAccentColor = json['notifications_accent_color'];
    communitiesAccentColor = json['communities_accent_color'];
    _notifyUpdate();
  }

  void _notifyUpdate() {
    _updateChangeSubject.add(this);
  }
}
