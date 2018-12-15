import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/circle_color_preview.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBProfileConnectedIn extends StatelessWidget {
  final User user;

  OBProfileConnectedIn(this.user);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        var connectedCircles = user?.connectedCircles?.circles;
        bool isFullyConnected =
            user?.isFullyConnected != null && user.isFullyConnected;

        if (connectedCircles == null ||
            connectedCircles.length == 0 ||
            !isFullyConnected) return SizedBox();

        List<Widget> connectionItems = [
          OBText(
            'Connected in circles',
            size: OBTextSize.small,
          )
        ];

        connectedCircles.forEach((Circle circle) {
          connectionItems.add(Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OBCircleColorPreview(
                circle,
                size: OBCircleColorPreviewSize.extraSmall,
              ),
              SizedBox(
                width: 5,
              ),
              OBText(
                circle.name,
                size: OBTextSize.small,
              )
            ],
          ));
        });

        return Padding(
          padding: EdgeInsets.only(top: 20),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: connectionItems,
          ),
        );
      },
    );
  }
}
