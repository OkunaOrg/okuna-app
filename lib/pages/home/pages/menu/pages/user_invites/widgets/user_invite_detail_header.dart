import 'package:Openbook/models/user_invite.dart';
import 'package:Openbook/pages/home/pages/menu/pages/user_invites/widgets/user_invite_nickname.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBUserInviteDetailHeader extends StatelessWidget {
  final UserInvite userInvite;

  OBUserInviteDetailHeader(this.userInvite);

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: this.userInvite.updateSubject,
        initialData: this.userInvite,
        builder: (BuildContext context, AsyncSnapshot<UserInvite> snapshot) {
          var userInvite = snapshot.data;

          List<Widget> columnItems = [_buildUserInviteNickname(userInvite)];

          columnItems.add(_buildUserDescription(userInvite));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnItems,
          );
        });
  }

  Widget _buildUserInviteNickname(UserInvite userInvite) {

    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: OBUserInviteNickname(userInvite),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDescription(UserInvite userInvite) {
    Widget _description;
    if (userInvite.createdUser != null) {
      _description = OBActionableSmartText(text: 'Joined with username @${userInvite.createdUser.username}');
    } else if (userInvite.isInviteEmailSent) {
      _description = OBText('Pending, invite email sent to ${userInvite.email}');
    } else {
      _description = OBText('Pending');
    }

    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20, top: 10.0, bottom: 20),
      child: Column(
        children: <Widget>[
          _description,
        ],
      ),
    );
  }
}
