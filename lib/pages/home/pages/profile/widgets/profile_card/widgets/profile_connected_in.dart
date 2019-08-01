import 'package:Okuna/models/user.dart';
import 'package:Okuna/widgets/cirles_wrap.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBProfileConnectedIn extends StatelessWidget {
  final User user;

  OBProfileConnectedIn(this.user);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        var connectedCircles = user?.connectedCircles?.circles;
        bool isFullyConnected =
            user?.isFullyConnected != null && user.isFullyConnected;

        if (connectedCircles == null ||
            connectedCircles.length == 0 ||
            !isFullyConnected) return const SizedBox();

        return Padding(
            padding: EdgeInsets.only(top: 20),
            child: OBCirclesWrap(
              circles: connectedCircles,
              leading: const OBText(
                'In circles',
              ),
            ));
      },
    );
  }
}
