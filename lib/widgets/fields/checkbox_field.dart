import 'package:Openbook/widgets/checkbox.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCheckboxField extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final String subtitle;

  OBCheckboxField(
      {@required this.value,
      this.onChanged,
      this.subtitle,
      this.onTap,
      this.leading,
      @required this.title});

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
          selected: value,
          leading: leading,
          title: OBText(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: subtitle != null ? OBText(subtitle) : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OBCheckbox(
                value: value,
                onChanged: onChanged,
              )
            ],
          ),
          onTap: onTap),
    );
  }
}
