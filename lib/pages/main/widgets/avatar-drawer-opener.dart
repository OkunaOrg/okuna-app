import 'package:Openbook/widgets/avatars/logged-in-user-avatar.dart';
import 'package:flutter/material.dart';

class MainAvatarDrawerOpener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        LoggedInUserAvatar(onPressed: (){
          Scaffold.of(context).openDrawer();
        },)
      ],
    );
  }
}
