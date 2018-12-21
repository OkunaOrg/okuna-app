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

class OBUpdateConnectionWithUserTile extends StatefulWidget {
  final User user;
  final VoidCallback onWillShowModalBottomSheet;

  const OBUpdateConnectionWithUserTile(this.user,
      {Key key, @required this.onWillShowModalBottomSheet})
      : super(key: key);

  @override
  OBUpdateConnectionWithUserTileState createState() {
    return OBUpdateConnectionWithUserTileState();
  }
}

class OBUpdateConnectionWithUserTileState
    extends State<OBUpdateConnectionWithUserTile> {
  UserService _userService;
  ToastService _toastService;
  BottomSheetService _bottomSheetService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _bottomSheetService = openbookProvider.bottomSheetService;

    return ListTile(
        title: OBText('Update connection circles'),
        leading: OBIcon(OBIcons.circles),
        onTap: _displayAddConnectionToCirclesBottomSheet);
  }

  void _displayAddConnectionToCirclesBottomSheet() {
    if (widget.onWillShowModalBottomSheet != null)
      widget.onWillShowModalBottomSheet();

    List<Circle> connectedCircles = widget.user.connectedCircles.circles;

    _bottomSheetService.showConnectionsCirclesPicker(
        context: context,
        title: 'Update connection circles',
        actionLabel: 'Save',
        initialPickedCircles: connectedCircles,
        onPickedCircles: _onWantsToUpdateConnectionCircles);
  }

  Future _onWantsToUpdateConnectionCircles(List<Circle> circles) async {
    await _updateConnectionWithUser(circles);
  }

  Future _updateConnectionWithUser(List<Circle> circles) async {
    try {
      await _userService.updateConnectionWithUsername(widget.user.username,
          circles: circles);
      if (!widget.user.isFollowing) widget.user.incrementFollowersCount();
      _toastService.success(message: 'Connection updated', context: context);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    }
  }
}
