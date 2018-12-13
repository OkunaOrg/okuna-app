import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBPostBodyText extends StatelessWidget {
  final Post _post;

  OBPostBodyText(this._post);

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;
          return Container(
            padding: EdgeInsets.all(20.0),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: _post.getText(),
                  style: TextStyle(
                      color: Pigment.fromString(theme.primaryTextColor),
                      fontSize: 16.0))
            ])),
          );
        });
  }
}
