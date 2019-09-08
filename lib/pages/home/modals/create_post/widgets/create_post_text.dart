import 'package:Okuna/models/theme.dart';
import 'package:Okuna/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCreatePostText extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;

  OBCreatePostText({this.controller, this.focusNode, this.hintText});

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
            autofocus: true,
            focusNode: focusNode,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: themeService.getThemedTextStyle(theme).merge(TextStyle(
                fontSize: 18.0)),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: this.hintText != null ? this.hintText : 'What\'s going on?',
                hintStyle: themeService.getDefaultTextStyle().merge(TextStyle(
                    color: themeValueParserService
                        .parseColor(theme.secondaryTextColor),
                    fontSize: 18.0))),
            autocorrect: true,
          );
        });
  }
}
