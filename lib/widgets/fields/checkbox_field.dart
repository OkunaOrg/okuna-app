import 'package:Okuna/widgets/checkbox.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCheckboxField extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final String subtitle;
  final bool isDisabled;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  OBCheckboxField(
      {@required this.value,
      this.subtitle,
      this.onTap,
      this.leading,
      @required this.title,
      this.isDisabled = false,
      this.titleStyle,
      this.subtitleStyle,});

  @override
  Widget build(BuildContext context) {
    TextStyle finalTitleStyle = TextStyle(fontWeight: FontWeight.bold);
    if (titleStyle != null) finalTitleStyle = finalTitleStyle.merge(titleStyle);

    Widget field = MergeSemantics(
      child: ListTile(
          selected: value,
          leading: leading,
          title: OBText(
            title,
            style: finalTitleStyle,
          ),
          subtitle: subtitle != null ? OBText(subtitle, style: subtitleStyle,) : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OBCheckbox(
                value: value,
              )
            ],
          ),
          onTap: () {
            if (!isDisabled && onTap != null) onTap();
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
