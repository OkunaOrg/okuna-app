import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBConfirmRejectGuidelines<T> extends StatefulWidget {
  @override
  OBConfirmRejectGuidelinesState createState() {
    return OBConfirmRejectGuidelinesState();
  }
}

class OBConfirmRejectGuidelinesState extends State<OBConfirmRejectGuidelines> {
  bool _confirmationInProgress;
  UserService _userService;
  ToastService _toastService;
  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _confirmationInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _needsBootstrap = false;
    }

    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(title: 'Guidelines Rejection'),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '😬',
                      style: TextStyle(fontSize: 45.0),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OBText(
                      'You can\'t use Openspace until you accept the guidelines.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ListTile(
                      leading: const OBIcon(OBIcons.chat),
                      title: OBText('Chat with the team.'),
                      subtitle: OBSecondaryText(
                          'Start a chat immediatly.'),
                      onTap: () async {
                        openbookProvider.intercomService.displayMessenger();
                      },
                    ),
                    ListTile(
                      leading: const OBIcon(OBIcons.slackChannel),
                      title: OBText('Chat with the community.'),
                      subtitle: OBSecondaryText(
                          'Join the Slack channel.'),
                      onTap: () {
                        openbookProvider.urlLauncherService.launchUrl(
                            'https://join.slack.com/t/okuna/shared_invite/enQtNDI2NjI3MDM0MzA2LTYwM2E1Y2NhYWRmNTMzZjFhYWZlYmM2YTQ0MWEwYjYyMzcxMGI0MTFhNTIwYjU2ZDI1YjllYzlhOWZjZDc4ZWY');
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OBButton(
                      size: OBButtonSize.large,
                      type: OBButtonType.highlight,
                      child: Text('Go back'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: OBButton(
                      size: OBButtonSize.large,
                      type: OBButtonType.danger,
                      child: Text('Delete account'),
                      onPressed: () {
                        OpenbookProviderState openbookProvider =
                            OpenbookProvider.of(context);
                        openbookProvider.navigationService
                            .navigateToDeleteAccount(context: context);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        )));
  }
}
