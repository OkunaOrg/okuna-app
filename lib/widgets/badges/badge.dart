import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBBadge extends StatelessWidget {
  static final double size = 19;
  final int count;

  const OBBadge({Key key, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;

    if (count == 0) return const SizedBox();

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;
          var primaryAccentColor =
              themeValueParserService.parseGradient(theme.primaryAccentColor);
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                gradient: primaryAccentColor,
                borderRadius: BorderRadius.circular(50)),
            child: Center(
              child: Text(
                count.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: count < 10 ? 12 : 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }
}
