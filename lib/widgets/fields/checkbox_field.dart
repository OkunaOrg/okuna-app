import 'package:Openbook/widgets/checkbox.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCheckboxField extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final String subtitle;
  final bool isDisabled;

  OBCheckboxField(
      {@required this.value,
      this.subtitle,
      this.onTap,
      this.leading,
      @required this.title,
      this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    Widget field = MergeSemantics(
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
              )
            ],
          ),
          onTap: () {
            if (!isDisabled) onTap();
          }),
    );

    if (isDisabled) {
      field = Opacity(
        opacity: 0.5,
        child: field,
      );
    }
    return field;
  }
}
