import 'package:Openbook/widgets/avatars/logged-in-user-avatar.dart';
import 'package:flutter/material.dart';

class OBLoggedInUserAvatarDrawerOpener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        OBLoggedInUserAvatar(onPressed: (){
          Scaffold.of(context).openDrawer();
        },)
      ],
    );
  }
}
