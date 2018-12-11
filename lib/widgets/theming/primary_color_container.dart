import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBPrimaryColorContainer extends StatelessWidget {
  final Widget child;
  final BoxDecoration decoration;
  final EdgeInsetsGeometry padding;
  final MainAxisSize mainAxisSize;

  const OBPrimaryColorContainer(
      {Key key,
      this.child,
      this.decoration,
      this.padding,
      this.mainAxisSize = MainAxisSize.max})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          Widget container = Container(
            padding: padding,
            decoration:
                BoxDecoration(color: Pigment.fromString(theme.primaryColor)),
            child: child,
          );

          if (mainAxisSize == MainAxisSize.min) {
            return container;
          }

          return Column(
            mainAxisSize: mainAxisSize,
            children: <Widget>[Expanded(child: container)],
          );
        });
  }
}
