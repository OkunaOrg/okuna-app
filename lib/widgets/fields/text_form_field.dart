import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/theming/divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OBTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final bool autofocus;
  final InputDecoration decoration;
  final int maxLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final OBTextFormFieldSize size;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final List<TextInputFormatter> inputFormatters;

  const OBTextFormField(
      {this.controller,
      this.validator,
      this.autofocus = false,
      this.keyboardType,
      this.inputFormatters,
      this.obscureText = false,
      this.autocorrect = true,
      this.size = OBTextFormFieldSize.medium,
      this.maxLines,
      this.textInputAction = TextInputAction.done,
      this.decoration,
      this.textCapitalization = TextCapitalization.none});

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;

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
                inputFormatters: inputFormatters,
                textCapitalization: textCapitalization,
                textInputAction: textInputAction,
                autofocus: autofocus,
                controller: controller,
                validator: validator,
                keyboardType: keyboardType,
                autocorrect: autocorrect,
                maxLines: maxLines,
                obscureText: obscureText,
                style: TextStyle(
                    fontSize: fontSize,
                    color: themeValueParserService
                        .parseColor(theme.primaryTextColor)),
                decoration: InputDecoration(
                  hintText: decoration.hintText,
                  labelStyle: TextStyle(
                      height: labelHeight,
                      fontWeight: FontWeight.bold,
                      color: themeValueParserService
                          .parseColor(theme.secondaryTextColor),
                      fontSize: fontSize),
                  hintStyle: TextStyle(
                      color: themeValueParserService
                          .parseColor(theme.primaryTextColor)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  border: InputBorder.none,
                  labelText: decoration.labelText,
                  prefixIcon: decoration.prefixIcon,
                  prefixText: decoration.prefixText,
                ),
              ),
              OBDivider()
            ],
          );
        });
  }
}

enum OBTextFormFieldSize { small, medium, large }
