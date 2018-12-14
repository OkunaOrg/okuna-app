import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/widgets/add_connection_to_circle_bottom_sheet.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBConfirmConnectionWithUserTile extends StatefulWidget {
  final User user;
  final VoidCallback onWillShowModalBottomSheet;
  final VoidCallback onConnectionConfirmed;

  const OBConfirmConnectionWithUserTile(this.user,
      {Key key,
      this.onWillShowModalBottomSheet,
      @required this.onConnectionConfirmed})
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

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    String userName = widget.user.getProfileName();

    return ListTile(
        title: OBText('Confirm connection with $userName'),
        leading: OBIcon(OBIcons.check),
        onTap: _displayAddConnectionToCirclesBottomSheet);
  }

  void _displayAddConnectionToCirclesBottomSheet() {
    if (widget.onWillShowModalBottomSheet != null)
      widget.onWillShowModalBottomSheet();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return OBAddConnectionToCircleBottomSheet(
            title: 'Add connection to circle',
            actionLabel: 'Confirm',
            onWantsToAddConnectionToCircles: _onWantsToAddConnectionToCircles,
          );
        });
  }

  Future _onWantsToAddConnectionToCircles(List<Circle> circles) async {
    await _confirmConnectionWithUser(circles);
    widget.onConnectionConfirmed();
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
