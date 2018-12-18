import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCreatePostText extends StatelessWidget {
  final TextEditingController controller;

  OBCreatePostText({this.controller});

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

          return TextField(
            controller: controller,
            autofocus: false,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(
                color: themeValueParserService.parseColor(theme.primaryTextColor),
                fontSize: 18.0),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'What\'s going on?',
                hintStyle: TextStyle(
                    color: themeValueParserService
                        .parseColor(theme.secondaryTextColor),
                    fontSize: 18.0)),
            autocorrect: true,
          );
        });
  }
}
