import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBPrimaryColorContainer extends StatelessWidget {
  final Widget child;
  final BoxDecoration decoration;
  final EdgeInsetsGeometry padding;

  const OBPrimaryColorContainer(
      {Key key, this.child, this.decoration, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: padding,
                  decoration: BoxDecoration(
                      color: Pigment.fromString(theme.primaryColor)),
                  child: child,
                ),
              )
            ],
          );
        });
  }
}
