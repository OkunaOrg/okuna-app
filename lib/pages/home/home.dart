import 'dart:async';
import 'package:Openbook/services/push_notifications/push_notifications.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/communities/communities.dart';
import 'package:Openbook/pages/home/pages/notifications/notifications.dart';
import 'package:Openbook/pages/home/pages/own_profile.dart';
import 'package:Openbook/pages/home/pages/timeline/timeline.dart';
import 'package:Openbook/pages/home/pages/menu/menu.dart';
import 'package:Openbook/pages/home/pages/search/search.dart';
import 'package:Openbook/pages/home/widgets/bottom-tab-bar.dart';
import 'package:Openbook/pages/home/widgets/own_profile_active_icon.dart';
import 'package:Openbook/pages/home/widgets/tab-scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
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
  static const String oneSignalAppId = '66074bf4-9943-4504-a011-531c2635698b';
  UserService _userService;
  PushNotificationsService _pushNotificationsService;

  int _currentIndex;
  int _lastIndex;
  bool _needsBootstrap;
  String _loggedInUserAvatarUrl;

  StreamSubscription _loggedInUserChangeSubscription;
  StreamSubscription _loggedInUserUpdateSubscription;
  StreamSubscription _pushNotificationOpenedSubscription;

  OBTimelinePageController _timelinePageController;
  OBOwnProfilePageController _ownProfilePageController;
  OBMainSearchPageController _searchPageController;
  OBMainMenuPageController _mainMenuPageController;
  OBCommunitiesPageController _communitiesPageController;
  OBNotificationsPageController _notificationsPageController;

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
    _communitiesPageController = OBCommunitiesPageController();
    _notificationsPageController = OBNotificationsPageController();
  }

  @override
  void dispose() {
    super.dispose();
    _loggedInUserChangeSubscription.cancel();
    if (_loggedInUserUpdateSubscription != null)
      _loggedInUserUpdateSubscription.cancel();
    if (_pushNotificationOpenedSubscription != null) {
      _pushNotificationOpenedSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _pushNotificationsService = openbookProvider.pushNotificationsService;
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
        page = OBNotificationsPage(
          controller: _notificationsPageController,
        );
        break;
      case OBHomePageTabs.communities:
        page = OBMainCommunitiesPage(
          controller: _communitiesPageController,
        );
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

        if (tappedTab == OBHomePageTabs.communities &&
            currentTab == OBHomePageTabs.communities) {
          if (_communitiesPageController.isFirstRoute()) {
            _communitiesPageController.scrollToTop();
          } else {
            _communitiesPageController.popUntilFirstRoute();
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

        if (tappedTab == OBHomePageTabs.notifications &&
            currentTab == OBHomePageTabs.notifications) {
          if (_notificationsPageController.isFirstRoute()) {
            _notificationsPageController.scrollToTop();
          } else {
            _notificationsPageController.popUntilFirstRoute();
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
          title: const SizedBox(),
          icon: const OBIcon(OBIcons.home),
          activeIcon: const OBIcon(
            OBIcons.home,
            themeColor: OBIconThemeColor.primaryAccent,
          ),
        ),
        BottomNavigationBarItem(
          title: const SizedBox(),
          icon: const OBIcon(OBIcons.search),
          activeIcon: const OBIcon(
            OBIcons.search,
            themeColor: OBIconThemeColor.primaryAccent,
          ),
        ),
        BottomNavigationBarItem(
          title: const SizedBox(),
          icon: const OBIcon(OBIcons.communities),
          activeIcon: const OBIcon(
            OBIcons.communities,
            themeColor: OBIconThemeColor.primaryAccent,
          ),
        ),
        BottomNavigationBarItem(
          title: const SizedBox(),
          icon: const OBIcon(OBIcons.notifications),
          activeIcon: const OBIcon(
            OBIcons.notifications,
            themeColor: OBIconThemeColor.primaryAccent,
          ),
        ),
        BottomNavigationBarItem(
            title: const SizedBox(),
            icon: OBAvatar(
              avatarUrl: _loggedInUserAvatarUrl,
              size: OBAvatarSize.extraSmall,
            ),
            activeIcon: OBOwnProfileActiveIcon(
              avatarUrl: _loggedInUserAvatarUrl,
              size: OBAvatarSize.extraSmall,
            )),
        BottomNavigationBarItem(
          title: const SizedBox(),
          icon: const OBIcon(OBIcons.menu),
          activeIcon: const OBIcon(
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
        await _pushNotificationsService.disablePushNotifications();
        await _userService.logout();
      }
      rethrow;
    }
  }

  void _onLoggedInUserChange(User newUser) async {
    if (newUser == null) {
      Navigator.pushReplacementNamed(context, '/auth');
    } else {
      _pushNotificationsService.enablePushNotifications();
      _loggedInUserUpdateSubscription =
          newUser.updateSubject.listen(_onLoggedInUserUpdate);

      _pushNotificationOpenedSubscription = _pushNotificationsService
          .pushNotificationOpened
          .listen(_onPushNotificationOpened);
    }
  }

  void _onPushNotificationOpened(
      PushNotificationOpenedResult pushNotificationOpenedResult) {
    int newIndex = OBHomePageTabs.values.indexOf(OBHomePageTabs.notifications);
    // This only works once... bug with flutter.
    // Reported it here https://github.com/flutter/flutter/issues/28992
    _setCurrentIndex(newIndex);
  }

  void _onLoggedInUserUpdate(User user) {
    _setAvatarUrl(user.getProfileAvatar());
  }

  void _setAvatarUrl(String avatarUrl) {
    setState(() {
      _loggedInUserAvatarUrl = avatarUrl;
    });
  }

  void _setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

enum OBHomePageTabs { home, search, communities, notifications, profile, menu }
