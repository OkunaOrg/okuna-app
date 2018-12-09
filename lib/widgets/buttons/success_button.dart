import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBSuccessButton extends StatelessWidget {
  final Widget child;
  final Widget icon;
  final VoidCallback onPressed;
  final bool isDisabled;
  final bool isLoading;
  final bool isOutlined;
  final OBButtonSize size;
  final double minWidth;
  final EdgeInsets padding;

  const OBSuccessButton(
      {@required this.child,
      @required this.onPressed,
      this.icon,
      this.size = OBButtonSize.medium,
      this.isDisabled = false,
      this.isOutlined = false,
      this.isLoading = false,
      this.padding,
      this.minWidth});

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          return OBButton(
            child: child,
            icon: icon,
            onPressed: onPressed,
            size: size,
            textColor: Pigment.fromString(theme.successColorAccent),
            color: Pigment.fromString(theme.successColor),
            isDisabled: isDisabled,
            isOutlined: isOutlined,
            isLoading: isLoading,
            padding: padding,
            minWidth: minWidth,
          );
        });
  }
}
