import 'package:Openbook/models/user.dart';
import 'package:flutter/material.dart';

class OBProfileUsername extends StatelessWidget {
  final User user;

  OBProfileUsername(this.user);

  @override
  Widget build(BuildContext context) {
    String userUsername = user.username;

    return Text(
      '@' + userUsername,
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
    );
  }
}
