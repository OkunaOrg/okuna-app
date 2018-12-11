import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/home.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/circles_picker/circles_picker.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBProfileActionMore extends StatefulWidget {
  final User user;
  final OnWantsToPickCircles onWantsToPickCircles;

  OBProfileActionMore(this.user, {@required this.onWantsToPickCircles});

  @override
  OBProfileActionMoreState createState() {
    return OBProfileActionMoreState();
  }
}

class OBProfileActionMoreState extends State<OBProfileActionMore> {
  UserService _userService;
  ToastService _toastService;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return StreamBuilder(
      stream: widget.user.updateSubject,
      initialData: widget.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        String userName = user.getProfileName();

        return IconButton(
          icon: OBIcon(
            OBIcons.moreVertical,
            customSize: 30,
          ),
          onPressed: () {
            List<Widget> bottomSheetTiles = [
              ListTile(
                leading:
                    OBIcon(user.isConnected ? OBIcons.remove : OBIcons.add),
                title: OBText(user.isConnected
                    ? 'Disconnect from $userName'
                    : 'Connect with $userName'),
                onTap: () async {
                  if (user.isConnected) {
                    await _disconnectUser();
                    Navigator.pop(context);
                  } else {
                    widget.onWantsToPickCircles();
                  }
                },
              )
            ];

            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return OBPrimaryColorContainer(
                    mainAxisSize: MainAxisSize.min,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: bottomSheetTiles),
                  );
                });
          },
        );
      },
    );
  }

  Future _displayConnectionOptions() async {
    Navigator.pop(context);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return OBPrimaryColorContainer(
            mainAxisSize: MainAxisSize.min,
            child: OBCirclesPicker(),
          );
        });
  }

  Future _connectUserInCircle() async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);
    try {
      await _userService.connectWithUserWithUsername(widget.user.username);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    } finally {
      _setRequestInProgress(false);
    }
  }

  Future _disconnectUser() async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);
    try {
      await _userService.disconnectFromUserWithUsername(widget.user.username);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
