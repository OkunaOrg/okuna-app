import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_details/widgets/profile_location.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_details/widgets/profile_url.dart';
import 'package:flutter/material.dart';

class OBProfileDetails extends StatelessWidget {
  final User user;

  const OBProfileDetails(this.user);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        if ((!user.hasProfileLocation() && !user.hasProfileUrl()))
          return const SizedBox();

        return Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: <Widget>[
                        OBProfileLocation(user),
                        OBProfileUrl(user)
                      ],
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }
}
