import 'package:Openbook/libs/pretty_count.dart';
import 'package:Openbook/models/language.dart';
import 'package:Openbook/widgets/circle_color_preview.dart';
import 'package:Openbook/widgets/fields/checkbox_field.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBLanguageSelectableTile extends StatelessWidget {
  final Language language;
  final OnLanguagePressed onLanguagePressed;
  final bool isSelected;
  static double circleSize = 15;

  const OBLanguageSelectableTile(this.language,
      {Key key, this.onLanguagePressed, this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return OBCheckboxField(
      value: isSelected,
      title: language.name,
      onTap: () {
        onLanguagePressed(language);
      },
    );
  }
}

typedef void OnLanguagePressed(Language pressedLanguage);
