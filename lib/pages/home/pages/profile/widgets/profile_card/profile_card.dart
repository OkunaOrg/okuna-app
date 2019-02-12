import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/profile_actions.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_bio.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_connected_in.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_connection_request.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_counts/profile_counts.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_details/profile_details.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_in_lists.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_name.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_username.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';

class OBProfileCard extends StatelessWidget {
  final User user;
  OverlayEntry _overlayEntry;

  OBProfileCard(this.user);

  OverlayEntry _createOverlayEntry(BuildContext context) {

    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
          left: offset.dx,
          top: offset.dy + size.height + 5.0,
          width: size.width,
          child: Material(
            elevation: 4.0,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: Text('Apples'),
                ),
                ListTile(
                  title: Text('Oranges'),
                )
              ],
            ),
          ),
        )
    );
  }

  void showToast(BuildContext context) {
    this._overlayEntry = this._createOverlayEntry(context);
    Overlay.of(context).insert(this._overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;
    var toastService = openbookProvider.toastService;

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 30.0, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(
                    height: (OBUserAvatar.AVATAR_SIZE_LARGE * 0.4),
                    width: OBUserAvatar.AVATAR_SIZE_LARGE,
                  ),
                  Expanded(child: OBProfileActions(user)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  OBProfileName(user),
                  GestureDetector(
                    onTap: () {
                      toastService.info(message: 'showing toast', context:context);
                    },
                    child: OBProfileUsername(user),
                  ),
                  OBProfileBio(user),
                  OBProfileDetails(user),
                  OBProfileCounts(user),
                  OBProfileConnectedIn(user),
                  OBProfileConnectionRequest(user),
                  OBProfileInLists(user)
                ],
              ),
            ],
          ),
        ),
        Positioned(
          child: StreamBuilder(
              stream: themeService.themeChange,
              initialData: themeService.getActiveTheme(),
              builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
                var theme = snapshot.data;

                return Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: themeValueParserService
                          .parseColor(theme.primaryColor),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                );
              }),
          top: -19,
        ),
        Positioned(
          top: -((OBUserAvatar.AVATAR_SIZE_LARGE / 2) * 0.7) - 10,
          left: 30,
          child: StreamBuilder(
              stream: user.updateSubject,
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                var user = snapshot.data;

                return OBUserAvatar(
                  borderWidth: 3,
                  avatarUrl: user?.getProfileAvatar(),
                  size: OBUserAvatarSize.large,
                );
              }),
        ),
      ],
    );
  }
}
