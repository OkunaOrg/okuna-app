import 'package:Openbook/models/user.dart';
import 'package:flutter/material.dart';

class OBProfileBio extends StatelessWidget {
  User user;

  OBProfileBio(this.user);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        var bio = user?.getProfileBio();

        if (bio == null) return SizedBox();

        return Padding(
          padding: EdgeInsets.only(top: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: Text(
                  bio,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
