import 'package:Okuna/models/user.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBProfileName extends StatelessWidget {
  final User user;

  OBProfileName(this.user);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        var name = user?.getProfileName();

        if (name == null)
          return const SizedBox(
            height: 20.0,
          );

        return OBText(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        );
      },
    );
  }
}
