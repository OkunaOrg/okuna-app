import 'package:Openbook/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';

class OBMainDrawerHeaderAccounts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        OBLoggedInUserAvatar(
          size: OBUserAvatarSize.medium,
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
}
