import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBAccentFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Object heroTag;

  const OBAccentFloatingActionButton(
      {Key key, this.onPressed, this.child, this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;
          return FloatingActionButton(
              heroTag: heroTag,
              backgroundColor: Pigment.fromString(theme.primaryColorAccent),
              onPressed: onPressed,
              child: child);
        });
  }
}
