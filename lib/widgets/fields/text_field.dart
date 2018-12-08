import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBTextField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final Widget prefixIcon;
  final String hintText;
  final bool autofocus;
  final String labelText;

  OBTextField(
      {this.controller,
      this.validator,
      this.prefixIcon,
      this.hintText,
      this.autofocus = false,
      this.labelText});

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: autofocus,
                    controller: controller,
                    validator: validator,
                    style: TextStyle(
                        fontSize: 22,
                        color: Pigment.fromString(theme.secondaryTextColor)),
                    decoration: InputDecoration(
                      hintText: hintText,
                      labelStyle: TextStyle(
                          height: 0.60,
                          fontWeight: FontWeight.bold,
                          color: Pigment.fromString(theme.primaryTextColor),
                          fontSize: 21),
                      hintStyle: TextStyle(
                          color: Pigment.fromString(theme.secondaryTextColor)),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      border: InputBorder.none,
                      labelText: labelText,
                      prefixIcon: prefixIcon,
                    ),
                  ),
                  Divider()
                ],
              ));
        });
  }
}
