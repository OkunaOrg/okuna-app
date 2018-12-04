import 'package:Openbook/pages/home/pages/follows_lists/follows_lists.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/routes/slide_right_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainMenuPage extends StatelessWidget {
  OBMainMenuPage();

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var localizationService = openbookProvider.localizationService;
    var userService = openbookProvider.userService;

    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text(localizationService.trans('DRAWER.CONNECTIONS')),
                  onTap: () {
                    // Update the state of the app
                    // ...
                  },
                ),
                ListTile(
                  leading: Icon(Icons.list),
                  title: Text(localizationService.trans('DRAWER.LISTS')),
                  onTap: () async {
                    await Navigator.push(
                        context,
                        OBSlideRightRoute(
                            key: Key('obSlideViewComments'),
                            widget: OBFollowsListsPage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(localizationService.trans('DRAWER.SETTINGS')),
                  onTap: () {
                    // Update the state of the app
                    // ...
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text(localizationService.trans('DRAWER.HELP')),
                  onTap: () {
                    // Update the state of the app
                    // ...
                  },
                ),
                ListTile(
                  leading: Icon(Icons.format_paint),
                  title: Text(localizationService.trans('DRAWER.CUSTOMIZE')),
                  onTap: () {
                    // Update the state of the app
                    // ...
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text(localizationService.trans('DRAWER.LOGOUT')),
                  onTap: () {
                    userService.logout();
                  },
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: Colors.white,
      middle: Text('Menu'),
    );
  }
}
