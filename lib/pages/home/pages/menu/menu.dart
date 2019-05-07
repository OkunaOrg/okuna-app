import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/lib/poppable_page_controller.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainMenuPage extends StatelessWidget {
  final OBMainMenuPageController controller;

  const OBMainMenuPage({this.controller});

  @override
  Widget build(BuildContext context) {
    controller.attach(context: context);
    var openbookProvider = OpenbookProvider.of(context);
    var localizationService = openbookProvider.localizationService;
    var intercomService = openbookProvider.intercomService;
    var userService = openbookProvider.userService;
    var navigationService = openbookProvider.navigationService;

    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Menu',
      ),
      child: OBPrimaryColorContainer(
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
              physics: const ClampingScrollPhysics(),
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 5.0, left: 10),
                  child: const OBText(
                    'My Openbook',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    size: OBTextSize.large,
                  ),
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.circles),
                  title: const OBText('My circles'),
                  onTap: () {
                    navigationService.navigateToConnectionsCircles(
                        context: context);
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.lists),
                  title: const OBText('My lists'),
                  onTap: () {
                    navigationService.navigateToFollowsLists(context: context);
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.followers),
                  title: const OBText('My followers'),
                  onTap: () {
                    navigationService.navigateToFollowersPage(context: context);
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.following),
                  title: const OBText('My following'),
                  onTap: () {
                    navigationService.navigateToFollowingPage(context: context);
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.invite),
                  title: const OBText('My invites'),
                  onTap: () {
                    navigationService.navigateToUserInvites(context: context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 5.0, left: 10),
                  child: const OBText(
                    'Account & App',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    size: OBTextSize.large,
                  ),
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.settings),
                  title: OBText('Settings'),
                  onTap: () {
                    navigationService.navigateToSettingsPage(context: context);
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.themes),
                  title: OBText('Themes'),
                  onTap: () {
                    navigationService.navigateToThemesPage(context: context);
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.logout),
                  title: OBText(localizationService.trans('DRAWER.LOGOUT')),
                  onTap: () {
                    userService.logout();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 5.0, left: 10),
                  child: const OBText(
                    'Resources',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    size: OBTextSize.large,
                  ),
                ),
                StreamBuilder(
                  stream: userService.loggedInUserChange,
                  initialData: userService.getLoggedInUser(),
                  builder:
                      (BuildContext context, AsyncSnapshot<User> snapshot) {
                    User loggedInUser = snapshot.data;

                    if (loggedInUser == null) return const SizedBox();

                    return ListTile(
                      leading: const OBIcon(OBIcons.help),
                      title: OBText(localizationService.trans('DRAWER.HELP')),
                      onTap: () async {
                        intercomService.displayMessenger();
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.link),
                  title: OBText('Useful links'),
                  onTap: () {
                    navigationService.navigateToUsefulLinksPage(
                        context: context);
                  },
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class OBMainMenuPageController extends PoppablePageController {}
