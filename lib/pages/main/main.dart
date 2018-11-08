import 'dart:async';

import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/main/modals/create-post/create-post.dart';
import 'package:Openbook/pages/main/pages/communities.dart';
import 'package:Openbook/pages/main/pages/home.dart';
import 'package:Openbook/pages/main/pages/notifications.dart';
import 'package:Openbook/pages/main/pages/search.dart';
import 'package:Openbook/pages/main/widgets/bottom-tab-bar.dart';
import 'package:Openbook/pages/main/widgets/drawer/drawer.dart';
import 'package:Openbook/pages/main/widgets/tab-scaffold.dart';
import 'package:Openbook/provider.dart';
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
    double tabBarIconsSize = 20.0;

    return OBCupertinoTabBar(
      backgroundColor: Colors.white,
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
          icon: _buildBottomNavigationBarItemIcon('home'),
          activeIcon: _buildBottomNavigationBarActiveItemIcon('home'),
        ),
        BottomNavigationBarItem(
          title: Container(),
          icon: _buildBottomNavigationBarItemIcon('search'),
          activeIcon: _buildBottomNavigationBarActiveItemIcon('search'),
        ),
        BottomNavigationBarItem(
          title: Container(),
          icon: _buildBottomNavigationBarItemIcon('create-post'),
          activeIcon: _buildBottomNavigationBarActiveItemIcon('create-post'),
        ),
        BottomNavigationBarItem(
          title: Container(),
          icon: _buildBottomNavigationBarItemIcon('notifications'),
          activeIcon: _buildBottomNavigationBarActiveItemIcon('notifications'),
        ),
        BottomNavigationBarItem(
          title: Container(),
          icon: _buildBottomNavigationBarItemIcon('communities'),
          activeIcon: _buildBottomNavigationBarActiveItemIcon('communities'),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBarActiveItemIcon(String iconName) {
    return Image.asset(
      'assets/images/icons/$iconName-icon.png',
      height: 20.0,
    );
  }

  Widget _buildBottomNavigationBarItemIcon(String iconName) {
    return Opacity(
      opacity: 0.5,
      child: Image.asset(
        'assets/images/icons/$iconName-icon.png',
        height: 18.0,
      ),
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

    if (_userService.isLoggedIn()) return;

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
