import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/cover.dart';
import 'package:flutter/cupertino.dart';

class OBProfileCover extends StatelessWidget {
  final User user;

  OBProfileCover(this.user);

  @override
  Widget build(BuildContext context) {
    String profileCover = user.getProfileCover();
    return OBCover(profileCover);
  }
}
