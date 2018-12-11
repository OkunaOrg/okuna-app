import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/widgets/circles_picker/circles_picker.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPickCirclesModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBPickCirclesModalState();
  }
}

class OBPickCirclesModalState extends State<OBPickCirclesModal> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: _buildNavigationBar(),
        body: OBPrimaryColorContainer(
          child: OBCirclesPicker(
            onCirclesPicked: _onCirclesPicked,
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
        title: 'Pick Circles');
  }

  void _onCirclesPicked(List<Circle> pickedCircles) {
    Navigator.pop(context, pickedCircles);
  }
}

typedef void OnPostCreatedCallback(PostReaction reaction);
