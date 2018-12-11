import 'package:Openbook/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class OBFloatingActionButton extends StatelessWidget {
  final Widget child;
  final Widget icon;
  final VoidCallback onPressed;
  final bool isDisabled;
  final bool isLoading;
  final Color textColor;
  final OBButtonSize size;
  final double minWidth;
  final EdgeInsets padding;
  final OBButtonType type;

  const OBFloatingActionButton(
      {@required this.child,
      @required this.onPressed,
      this.type = OBButtonType.primary,
      this.size = OBButtonSize.medium,
      this.textColor = Colors.white,
      this.icon,
      this.isDisabled = false,
      this.isLoading = false,
      this.padding,
      this.minWidth});

  @override
  Widget build(BuildContext context) {
    return OBButton(
      child: child,
      boxShadow: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(0.0, 1.2),
          blurRadius: 4,
        ),
      ],
      icon: icon,
      onPressed: onPressed,
      size: size,
      type: type,
      isDisabled: isDisabled,
      isLoading: isLoading,
      padding: EdgeInsets.all(0),
      minWidth: 55,
      minHeight: 55,
    );
  }
}
