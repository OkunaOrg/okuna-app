import 'package:flutter/material.dart';

class OBPrimaryButton extends StatelessWidget {
  static const double LARGE_HEIGHT = 46.0;
  static const double NORMAL_HEIGHT = 44.0;
  static const double SMALL_HEIGHT = 30.0;

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback onPressed;

  final bool isLarge;
  final bool isSmall;
  final bool isDisabled;
  final bool isFullWidth;
  final bool isLoading;

  const OBPrimaryButton(
      {@required this.child,
      @required this.onPressed,
      this.isDisabled = false,
      this.isLoading = false,
      this.isLarge = false,
      this.isSmall = false,
      this.isFullWidth = false});

  @override
  Widget build(BuildContext context) {
    double height;

    if (isLarge) {
      height = LARGE_HEIGHT;
    } else if (isSmall) {
      height = SMALL_HEIGHT;
    } else {
      height = NORMAL_HEIGHT;
    }

    double minWidth;

    if (isFullWidth) {
      minWidth = double.infinity;
    } else {
      minWidth = 88.0;
    }

    var buttonChild = isLoading ? _getLoadingIndicator() : child;

    var button = FlatButton(
        textColor: Colors.white,
        color: Color(0xFF7ED321),
        child: buttonChild,
        onPressed: isLoading ? () {} : onPressed,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)));

    return ButtonTheme(
        minWidth: minWidth,
        height: height,
        child: isDisabled
            ? Opacity(
                opacity: 0.5,
                child: button,
              )
            : button);
  }

  Widget _getLoadingIndicator() {
    return SizedBox(
      height: 20.0,
      width: 20.0,
      child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)),
    );
  }
}
