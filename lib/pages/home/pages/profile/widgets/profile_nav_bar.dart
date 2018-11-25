import 'package:Openbook/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBProfileNavBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  User user;

  OBProfileNavBar(this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  bool get fullObstruction {
    return false;
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(44);
  }
}
