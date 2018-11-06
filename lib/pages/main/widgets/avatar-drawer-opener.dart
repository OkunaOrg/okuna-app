import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:flutter/material.dart';

class MainAvatarDrawerOpener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;

    return Row(
      children: <Widget>[
        GestureDetector(
          child: Container(
            height: 25.0,
            width: 25.0,
            decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: _buildUserAvatar(userService),
            ),
          ),
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
        )
      ],
    );
  }

  Widget _buildUserAvatar(UserService userService) {
    return StreamBuilder(
      stream: userService.loggedInUserChange,
      initialData: null,
      builder: (context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        var avatar;

        if (user == null) {
          avatar = AssetImage('assets/images/avatar.png');
        } else {
          avatar = NetworkImage(user.profile.avatar);
        }

        return Container(
          child: null,
          decoration: BoxDecoration(
              image: DecorationImage(image: avatar, fit: BoxFit.cover)),
        );
      },
    );
  }
}
