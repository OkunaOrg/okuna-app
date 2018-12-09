import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/theming/divider.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final bool autofocus;
  final InputDecoration decoration;
  final int maxLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final OBTextFormFieldSize size;

  OBTextFormField(
      {this.controller,
      this.validator,
      this.autofocus = false,
      this.keyboardType,
      this.size = OBTextFormFieldSize.medium,
      this.maxLines,
      this.textInputAction = TextInputAction.done,
      this.decoration});

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;
          double fontSize;
          double labelHeight;

          switch (size) {
            case OBTextFormFieldSize.small:
              fontSize = 14;
              labelHeight = 0;
              break;
            case OBTextFormFieldSize.medium:
              fontSize = 16;
              labelHeight = 0;
              break;
            case OBTextFormFieldSize.large:
              fontSize = 22;
              labelHeight = 0.60;
              break;
          }

          return Column(
            children: <Widget>[
              TextFormField(
                textInputAction: textInputAction,
                autofocus: autofocus,
                controller: controller,
                validator: validator,
                keyboardType: keyboardType,
                maxLines: maxLines,
                style: TextStyle(
                    fontSize: fontSize,
                    color: Pigment.fromString(theme.secondaryTextColor)),
                decoration: InputDecoration(
                  hintText: decoration.hintText,
                  labelStyle: TextStyle(
                      height: labelHeight,
                      fontWeight: FontWeight.bold,
                      color: Pigment.fromString(theme.primaryTextColor),
                      fontSize: fontSize),
                  hintStyle: TextStyle(
                      color: Pigment.fromString(theme.secondaryTextColor)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  border: InputBorder.none,
                  labelText: decoration.labelText,
                  prefixIcon: decoration.prefixIcon,
                ),
              ),
              OBDivider()
            ],
          );
        });
  }
}

enum OBTextFormFieldSize { small, medium, large }
