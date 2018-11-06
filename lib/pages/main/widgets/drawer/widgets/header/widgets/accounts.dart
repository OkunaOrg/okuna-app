import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:flutter/material.dart';

class MainDrawerHeaderAccounts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;

    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(10.0)),
          height: 39.0,
          width: 39.0,
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: _buildUserAvatar(userService),
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                  child: Icon(Icons.more_horiz),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10.0)),
                  height: 25.0,
                  width: 25.0),
            ],
          ),
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
