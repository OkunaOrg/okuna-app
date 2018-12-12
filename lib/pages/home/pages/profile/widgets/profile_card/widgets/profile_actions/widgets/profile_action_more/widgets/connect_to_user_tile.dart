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

class OBConnectToUserTile extends StatefulWidget {
  final User user;
  final VoidCallback onConnectedToUser;
  final VoidCallback onWillShowModalBottomSheet;

  const OBConnectToUserTile(this.user,
      {Key key, @required this.onConnectedToUser, this.onWillShowModalBottomSheet})
      : super(key: key);

  @override
  OBConnectToUserTileState createState() {
    return OBConnectToUserTileState();
  }
}

class OBConnectToUserTileState extends State<OBConnectToUserTile> {
  UserService _userService;
  ToastService _toastService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    String userName = widget.user.getProfileName();

    return ListTile(
        title: OBText('Connect with $userName'),
        leading: OBIcon(OBIcons.add),
        onTap: _displayAddConnectionToCirclesBottomSheet);
  }

  void _displayAddConnectionToCirclesBottomSheet() {
    if(widget.onWillShowModalBottomSheet != null) widget.onWillShowModalBottomSheet();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return OBAddConnectionToCircleBottomSheet(
            title: 'Add connection to circle',
            actionLabel: 'Done',
            onWantsToAddConnectionToCircles: _onWantsToAddConnectionToCircles,
          );
        });
  }

  Future _onWantsToAddConnectionToCircles(List<Circle> circles) async {
    await _connectUserInCircles(circles);
    widget.onConnectedToUser();
  }

  Future _connectUserInCircles(List<Circle> circles) async {
    try {
      await _userService.connectWithUserWithUsername(widget.user.username,
          circles: circles);
      if (!widget.user.isFollowing) widget.user.incrementFollowersCount();
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    }
  }
}
