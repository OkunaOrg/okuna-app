import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/provider.dart';
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
    return FlatButton(
      color: Color(0xFF7ED321),
      child: Text(
        'Follow',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      onPressed: () {
        print('Follow');
        onWantsToEditUserProfile(user);
      },
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
    );
  }

  _buildEditButton() {
    return OutlineButton(
      color: Colors.black,
      child: Text(
        'Edit profile',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      borderSide: BorderSide(color: Colors.black),
      onPressed: () {
        onWantsToEditUserProfile(user);
      },
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
    );
  }
}
