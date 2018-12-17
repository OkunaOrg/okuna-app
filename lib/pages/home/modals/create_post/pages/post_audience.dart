import 'package:Openbook/models/circle.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/circles_picker/circles_picker.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostAudiencePage extends StatefulWidget {
  const OBPostAudiencePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBPostAudiencePageState();
  }
}

class OBPostAudiencePageState extends State<OBPostAudiencePage> {
  List<Circle> _latestPickedCircles;

  @override
  void initState() {
    super.initState();
    _latestPickedCircles = [];
  }

  @override
  Widget build(BuildContext context) {
    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: OBCirclesPicker(
            onPickedCirclesChanged: _onPickedCirclesChanged,
          ),
        ));
  }

  Widget _buildNavigationBar() {
    return OBNavigationBar(
      leading: GestureDetector(
        child: OBIcon(OBIcons.close),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: 'Post audience',
      trailing: OBButton(
        size: OBButtonSize.small,
        type: OBButtonType.primary,
        onPressed: _onDonePickingCircles,
        child: Text('Done'),
      ),
    );
  }

  void _onPickedCirclesChanged(List<Circle> pickedCircles) {
    _latestPickedCircles = [];
  }

  void _onDonePickingCircles() {
    Navigator.pop(context, _latestPickedCircles);
  }
}
