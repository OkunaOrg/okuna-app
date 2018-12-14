import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/circles_quick_picker.dart/widgets/circles/circles_horizontal_list.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/primary_accent_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCirclesQuickPicker extends StatefulWidget {
  final OnCirclesPicked onCirclesPicked;
  final List<Circle> initialPickedCircles;
  final List<Circle> initialCircles;
  final OnWantsToCreateNewCircle onWantsToCreateNewCircle;

  OBCirclesQuickPicker(
      {@required this.onCirclesPicked,
      this.initialPickedCircles,
      this.initialCircles,
      @required this.onWantsToCreateNewCircle});

  @override
  State<StatefulWidget> createState() {
    return OBCirclesQuickPickerState();
  }
}

class OBCirclesQuickPickerState extends State<OBCirclesQuickPicker> {
  UserService _userService;
  ToastService _toastService;

  bool _needsBootstrap;

  List<Circle> _circles;
  List<Circle> _selectedCircles;
  List<Circle> _disabledCircles;

  @override
  void initState() {
    super.initState();
    _circles =
        widget.initialCircles != null ? widget.initialCircles.toList() : [];
    _selectedCircles = widget.initialPickedCircles != null
        ? widget.initialPickedCircles.toList()
        : [];
    _needsBootstrap = true;
    _disabledCircles = [];
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildNewCircleButton(),
        Expanded(
          child: Container(
            height: 90,
            child: OBCirclesHorizontalList(
              _circles,
              selectedCircles: _selectedCircles,
              disabledCircles: _disabledCircles,
              onCirclePressed: _onCirclePressed,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildNewCircleButton() {
    return GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 60),
            child: Column(
              children: <Widget>[
                OBIcon(
                  OBIcons.add,
                  size: OBIconSize.extraLarge,
                  themeColor: OBIconThemeColor.primaryAccent,
                ),
                SizedBox(
                  height: 10,
                ),
                OBPrimaryAccentText(
                  'New circle',
                  size: OBTextSize.small,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ));
  }

  void _onCirclePressed(Circle pressedCircle) {
    if (_selectedCircles.contains(pressedCircle)) {
      // Remove
      _removeSelectedCircle(pressedCircle);
    } else {
      // Add
      _addSelectedCircle(pressedCircle);
    }

    widget.onCirclesPicked(_selectedCircles);
  }

  void _bootstrap() async {
    // If we have initial circles, no reason to refetch
    if (_circles.length > 0) return;
    CirclesList circleList = await _userService.getConnectionsCircles();
    // We assume the connections circle will always be the last one
    var connectionsCircles = circleList.circles;
    Circle connectionsCircle = connectionsCircles.removeLast();
    connectionsCircles.insert(0, connectionsCircle);
    this._setCircles(connectionsCircles);
  }

  void _setCircles(List<Circle> circles) {
    var user = _userService.getLoggedInUser();
    setState(() {
      _circles = circles;
      var connectionsCircle = _circles.firstWhere((Circle circle) {
        return circle.id == user.connectionsCircleId;
      });
      _disabledCircles = [connectionsCircle];
      _selectedCircles = [connectionsCircle];
    });
  }

  void _addSelectedCircle(Circle circle) {
    setState(() {
      _selectedCircles.add(circle);
    });
  }

  void _removeSelectedCircle(Circle circle) {
    setState(() {
      _selectedCircles.remove(circle);
    });
  }
}

typedef void OnCirclesPicked(List<Circle> selectedCircles);
typedef Future<Circle> OnWantsToCreateNewCircle();
