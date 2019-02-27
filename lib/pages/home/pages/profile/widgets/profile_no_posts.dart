import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/alerts/alert.dart';
import 'package:Openbook/widgets/alerts/button_alert.dart';
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

    return OBButtonAlert(
      text: isLoggedInUser ? 'You have not shared anything yet.': '$name has not shared anything yet.',
      onPressed: onWantsToRefreshProfile,
      buttonText: 'Refresh',
      buttonIcon: OBIcons.refresh,
      assetImage: 'assets/images/stickers/perplexed-owl.png',
    );
  }
}
