import 'package:Openbook/models/user.dart';
import 'package:flutter/material.dart';

class OBProfileLocation extends StatelessWidget {
  User user;

  OBProfileLocation(this.user);

  @override
  Widget build(BuildContext context) {
    String location = user.getProfileLocation();

    if (location == null) {
      return SizedBox();
    }

    Color color = Colors.black26;

    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            Icons.location_on,
            size: 16,
            color: color,
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              location,
              style: TextStyle(color: color),
            ),
          )
        ],
      ),
    );
  }
}
