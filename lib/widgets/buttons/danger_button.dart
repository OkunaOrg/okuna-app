import 'package:Openbook/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class OBDangerButton extends StatelessWidget {
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

  const OBDangerButton(
      {@required this.child,
      @required this.onPressed,
      this.size = OBButtonSize.medium,
      this.textColor = Colors.white,
      this.color = const Color(0xFFFF3860),
      this.isDisabled = false,
      this.isOutlined = false,
      this.isLoading = false,
      this.padding,
      this.minWidth});

  @override
  Widget build(BuildContext context) {
    return OBButton(
      child: child,
      onPressed: onPressed,
      size: size,
      textColor: textColor,
      color: color,
      isDisabled: isDisabled,
      isOutlined: isOutlined,
      isLoading: isLoading,
      padding: padding,
      minWidth: minWidth,
    );
  }
}
