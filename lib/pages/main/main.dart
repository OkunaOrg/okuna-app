import 'dart:async';

import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/main/modals/create_post/create_post.dart';
import 'package:Openbook/pages/main/pages/communities.dart';
import 'package:Openbook/pages/main/pages/home/home.dart';
import 'package:Openbook/pages/main/pages/home/widgets/home-posts.dart';
import 'package:Openbook/pages/main/pages/menu/menu.dart';
import 'package:Openbook/pages/main/pages/notifications.dart';
import 'package:Openbook/pages/main/pages/search.dart';
import 'package:Openbook/pages/main/widgets/bottom-tab-bar.dart';
import 'package:Openbook/pages/main/widgets/tab-scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBMainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBMainPageState();
  }
}

class OBMainPageState extends State<OBMainPage> {
  @override
  UserService _userService;
  int _currentIndex;
  int _lastIndex;
  bool _needsBootstrap;
  StreamSubscription _loggedInUserChangeSubscription;
  OBHomePostsController _homePostsController;
  OBMainPageController _controller;

  List<Widget> _tabPages;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _lastIndex = 0;
    _currentIndex = 0;
    _controller = OBMainPageController();
    _controller.attach(this);
    _homePostsController = OBHomePostsController();
    // Caching to preserve state
    _tabPages = [
      OBMainHomePage(
        mainPageController: _controller,
        homePostsController: _homePostsController,
      ),
      OBMainSearchPage(),
      OBMainNotificationsPage(),
      OBMainCommunitiesPage(),
      OBMainMenuPage()
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

    return Material(
      child: OBCupertinoTabScaffold(
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
      case 5:
        page = _tabPages[4];
        break;
      default:
        throw 'Unhandled index';
    }

    return page;
  }

  Widget _createTabBar() {
    return OBCupertinoTabBar(
      backgroundColor: Colors.white,
      currentIndex: _currentIndex,
      onTap: (int index) {
        if (_lastIndex == 0 && index == 0) {
          _homePostsController.scrollToTop();
        }
        _lastIndex = index;
        return true;
      },
      items: [
        BottomNavigationBarItem(
          title: Container(),
          icon: Icon(Icons.home, size: 25.0),
          activeIcon: Icon(
            Icons.home,
            size: 25.0,
            color: Pigment.fromString('#6bd509'),
          ),
        ),
        BottomNavigationBarItem(
          title: Container(),
          icon: Icon(Icons.search, size: 25.0),
          activeIcon: Icon(Icons.search,
              size: 25.0, color: Pigment.fromString('#379eff')),
        ),
        BottomNavigationBarItem(
          title: Container(),
          icon: Icon(Icons.notifications, size: 23.0),
          activeIcon: Icon(Icons.notifications,
              size: 25.0, color: Pigment.fromString('#f6006f')),
        ),
        BottomNavigationBarItem(
          title: Container(),
          icon: Icon(
            Icons.people,
            size: 25.0,
          ),
          activeIcon: Icon(Icons.people,
              size: 25.0, color: Pigment.fromString('#980df9')),
        ),
        BottomNavigationBarItem(
            title: Container(),
            icon: OBLoggedInUserAvatar(
              size: OBUserAvatarSize.small,
            ),
            activeIcon: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(500), border: Border.all(color: Colors.red)),
              padding: EdgeInsets.all(2.0),
              child: OBLoggedInUserAvatar(
                size: OBUserAvatarSize.small,
              ),
            )),
        BottomNavigationBarItem(
          title: Container(),
          icon: Icon(
            Icons.menu,
            size: 25.0,
          ),
          activeIcon: Icon(Icons.menu,
              size: 25.0, color: Pigment.fromString('#ff9400')),
        ),
      ],
    );
  }

  void openCreatePostModal() {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return CreatePostModal(onPostCreated: () {
            _homePostsController.scrollToTop();
          });
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
      } else{
        rethrow;
      }
    }
  }

  void _onLoggedInUserChange(User newUser) {
    if (newUser == null) {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }
}

class OBMainPageController {
  OBMainPageState _mainPageState;

  void attach(OBMainPageState mainPage) {
    _mainPageState = mainPage;
  }

  openCreatePostModal() {
    _mainPageState.openCreatePostModal();
  }
}
