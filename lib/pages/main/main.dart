import 'package:Openbook/pages/main/pages/home.dart';
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
  LocalizationService _localizationService;
  UserService _userService;
  int _currentIndex = 0;

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
            switch (index) {
              case 0:
                return MainHomePage();
                break;
              case 1:
                return MainSearchPage();
                break;
              default:
                throw 'Unhandled index';
            }
          },
        );
      },
      tabBar: CupertinoTabBar(items: [
        BottomNavigationBarItem(title: Text('Home'), icon: Icon(Icons.home)),
        BottomNavigationBarItem(
            title: Text('Search'), icon: Icon(Icons.search)),
        BottomNavigationBarItem(title: Text('Post'), icon: Icon(Icons.add)),
        BottomNavigationBarItem(
            title: Text('Notifications'), icon: Icon(Icons.notifications)),
        BottomNavigationBarItem(
            title: Text('Communities'), icon: Icon(Icons.people)),
      ]),
    );
  }
}
