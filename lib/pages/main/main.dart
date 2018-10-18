import 'package:Openbook/pages/main/pages/communities.dart';
import 'package:Openbook/pages/main/pages/home.dart';
import 'package:Openbook/pages/main/pages/notifications.dart';
import 'package:Openbook/pages/main/pages/search.dart';
import 'package:Openbook/pages/main/widgets/drawer/drawer.dart';
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
  Widget _activePage;
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
    return CupertinoTabScaffold(
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return _getPageForTabIndex(index);
          },
        );
      },
      tabBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(title: Text('Home'), icon: Icon(Icons.home)),
          BottomNavigationBarItem(
              title: Text('Search'), icon: Icon(Icons.search)),
          BottomNavigationBarItem(
              title: IgnorePointer(
                child: Text('Post'),
              ),
              icon: IgnorePointer(
                child: Icon(Icons.add),
              )),
          BottomNavigationBarItem(
              title: Text('Notifications'), icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(
              title: Text('Chat'), icon: Icon(Icons.message)),
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
