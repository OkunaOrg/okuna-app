import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBAlert extends StatefulWidget {
  final Widget child;

  const OBAlert({Key key, this.child}) : super(key: key);

  @override
  OBAlertState createState() {
    return OBAlertState();
  }
}

class OBAlertState extends State<OBAlert> {
  bool isVisible;

  @override
  void initState() {
    super.initState();
    isVisible = true;
  }

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

          return Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
            decoration: BoxDecoration(
                color: isDarkPrimaryColor
                    ? Color.fromARGB(20, 255, 255, 255)
                    : Color.fromARGB(10, 0, 0, 0),
                borderRadius: BorderRadius.circular(10)),
            child: widget.child,
          );
        });
  }
}
