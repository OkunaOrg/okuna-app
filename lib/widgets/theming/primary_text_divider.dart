import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBPrimaryTextDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          return SizedBox(
            height: 16.0,
            child: Center(
              child: Container(
                height: 0.0,
                margin: EdgeInsetsDirectional.only(start: 0),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    color: Pigment.fromString(theme.primaryTextColor),
                    width: 1,
                  )),
                ),
              ),
            ),
          );
        });
  }
}
