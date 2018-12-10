import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBCreatePostText extends StatelessWidget {
  final TextEditingController controller;

  OBCreatePostText({this.controller});

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          return TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(
                color: Pigment.fromString(theme.primaryTextColor),
                fontSize: 18.0),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'What\'s going on?',
                hintStyle: TextStyle(
                    color: Pigment.fromString(theme.secondaryTextColor),
                    fontSize: 18.0)),
            autocorrect: true,
          );
        });
  }
}
