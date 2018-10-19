import 'dart:async';

import 'package:Openbook/models/user.dart';
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
  bool _needsBootstrap;
  StreamSubscription _loggedInUserChangeSubscription;

  List<Widget> _tabPages;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _currentIndex = 0;
    // Caching to preserve state
    _tabPages = [
      MainHomePage(),
      MainSearchPage(),
      MainNotificationsPage(),
      MainCommunitiesPage()
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _loggedInUserChangeSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _localizationService = openbookProvider.localizationService;
    _userService = openbookProvider.userService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return Scaffold(
      drawer: MainDrawer(),
      body: OBCupertinoTabScaffold(
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              return _getPageForTabIndex(index);
            },
          );
        },
        tabBar: _createTabBar(),
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

  Widget _createTabBar() {
    return OBCupertinoTabBar(
      currentIndex: _currentIndex,
      onTap: (int index) {
        // When index == 2 dont allow index change
        if (index == 2) {
          // Open post modal
          _openCreatePostModal();
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
    );
  }

  void _openCreatePostModal() {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return CreatePostModal();
        }));
  }

  void _bootstrap() async {
    _loggedInUserChangeSubscription =
        _userService.loggedInUserChange.listen(_onLoggedInUserChange);

    try {
      await _userService.loginWithStoredAuthToken();
    } catch (error) {
      if (error is AuthTokenMissingError || error is AuthTokenInvalidError) {
        await _userService.logout();
      }
    }
  }

  void _onLoggedInUserChange(User newUser) {
    if (newUser == null) {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }
}
