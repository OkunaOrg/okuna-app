import 'package:Openbook/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBProfilePage extends StatelessWidget {
  User user;

  OBProfilePage(this.user);

  @override
  Widget build(BuildContext context) {
    String username = user.username;
    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
      child: Container(
        child: Text('Profile of user $username'),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: Colors.white,
      middle: Text('Profile'),
    );
  }
}
