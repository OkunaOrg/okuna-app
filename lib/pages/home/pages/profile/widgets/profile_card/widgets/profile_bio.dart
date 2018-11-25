import 'package:Openbook/models/user.dart';
import 'package:flutter/material.dart';

class OBProfileBio extends StatelessWidget {
  User user;

  OBProfileBio(this.user);

  @override
  Widget build(BuildContext context) {
    String bio = user.getProfileBio();

    if (bio == null) {
      return SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: Text(
              bio,
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
