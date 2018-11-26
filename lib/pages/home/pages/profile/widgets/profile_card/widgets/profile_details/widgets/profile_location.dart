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

    Color color = Colors.black45;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.location_on,
          size: 14,
          color: color,
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color),
          ),
        )
      ],
    );
  }
}
