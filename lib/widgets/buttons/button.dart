import 'package:flutter/material.dart';

class OBButton extends StatelessWidget {
  final Widget child;
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
      this.size = OBButtonSize.medium,
      this.textColor = Colors.white,
      this.color = Colors.black,
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

    var button = isOutlined
        ? _buildOutlinedButton(
            child: buttonChild,
            onPressed: finalOnPressed,
            shape: buttonShape,
            padding: buttonPadding)
        : _buildNormalButton(
            child: buttonChild,
            onPressed: finalOnPressed,
            shape: buttonShape,
            padding: buttonPadding);

    return ButtonTheme(
      minWidth: buttonMinWidth,
      child: button,
      height: minHeight,
    );
  }

  Widget _buildOutlinedButton(
      {@required child,
      @required onPressed,
      @required shape,
      @required padding}) {
    return OutlineButton(
      padding: padding,
      textColor: color,
      color: Colors.transparent,
      child: child,
      borderSide: BorderSide(color: color),
      onPressed: onPressed,
      shape: shape,
    );
  }

  Widget _buildNormalButton(
      {@required child,
      @required onPressed,
      @required shape,
      @required padding}) {
    return FlatButton(
      padding: padding,
      textColor: textColor,
      color: color,
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
        buttonPadding = EdgeInsets.symmetric(vertical: 8, horizontal: 10);
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
