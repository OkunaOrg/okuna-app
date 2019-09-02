import 'package:Okuna/models/theme.dart';
import 'package:Okuna/provider.dart';
import 'package:flutter/material.dart';

class OBHighlightedBox extends StatelessWidget {
  final Widget child;

  const OBHighlightedBox({Key key, this.child}) : super(key: key);

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

          var primaryColor =
              themeValueParserService.parseColor(theme.primaryColor);
          final bool isDarkPrimaryColor =
              primaryColor.computeLuminance() < 0.179;

          return DecoratedBox(
            decoration: BoxDecoration(
              color: isDarkPrimaryColor
                  ? Color.fromARGB(30, 255, 255, 255)
                  : Color.fromARGB(20, 0, 0, 0),
            ),
            child: child,
          );
        });
  }
}
