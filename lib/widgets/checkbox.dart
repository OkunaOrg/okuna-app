import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final OBCheckboxSize size;

  const OBCheckbox({
    Key key,
    this.value,
    this.onChanged,
    this.size = OBCheckboxSize.medium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double checkboxSize = _getCheckboxSize(size);

    return GestureDetector(
      child: Container(
        child: Center(
          child: OBIcon(
            value ? OBIcons.checkCircleSelected : OBIcons.checkCircle,
            themeColor: value ? OBIconThemeColor.primaryAccent : null,
          ),
        ),
      ),
    );
  }

  double _getCheckboxSize(OBCheckboxSize size) {
    double checkboxSize;

    switch (size) {
      case OBCheckboxSize.medium:
        checkboxSize = 20;
        break;
    }

    return checkboxSize;
  }
}

enum OBCheckboxSize { medium }
