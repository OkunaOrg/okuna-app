import 'package:Okuna/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBCheckbox extends StatelessWidget {
  final bool value;
  final OBCheckboxSize size;

  const OBCheckbox({
    Key key,
    this.value,
    this.size = OBCheckboxSize.medium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: OBIcon(
            value ? OBIcons.checkCircleSelected : OBIcons.checkCircle,
            customSize: 30,
            themeColor: value ? OBIconThemeColor.primaryAccent : null,
          ),
        ),
      ),
    );
  }
}

enum OBCheckboxSize { medium }
