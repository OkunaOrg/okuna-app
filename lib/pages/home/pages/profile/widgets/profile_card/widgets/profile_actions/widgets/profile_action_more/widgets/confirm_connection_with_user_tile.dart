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

class OBConfirmConnectionWithUserTile extends StatefulWidget {
  final User user;
  final VoidCallback onWillShowModalBottomSheet;

  const OBConfirmConnectionWithUserTile(this.user,
      {Key key,
      this.onWillShowModalBottomSheet})
      : super(key: key);

  @override
  OBConfirmConnectionWithUserTileState createState() {
    return OBConfirmConnectionWithUserTileState();
  }
}

class OBConfirmConnectionWithUserTileState
    extends State<OBConfirmConnectionWithUserTile> {
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
        title: OBText('Confirm connection with $userName'),
        leading: const OBIcon(OBIcons.check),
        onTap: _displayAddConnectionToCirclesBottomSheet);
  }

  void _displayAddConnectionToCirclesBottomSheet() {
    if (widget.onWillShowModalBottomSheet != null)
      widget.onWillShowModalBottomSheet();
    _bottomSheetService.showConnectionsCirclesPicker(
        context: context,
        title: 'Add connection to circle',
        actionLabel: 'Confirm',
        onPickedCircles: _onWantsToAddConnectionToCircles);
  }

  Future _onWantsToAddConnectionToCircles(List<Circle> circles) async {
    await _confirmConnectionWithUser(circles);
  }

  Future _confirmConnectionWithUser(List<Circle> circles) async {
    try {
      await _userService.confirmConnectionWithUserWithUsername(
          widget.user.username,
          circles: circles);
      if (!widget.user.isFollowing) widget.user.incrementFollowersCount();
      _toastService.success(message: 'Connection confirmed', context: context);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    }
  }
}
