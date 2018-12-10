import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';

class OBButton extends StatelessWidget {
  final Widget child;
  final Widget icon;
  final VoidCallback onPressed;
  final bool isDisabled;
  final bool isLoading;
  final bool isOutlined;
  final OBButtonSize size;
  final double minWidth;
  final EdgeInsets padding;
  final OBButtonType type;
  final ShapeBorder shape;

  const OBButton(
      {@required this.child,
      @required this.onPressed,
      this.type,
      this.icon,
      this.size = OBButtonSize.medium,
      this.shape,
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

          var buttonChild = isLoading ? _getLoadingIndicator(theme) : child;
          var finalOnPressed = isLoading || isDisabled ? () {} : onPressed;
          if (isDisabled)
            buttonChild = Opacity(opacity: 0.5, child: buttonChild);
          EdgeInsets buttonPadding = _getButtonPaddingForSize(size);
          double buttonMinWidth = _getButtonMinWidthForSize(size);
          double minHeight = 0;

          if (icon != null && !isLoading) {
            buttonChild = Row(
              children: <Widget>[
                icon,
                SizedBox(
                  width: 5,
                ),
                buttonChild
              ],
            );
          }

          var themeValueParser =
              OpenbookProvider.of(context).themeValueParserService;

          Color buttonTextColor =
              themeValueParser.parseColor(theme.primaryColor);
          Gradient gradient =
              themeValueParser.parseGradient(theme.primaryAccentColor);

          return GestureDetector(
            child: Container(
                constraints: BoxConstraints(
                    minWidth: buttonMinWidth, minHeight: minHeight),
                decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(50.0)),
                child: Material(
                  color: Colors.transparent,
                  textStyle: TextStyle(color: buttonTextColor),
                  child: Padding(
                    padding: buttonPadding,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[child],
                    ),
                  ),
                )),
            onTap: finalOnPressed,
          );
        });
  }

  Widget _getLoadingIndicator(OBTheme theme) {
    return SizedBox(
      height: 20.0,
      width: 20.0,
      child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
    );
  }

  EdgeInsets _getButtonPaddingForSize(OBButtonSize type) {
    if (padding != null) return padding;

    EdgeInsets buttonPadding;

    switch (size) {
      case OBButtonSize.large:
        buttonPadding = EdgeInsets.symmetric(vertical: 10, horizontal: 20.0);
        break;
      case OBButtonSize.medium:
        buttonPadding = EdgeInsets.symmetric(vertical: 8, horizontal: 12);
        break;
      case OBButtonSize.small:
        buttonPadding = EdgeInsets.symmetric(vertical: 5, horizontal: 2);
        break;
      default:
    }

    return buttonPadding;
  }

  double _getButtonMinWidthForSize(OBButtonSize type) {
    if (minWidth != null) return minWidth;

    double buttonMinWidth;

    switch (size) {
      case OBButtonSize.large:
      case OBButtonSize.medium:
        buttonMinWidth = 100;
        break;
      case OBButtonSize.small:
        buttonMinWidth = 70;
        break;
      default:
    }

    return buttonMinWidth;
  }
}

enum OBButtonType { primary, primaryAccent, success, danger }

enum OBButtonSize { small, medium, large }
