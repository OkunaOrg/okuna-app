import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/alert.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBProfileNoPosts extends StatelessWidget {
  final User user;
  final VoidCallback onWantsToRefreshProfile;

  OBProfileNoPosts(this.user, {@required this.onWantsToRefreshProfile});

  @override
  Widget build(BuildContext context) {
    UserService _userService = OpenbookProvider.of(context).userService;
    bool isLoggedInUser = _userService.isLoggedInUser(user);
    String name = user.getProfileName();

    return Padding(
      padding: EdgeInsets.all(15),
      child: OBAlert(
          child: Row(children: [
        Padding(
          padding: EdgeInsets.only(right: 30, left: 10, top: 10, bottom: 10),
          child: Image.asset(
            'assets/images/stickers/perplexed-owl.png',
            height: 80,
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: OBText(
                      isLoggedInUser ? 'You have not shared anything yet.': '$name has not shared anything yet.',
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              OBButton(
                icon: OBIcon(
                  OBIcons.refresh,
                  size: OBIconSize.small,
                ),
                type: OBButtonType.highlight,
                child: Text('Refresh'),
                onPressed: onWantsToRefreshProfile,
              )
            ],
          ),
        )
      ])),
    );
  }
}
