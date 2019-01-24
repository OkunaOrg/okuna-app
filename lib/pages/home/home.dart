import 'dart:async';

import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/own_profile.dart';
import 'package:Openbook/pages/home/pages/timeline/timeline.dart';
import 'package:Openbook/pages/home/pages/menu/menu.dart';
import 'package:Openbook/pages/home/pages/notifications.dart';
import 'package:Openbook/pages/home/pages/search/search.dart';
import 'package:Openbook/pages/home/widgets/bottom-tab-bar.dart';
import 'package:Openbook/pages/home/widgets/own_profile_active_icon.dart';
import 'package:Openbook/pages/home/widgets/tab-scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBHomePageState();
  }
}

class OBHomePageState extends State<OBHomePage> {
  @override
  UserService _userService;
  int _currentIndex;
  int _lastIndex;
  bool _needsBootstrap;
  String _avatarUrl;
  StreamSubscription _loggedInUserChangeSubscription;
  StreamSubscription _loggedInUserUpdateSubscription;
  OBTimelinePageController _timelinePageController;
  OBOwnProfilePageController _ownProfilePageController;
  OBMainSearchPageController _searchPageController;
  OBMainMenuPageController _mainMenuPageController;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _lastIndex = 0;
    _currentIndex = 0;
    _timelinePageController = OBTimelinePageController();
    _ownProfilePageController = OBOwnProfilePageController();
    _searchPageController = OBMainSearchPageController();
    _mainMenuPageController = OBMainMenuPageController();
  }

  @override
  void dispose() {
    super.dispose();
    _loggedInUserChangeSubscription.cancel();
    if (_loggedInUserUpdateSubscription != null)
      _loggedInUserUpdateSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
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
    switch (OBHomePageTabs.values[index]) {
      case OBHomePageTabs.home:
        page = OBTimelinePage(
          controller: _timelinePageController,
        );
        break;
      case OBHomePageTabs.search:
        page = OBMainSearchPage(
          controller: _searchPageController,
        );
        break;
      case OBHomePageTabs.notifications:
        break;
      case OBHomePageTabs.communities:
        page = OBMainNotificationsPage();
        break;
      case OBHomePageTabs.profile:
        page = OBOwnProfilePage(controller: _ownProfilePageController);
        break;
      case OBHomePageTabs.menu:
        page = OBMainMenuPage(
          controller: _mainMenuPageController,
        );
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
        var tappedTab = OBHomePageTabs.values[index];
        var currentTab = OBHomePageTabs.values[_lastIndex];

        if (tappedTab == OBHomePageTabs.home &&
            currentTab == OBHomePageTabs.home) {
          if (_timelinePageController.isFirstRoute()) {
            _timelinePageController.scrollToTop();
          } else {
            _timelinePageController.popUntilFirstRoute();
          }
        }

        if (tappedTab == OBHomePageTabs.profile &&
            currentTab == OBHomePageTabs.profile) {
          if (_ownProfilePageController.isFirstRoute()) {
            _ownProfilePageController.scrollToTop();
          } else {
            _ownProfilePageController.popUntilFirstRoute();
          }
        }

        if (tappedTab == OBHomePageTabs.search &&
            currentTab == OBHomePageTabs.search) {
          if (_searchPageController.isFirstRoute()) {
            _searchPageController.scrollToTop();
          } else {
            _searchPageController.popUntilFirstRoute();
          }
        }

        if (tappedTab == OBHomePageTabs.menu &&
            currentTab == OBHomePageTabs.menu) {
          _mainMenuPageController.popUntilFirstRoute();
        }

        _lastIndex = index;
        return true;
      },
      items: [
        BottomNavigationBarItem(
          title: SizedBox(),
          icon: OBIcon(OBIcons.home),
          activeIcon: OBIcon(
            OBIcons.home,
            themeColor: OBIconThemeColor.primaryAccent,
          ),
        ),
        BottomNavigationBarItem(
          title: SizedBox(),
          icon: OBIcon(OBIcons.search),
          activeIcon: OBIcon(
            OBIcons.search,
            themeColor: OBIconThemeColor.primaryAccent,
          ),
        ),
        BottomNavigationBarItem(
          title: SizedBox(),
          icon: OBIcon(OBIcons.notifications),
          activeIcon: OBIcon(
            OBIcons.notifications,
            themeColor: OBIconThemeColor.primaryAccent,
          ),
        ),
        BottomNavigationBarItem(
          title: SizedBox(),
          icon: OBIcon(OBIcons.communities),
          activeIcon: OBIcon(
            OBIcons.communities,
            themeColor: OBIconThemeColor.primaryAccent,
          ),
        ),
        BottomNavigationBarItem(
            title: SizedBox(),
            icon: OBUserAvatar(
              avatarUrl: _avatarUrl,
              size: OBUserAvatarSize.small,
            ),
            activeIcon: OBOwnProfileActiveIcon(
              avatarUrl: _avatarUrl,
            )),
        BottomNavigationBarItem(
          title: SizedBox(),
          icon: OBIcon(OBIcons.menu),
          activeIcon: OBIcon(
            OBIcons.menu,
            themeColor: OBIconThemeColor.primaryAccent,
          ),
        ),
      ],
    );
  }

  void _bootstrap() async {
    _loggedInUserChangeSubscription =
        _userService.loggedInUserChange.listen(_onLoggedInUserChange);

    if (_userService.isLoggedIn()) return;

    try {
      await _userService.loginWithStoredAuthToken();
    } catch (error) {
      if (error is AuthTokenMissingError || error is HttpieRequestError) {
        await _userService.logout();
      }
      rethrow;
    }
  }

  void _onLoggedInUserChange(User newUser) async {
    if (newUser == null) {
      Navigator.pushReplacementNamed(context, '/auth');
    } else {
      _loggedInUserUpdateSubscription =
          newUser.updateSubject.listen(_onLoggedInUserUpdate);
    }
  }

  void _onLoggedInUserUpdate(User user) {
    _setAvatarUrl(user.getProfileAvatar());
  }

  void _setAvatarUrl(String avatarUrl) {
    setState(() {
      _avatarUrl = avatarUrl;
    });
  }
}

enum OBHomePageTabs { home, search, notifications, communities, profile, menu }

typedef Future<List<Circle>> OnWantsToPickCircles();
