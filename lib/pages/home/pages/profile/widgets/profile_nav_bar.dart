import 'package:Openbook/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBProfileNavBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final User user;

  OBProfileNavBar(this.user);

  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context);

    return CupertinoNavigationBar(
      transitionBetweenRoutes: false,
      leading: route is PageRoute && route.canPop
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : SizedBox(),
      trailing: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {},
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
      middle: StreamBuilder(
          stream: user.updateSubject,
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            var user = snapshot.data;

            if (user == null) return SizedBox();

            return Text(
              '@' + user.username,
              style: TextStyle(color: Colors.black),
            );
          }),
    );
  }

  bool get fullObstruction {
    return true;
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(44);
  }
}
