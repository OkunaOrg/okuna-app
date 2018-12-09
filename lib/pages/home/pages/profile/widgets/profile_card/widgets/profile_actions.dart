import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/follow_button.dart';
import 'package:Openbook/widgets/theming/primary_text.dart';
import 'package:flutter/material.dart';

class OBProfileActions extends StatelessWidget {
  final User user;
  final OnWantsToEditUserProfile onWantsToEditUserProfile;

  OBProfileActions(this.user, {this.onWantsToEditUserProfile});

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;

    bool isLoggedInUser = userService.isLoggedInUser(user);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        isLoggedInUser ? _buildEditButton() : OBFollowButton(user)
      ],
    );
  }

  _buildEditButton() {
    return OBButton(
        child: OBPrimaryText(
          'Edit profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          onWantsToEditUserProfile(user);
        },
        isOutlined: true);
  }
}
