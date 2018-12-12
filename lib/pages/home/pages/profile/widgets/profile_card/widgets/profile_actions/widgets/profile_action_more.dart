import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/home.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/circles_quick_picker.dart/circles_quick_picker.dart';
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
  List<Circle> _pickedConnectionCircles;

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
    _pickedConnectionCircles = [];

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
            String connectionText;
            OBIcon connectionIcon;
            Function connectionOnTap;

            if (user.isPendingConnectionConfirmation) {
              connectionText = 'Confirm connection with $userName';
              connectionIcon = OBIcon(OBIcons.check);
              connectionOnTap = () async {
                await _confirmConnectionWithUser();
                Navigator.pop(context);
              };
            } else if (user.isFullyConnected) {
              connectionText = 'Disconnect from $userName';
              connectionIcon = OBIcon(OBIcons.remove);
              connectionOnTap = () async {
                await _disconnectUser();
                Navigator.pop(context);
              };
            } else {
              connectionText = 'Connect with $userName';
              connectionIcon = OBIcon(OBIcons.add);
              connectionOnTap = () async {
                await _displayConnectionOptions();
              };
            }

            List<Widget> bottomSheetTiles = [
              ListTile(
                leading: connectionIcon,
                title: OBText(connectionText),
                onTap: connectionOnTap,
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
                          'Add connection to circle',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        OBButton(
                            size: OBButtonSize.small,
                            child: Text('Done'),
                            onPressed: () async {
                              await _connectUserInCircles();
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OBText(
                                'Circles help you restrict who can see what you share.'),
                          ])),
                  OBCirclesQuickPicker(
                    onCirclesPicked: (List<Circle> pickedCirles) async {
                      _pickedConnectionCircles = pickedCirles;
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future _confirmConnectionWithUser() async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);
    try {
      await _userService.confirmConnectionWithUserWithUsername(
          widget.user.username,
          circles: _pickedConnectionCircles);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    } finally {
      _setRequestInProgress(false);
    }
  }

  Future _connectUserInCircles() async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);
    try {
      await _userService.connectWithUserWithUsername(widget.user.username,
          circles: _pickedConnectionCircles);
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
