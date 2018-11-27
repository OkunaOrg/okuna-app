import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/buttons/primary_button.dart';
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
        isLoggedInUser ? _buildEditButton() : _buildFollowButton()
      ],
    );
  }

  _buildFollowButton() {
    return OBPrimaryButton(
      child: Text('Follow'),
      isSmall: true,
      onPressed: () {

      },
    );
  }

  _buildEditButton() {
    return OBPrimaryButton(
      child: Text('Edit'),
      isSmall: true,
      onPressed: () {
        onWantsToEditUserProfile(user);
      },
    );
  }
}
