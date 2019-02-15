import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/alerts/alert.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/tabs/image_tab.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class ObUserAvatarTab extends StatelessWidget {
  final User user;

  const ObUserAvatarTab({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OBAlert(
        borderRadius: BorderRadius.circular(OBImageTab.borderRadius),
        padding: EdgeInsets.only(bottom: 3),
        height: OBImageTab.height,
        width: OBImageTab.width *0.8,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OBAvatar(
                size: OBAvatarSize.small,
                avatarUrl: user.getProfileAvatar(),
              ),
              SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OBText(
                      'You',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
