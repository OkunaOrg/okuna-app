import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/bottom_sheet.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBConnectToUserTile extends StatefulWidget {
  final User user;
  final VoidCallback onWillShowModalBottomSheet;

  const OBConnectToUserTile(this.user,
      {Key key,
      this.onWillShowModalBottomSheet})
      : super(key: key);

  @override
  OBConnectToUserTileState createState() {
    return OBConnectToUserTileState();
  }
}

class OBConnectToUserTileState extends State<OBConnectToUserTile> {
  UserService _userService;
  ToastService _toastService;
  BottomSheetService _bottomSheetService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _bottomSheetService = openbookProvider.bottomSheetService;

    String userName = widget.user.getProfileName();

    return ListTile(
        title: OBText('Connect with $userName'),
        leading: const OBIcon(OBIcons.connect),
        onTap: _displayAddConnectionToCirclesBottomSheet);
  }

  void _displayAddConnectionToCirclesBottomSheet() {
    if (widget.onWillShowModalBottomSheet != null)
      widget.onWillShowModalBottomSheet();

    _bottomSheetService.showConnectionsCirclesPicker(
        context: context,
        title: 'Add connection to circle',
        actionLabel: 'Done',
        onPickedCircles: _onWantsToAddConnectionToCircles);
  }

  Future _onWantsToAddConnectionToCircles(List<Circle> circles) async {
    await _connectUserInCircles(circles);
  }

  Future _connectUserInCircles(List<Circle> circles) async {
    try {
      bool userWasFollowing = widget.user.isFollowing;
      await _userService.connectWithUserWithUsername(widget.user.username,
          circles: circles);
      if (!userWasFollowing && widget.user.isFollowing) {
        widget.user.incrementFollowersCount();
      }
      _toastService.success(
          message: 'Connection request sent', context: context);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    }
  }
}
