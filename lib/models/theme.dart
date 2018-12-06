import 'package:Openbook/models/updatable_model.dart';
import 'package:dcache/dcache.dart';

class OBTheme extends UpdatableModel<OBTheme> {
  int id;
  String homeAccentColor;
  String searchAccentColor;
  String notificationsAccentColor;
  String communitiesAccentColor;
  String menuAccentColor;

  static final factory = OBThemeFactory();

  factory OBTheme.fromJson(Map<String, dynamic> json) {
    return factory.fromJson(json);
  }

  OBTheme(
      {this.homeAccentColor,
      this.searchAccentColor,
      this.notificationsAccentColor,
      this.communitiesAccentColor,
      this.menuAccentColor})
      : super();

  @override
  void updateFromJson(json) {
    homeAccentColor = json['home_accent_color'];
    searchAccentColor = json['search_accent_color'];
    notificationsAccentColor = json['notifications_accent_color'];
    communitiesAccentColor = json['communities_accent_color'];
  }
}

class OBThemeFactory extends UpdatableModelFactory<OBTheme> {
  @override
  SimpleCache<int, OBTheme> cache = LruCache(storage: SimpleStorage(size: 10));

  @override
  OBTheme makeFromJson(Map json) {
    return OBTheme(
        homeAccentColor: json['home_accent_color'],
        searchAccentColor: json['search_accent_color'],
        notificationsAccentColor: json['notifications_accent_color'],
        communitiesAccentColor: json['communities_accent_color'],
        menuAccentColor: json['menu_accent_color']);
  }
}
