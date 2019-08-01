import 'package:Okuna/widgets/theming/divider.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBToggleField extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final Widget subtitle;
  final bool hasDivider;

  OBToggleField(
      {@required this.value,
      this.onChanged,
      this.onTap,
      this.leading,
      @required this.title,
      this.hasDivider = true,
      this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MergeSemantics(
          child: ListTile(
              leading: leading,
              title: OBText(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: subtitle,
              trailing: CupertinoSwitch(
                value: value,
                onChanged: onChanged,
              ),
              onTap: onTap),
        ),
        hasDivider ? OBDivider() : const SizedBox()
      ],
    );
  }
}
