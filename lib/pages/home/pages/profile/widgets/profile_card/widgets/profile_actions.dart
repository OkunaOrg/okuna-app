import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

class OBProfileActions extends StatelessWidget {
  User user;

  OBProfileActions(this.user);

  @override
  Widget build(BuildContext context) {
    if (!user.hasProfileLocation() || !user.hasProfileUrl()) return SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        OBPrimaryButton(
          child: Text('Follow'),
          isSmall: true,
          onPressed: (){

          },
        )
      ],
    );
  }
}
