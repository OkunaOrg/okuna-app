import 'package:Openbook/models/user.dart';
import 'package:flutter/material.dart';

class OBProfileName extends StatelessWidget {
  final User user;

  OBProfileName(this.user);

  @override
  Widget build(BuildContext context) {
    String profileName = user.getProfileName();

    if (profileName == null) return SizedBox();
    return Text(
      profileName,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }
}
