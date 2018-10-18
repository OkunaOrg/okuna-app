import 'package:Openbook/pages/main/modals/create-post.dart';
import 'package:Openbook/pages/main/pages/communities.dart';
import 'package:Openbook/pages/main/pages/home.dart';
import 'package:Openbook/pages/main/pages/notifications.dart';
import 'package:Openbook/pages/main/pages/search.dart';
import 'package:Openbook/pages/main/widgets/drawer/bottom-tab-bar.dart';
import 'package:Openbook/pages/main/widgets/drawer/drawer.dart';
import 'package:Openbook/pages/main/widgets/drawer/tab-scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  @override
  LocalizationService _localizationService;
  UserService _userService;
  int _currentIndex;

  List<Widget> _tabPages;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _tabPages = [
      MainHomePage(),
      MainSearchPage(),
      MainNotificationsPage(),
      MainCommunitiesPage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _localizationService = openbookProvider.localizationService;
    _userService = openbookProvider.userService;

    return Scaffold(
      drawer: MainDrawer(),
      body: _buildCupertinoScaffold(),
    );
  }

  Widget _buildCupertinoScaffold() {
    return OBCupertinoTabScaffold(
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return _getPageForTabIndex(index);
          },
        );
      },
      tabBar: OBCupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          // When index == 2 dont allow index change
          if (index == 2) {
            // Open post modal
            Navigator.of(context).push(CreatePostModal());

            return false;
          }

          return true;
        },
        items: [
          BottomNavigationBarItem(
              title: Container(),
              icon: Icon(
                Icons.home,
                size: 25.0,
              )),
          BottomNavigationBarItem(
              title: Container(),
              icon: Icon(
                Icons.search,
                size: 25.0,
              )),
          BottomNavigationBarItem(
              title: Container(),
              icon: Icon(
                Icons.add,
                size: 25.0,
              )),
          BottomNavigationBarItem(
              title: Container(),
              icon: Icon(
                Icons.notifications,
                size: 20.0,
              )),
          BottomNavigationBarItem(
              title: Container(),
              icon: Icon(
                Icons.people,
                size: 20.0,
              )),
        ],
      ),
    );
  }

  Widget _getPageForTabIndex(int index) {
    Widget page;
    switch (index) {
      case 0:
        page = _tabPages[0];
        break;
      case 1:
        page = _tabPages[1];
        break;
      case 2:
        break;
      case 3:
        page = _tabPages[2];
        break;
      case 4:
        page = _tabPages[3];
        break;
      default:
        throw 'Unhandled index';
    }

    return page;
  }
}
