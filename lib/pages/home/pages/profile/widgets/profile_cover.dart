import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/cover.dart';
import 'package:flutter/cupertino.dart';

class OBProfileCover extends StatelessWidget {
  final User user;

  OBProfileCover(this.user);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        String profileCover = user?.getProfileCover();

        return OBCover(
          coverUrl: profileCover,
        );
      },
    );
  }
}
