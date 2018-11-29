import 'package:Openbook/models/user.dart';
import 'package:flutter/material.dart';

class OBProfileUsername extends StatelessWidget {
  final User user;

  OBProfileUsername(this.user);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        var username = user?.username;

        if (username == null)
          return SizedBox(
            height: 10.0,
          );

        return Text(
          '@' + username,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
        );
      },
    );
  }
}
