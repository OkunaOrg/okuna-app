import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/primary_text.dart';
import 'package:flutter/material.dart';

class OBProfileLocation extends StatelessWidget {
  User user;

  OBProfileLocation(this.user);

  @override
  Widget build(BuildContext context) {
    String location = user.getProfileLocation();

    if (location == null) {
      return SizedBox();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        OBIcon(
          OBIcons.location,
          customSize: 14,
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: OBPrimaryText(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
