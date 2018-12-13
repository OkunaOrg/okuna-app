import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/home.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/profile_action_more.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_follow.dart';
import 'package:flutter/material.dart';

class OBProfileActions extends StatelessWidget {
  final User user;
  final OnWantsToEditUserProfile onWantsToEditUserProfile;
  final OnWantsToPickCircles onWantsToPickCircles;

  OBProfileActions(this.user,
      {@required this.onWantsToEditUserProfile,
      @required this.onWantsToPickCircles});

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;

    bool isLoggedInUser = userService.isLoggedInUser(user);

    List<Widget> actions = [];

    if (isLoggedInUser) {
      actions.add(_buildEditButton());
    } else {
      actions.addAll([
        OBProfileActionFollow(user),
        SizedBox(
          width: 10,
        ),
        OBProfileActionMore(user,
        onWantsToPickCircles: onWantsToPickCircles)
      ]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions,
    );
  }

  _buildEditButton() {
    return OBButton(
        child: Text(
          'Edit profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          onWantsToEditUserProfile(user);
        });
  }
}
