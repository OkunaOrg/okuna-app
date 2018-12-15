import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/alert.dart';
import 'package:Openbook/widgets/buttons/actions/confirm_connection_button.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBProfileConnectionRequest extends StatelessWidget {
  final User user;

  OBProfileConnectionRequest(this.user);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        var isPendingConnectionConfirmation =
            user?.isPendingConnectionConfirmation;

        if (isPendingConnectionConfirmation == null ||
            !isPendingConnectionConfirmation) return SizedBox();

        String userName = user.getProfileName();

        return Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            OBAlert(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: OBText(
                      '$userName has sent you a connection request.',
                      maxLines: 4,
                      size: OBTextSize.medium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  OBConfirmConnectionButton(user)
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
