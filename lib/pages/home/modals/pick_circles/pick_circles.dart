import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/circles_picker/circles_picker.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPickCirclesModal extends StatefulWidget {
  final String title;

  const OBPickCirclesModal({Key key, this.title = 'Select circles'})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBPickCirclesModalState();
  }
}

class OBPickCirclesModalState extends State<OBPickCirclesModal> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  List<Circle> _latestPickedCircles;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _latestPickedCircles = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: _buildNavigationBar(),
        body: OBPrimaryColorContainer(
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
      title: widget.title,
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

typedef void OnPostCreatedCallback(PostReaction reaction);
