import 'package:Openbook/models/updatable_model.dart';
import 'package:dcache/dcache.dart';

class OBTheme extends UpdatableModel<OBTheme> {
  int id;
  String primaryTextColor;
  String secondaryTextColor;

  String primaryColor;
  String primaryColorAccent;

  String buttonColor;
  String buttonTextColor;

  String primaryButtonColor;
  String primaryButtonTextColor;

  String dangerButtonColor;
  String dangerButtonTextColor;

  static final factory = OBThemeFactory();

  factory OBTheme.fromJson(Map<String, dynamic> json) {
    return factory.fromJson(json);
  }

  OBTheme(
      {this.id,
      this.primaryColor,
      this.primaryColorAccent,
      this.buttonColor,
      this.buttonTextColor,
      this.dangerButtonColor,
      this.dangerButtonTextColor,
      this.primaryButtonColor,
      this.primaryButtonTextColor,
      this.primaryTextColor,
      this.secondaryTextColor})
      : super();

  @override
  void updateFromJson(Map json) {
    primaryTextColor = json['primary_text_color'];
    secondaryTextColor = json['secondary_text_color'];
    primaryColor = json['primary_color'];
    primaryColorAccent = json['primary_color_accent'];
    buttonColor = json['button_color'];
    buttonTextColor = json['button_text_color'];
    primaryButtonColor = json['primary_button_color'];
    primaryButtonTextColor = json['primary_button_text_color'];
    dangerButtonColor = json['danger_button_color'];
    dangerButtonTextColor = json['danger_button_text_color'];
  }
}

class OBThemeFactory extends UpdatableModelFactory<OBTheme> {
  @override
  SimpleCache<int, OBTheme> cache = LruCache(storage: SimpleStorage(size: 10));

  @override
  OBTheme makeFromJson(Map json) {
    return OBTheme(
      primaryTextColor: json['primary_text_color'],
      secondaryTextColor: json['secondary_text_color'],
      primaryColor: json['primary_color'],
      primaryColorAccent: json['primary_color_accent'],
      buttonColor: json['button_color'],
      buttonTextColor: json['button_text_color'],
      primaryButtonColor: json['primary_button_color'],
      primaryButtonTextColor: json['primary_button_text_color'],
      dangerButtonColor: json['danger_button_color'],
      dangerButtonTextColor: json['danger_button_text_color'],
    );
  }
}
