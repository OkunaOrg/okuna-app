import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBTextField extends StatelessWidget {
  final TextStyle style;
  final FocusNode focusNode;
  final TextEditingController controller;
  final InputDecoration decoration;
  final bool autocorrect;
  final bool autofocus;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final int maxLines;
  final FormFieldValidator<String> validator;

  OBTextField(
      {this.style,
      this.focusNode,
      this.controller,
      this.validator,
      this.maxLines,
      this.decoration,
      this.autocorrect = false,
      this.autofocus = false,
      this.keyboardType,
      this.textInputAction = TextInputAction.done});

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          TextStyle themedTextStyle =
              TextStyle(color: Pigment.fromString(theme.primaryTextColor));

          if (style != null) {
            themedTextStyle = themedTextStyle.merge(style);
          }

          TextStyle hintTextStyle =
              TextStyle(color: Pigment.fromString(theme.secondaryTextColor));

          if (decoration != null && decoration.hintStyle != null) {
            hintTextStyle = hintTextStyle.merge(decoration.hintStyle);
          }

          return TextField(
            textInputAction: textInputAction,
            focusNode: focusNode,
            controller: controller,
            keyboardType: keyboardType,
            style: themedTextStyle,
            maxLines: maxLines,
            decoration: InputDecoration(
                hintText: decoration.hintText,
                hintStyle: hintTextStyle,
                contentPadding: decoration.contentPadding,
                border: decoration.border),
            autocorrect: autocorrect,
            autofocus: autofocus,
          );
        });
  }
}
