import 'package:Openbook/models/circle.dart';
import 'package:Openbook/pages/home/pages/menu/pages/connections_circle/widgets/connections_circle_header/widgets/connections_circle_name.dart';
import 'package:Openbook/widgets/circle_color_preview.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBConnectionsCircleHeader extends StatelessWidget {
  final Circle connectionsCircle;
  final bool isConnectionsCircle;

  OBConnectionsCircleHeader(this.connectionsCircle,
      {this.isConnectionsCircle = false});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: connectionsCircle.updateSubject,
        initialData: connectionsCircle,
        builder: (BuildContext context, AsyncSnapshot<Circle> snapshot) {
          var connectionsCircle = snapshot.data;

          List<Widget> columnItems = [_buildCircleName(connectionsCircle)];

          if (isConnectionsCircle) {
            columnItems.add(_buildConnectionsCircleDescription());
          }

          columnItems.add(_buildUsersHeader());

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnItems,
          );
        });
  }

  Widget _buildCircleName(Circle connectionsCircle) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: OBConnectionsCircleName(connectionsCircle),
          ),
          OBCircleColorPreview(
            connectionsCircle,
            size: OBCircleColorPreviewSize.large,
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionsCircleDescription() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20, top: 10.0, bottom: 20),
      child: Column(
        children: <Widget>[
          const OBText('The circle all of your connections get added to.'),
        ],
      ),
    );
  }

  Widget _buildUsersHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
      child: const OBText('Users',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
    );
  }
}
