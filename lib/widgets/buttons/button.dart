import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBButton extends StatelessWidget {
  final Widget child;
  final Widget icon;
  final VoidCallback onPressed;
  final bool isDisabled;
  final bool isLoading;
  final Color textColor;
  final Color color;
  final bool isOutlined;
  final OBButtonSize size;
  final double minWidth;
  final EdgeInsets padding;

  const OBButton(
      {@required this.child,
      @required this.onPressed,
      this.icon,
      this.size = OBButtonSize.medium,
      this.textColor,
      this.color,
      this.isDisabled = false,
      this.isOutlined = false,
      this.isLoading = false,
      this.padding,
      this.minWidth});

  @override
  Widget build(BuildContext context) {
    var buttonChild = isLoading ? _getLoadingIndicator() : child;
    var finalOnPressed = isLoading || isDisabled ? () {} : onPressed;
    var buttonShape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0));
    if (isDisabled) buttonChild = Opacity(opacity: 0.5, child: buttonChild);
    EdgeInsets buttonPadding = _getButtonPaddingForSize(size);
    double buttonMinWidth = _getButtonMinWidthForSize(size);
    double minHeight = 0;

    if (icon != null) {
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

    var themeService = OpenbookProvider.of(context).themeService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;
          var buttonColor = Pigment.fromString(theme.buttonColor);
          var buttonTextColor = Pigment.fromString(theme.buttonTextColor);

          var button = isOutlined
              ? _buildOutlinedButton(
                  child: buttonChild,
                  onPressed: finalOnPressed,
                  shape: buttonShape,
                  padding: buttonPadding,
                  btnColor: buttonColor,
                  btnTextColor: buttonTextColor)
              : _buildNormalButton(
                  child: buttonChild,
                  onPressed: finalOnPressed,
                  shape: buttonShape,
                  padding: buttonPadding,
                  btnColor: buttonColor,
                  btnTextColor: buttonTextColor);

          return ButtonTheme(
            minWidth: buttonMinWidth,
            child: button,
            height: minHeight,
          );
        });
  }

  Widget _buildOutlinedButton(
      {@required child,
      @required onPressed,
      @required shape,
      @required padding,
      Color btnColor,
      Color btnTextColor}) {
    return OutlineButton(
      padding: padding,
      textColor: color ?? btnColor,
      color: Colors.transparent,
      child: child,
      borderSide: BorderSide(color: color ?? btnColor),
      onPressed: onPressed,
      shape: shape,
    );
  }

  Widget _buildNormalButton(
      {@required child,
      @required onPressed,
      @required shape,
      @required padding,
      Color btnColor,
      Color btnTextColor}) {
    return FlatButton(
      padding: padding,
      textColor: textColor ?? btnTextColor,
      color: color ?? btnColor,
      child: child,
      onPressed: onPressed,
      shape: shape,
    );
  }

  Widget _getLoadingIndicator() {
    return SizedBox(
      height: 20.0,
      width: 20.0,
      child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor:
              AlwaysStoppedAnimation<Color>(isOutlined ? color : textColor)),
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

enum OBButtonType { primary, success, danger }

enum OBButtonSize { small, medium, large }
