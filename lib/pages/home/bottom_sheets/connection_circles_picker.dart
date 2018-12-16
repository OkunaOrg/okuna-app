import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/circles_horizontal_list/circles_horizontal_list.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBConnectionCirclesPickerBottomSheet extends StatefulWidget {
  final String title;
  final String actionLabel;
  final OnPickedCircles onPickedCircles;
  final List<Circle> initialPickedCircles;

  const OBConnectionCirclesPickerBottomSheet(
      {Key key,
      this.initialPickedCircles,
      @required this.title,
      @required this.actionLabel,
      @required this.onPickedCircles})
      : super(key: key);

  @override
  OBConnectionCirclesPickerBottomSheetState createState() {
    return OBConnectionCirclesPickerBottomSheetState();
  }
}

class OBConnectionCirclesPickerBottomSheetState
    extends State<OBConnectionCirclesPickerBottomSheet> {
  UserService _userService;
  ModalService _modalService;

  bool _needsBootstrap;

  List<Circle> _circles;
  List<Circle> _pickedCircles;
  List<Circle> _disabledCircles;

  @override
  void initState() {
    super.initState();
    _circles = [];
    _pickedCircles = widget.initialPickedCircles != null
        ? widget.initialPickedCircles.toList()
        : [];
    _needsBootstrap = true;
    _disabledCircles = [];
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _modalService = openbookProvider.modalService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return GestureDetector(
      onTap: () {},
      child: OBPrimaryColorContainer(
        mainAxisSize: MainAxisSize.min,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OBText(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  OBButton(
                      size: OBButtonSize.small,
                      child: Text(widget.actionLabel),
                      onPressed: () async {
                        await widget.onPickedCircles(_pickedCircles);
                        Navigator.pop(context);
                      }),
                ],
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OBText(
                          'Circles help you control who sees what you share.'),
                    ])),
            Container(
              height: 110,
              child: OBCirclesHorizontalList(
                _circles,
                previouslySelectedCircles: widget.initialPickedCircles,
                selectedCircles: _pickedCircles,
                disabledCircles: _disabledCircles,
                onCirclePressed: _onCirclePressed,
                onWantsToCreateANewCircle: _onWantsToCreateANewCircle,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onWantsToCreateANewCircle() async {
    Circle createdCircle =
        await _modalService.openCreateConnectionsCircle(context: context);
    if (createdCircle != null) {
      _addCircle(createdCircle);
      _addSelectedCircle(createdCircle);
    }
  }

  void _onCirclePressed(Circle pressedCircle) {
    if (_pickedCircles.contains(pressedCircle)) {
      // Remove
      _removeSelectedCircle(pressedCircle);
    } else {
      // Add
      _addSelectedCircle(pressedCircle);
    }
  }

  void _bootstrap() async {
    CirclesList circleList = await _userService.getConnectionsCircles();
    // We assume the connections circle will always be the last one
    var connectionsCircles = circleList.circles;
    Circle connectionsCircle = connectionsCircles.removeLast();
    connectionsCircles.insert(0, connectionsCircle);
    this._setCircles(connectionsCircles);
  }

  void _addCircle(Circle circle) {
    setState(() {
      _circles.add(circle);
    });
  }

  void _setCircles(List<Circle> circles) {
    var user = _userService.getLoggedInUser();
    setState(() {
      _circles = circles;
      var connectionsCircle = _circles.firstWhere((Circle circle) {
        return circle.id == user.connectionsCircleId;
      });
      _disabledCircles.removeWhere((Circle circle) {
        return !circles.contains(circle);
      });
      _pickedCircles.removeWhere((Circle circle) {
        return !circles.contains(circle);
      });
      _disabledCircles.add(connectionsCircle);
      _pickedCircles.add(connectionsCircle);
    });
  }

  void _addSelectedCircle(Circle circle) {
    setState(() {
      _pickedCircles.add(circle);
    });
  }

  void _removeSelectedCircle(Circle circle) {
    setState(() {
      _pickedCircles.remove(circle);
    });
  }
}

typedef Future<void> OnPickedCircles(List<Circle> circles);
