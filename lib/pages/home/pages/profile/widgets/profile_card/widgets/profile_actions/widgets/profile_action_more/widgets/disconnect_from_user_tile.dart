import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBDisconnectFromUserTile extends StatefulWidget {
  final User user;
  final String title;
  final VoidCallback onDisconnectedFromUser;

  const OBDisconnectFromUserTile(this.user,
      {Key key, this.title, @required this.onDisconnectedFromUser})
      : super(key: key);

  @override
  OBDisconnectFromUserTileState createState() {
    return OBDisconnectFromUserTileState();
  }
}

class OBDisconnectFromUserTileState extends State<OBDisconnectFromUserTile> {
  UserService _userService;
  ToastService _toastService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    String userName = widget.user.getProfileName();

    return ListTile(
        title: OBText(widget.title ?? 'Disconnect from $userName'),
        leading: OBIcon(OBIcons.remove),
        onTap: () async {
          await _disconnectFromUser();
          widget.onDisconnectedFromUser();
        });
  }

  Future _disconnectFromUser() async {
    try {
      await _userService.disconnectFromUserWithUsername(widget.user.username);
      widget.user.decrementFollowersCount();
      _toastService.success(
          message: 'Disconnected successfully', context: context);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
    }
  }
}
