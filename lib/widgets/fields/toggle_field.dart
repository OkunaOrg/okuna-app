import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBToggleField extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTap;
  final Widget leading;
  final String title;

  OBToggleField(
      {@required this.value,
      this.onChanged,
      this.onTap,
      this.leading,
      @required this.title});

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
          leading: leading,
          title: OBText(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: CupertinoSwitch(
            value: value,
            onChanged: onChanged,
          ),
          onTap: onTap),
    );
  }
}
