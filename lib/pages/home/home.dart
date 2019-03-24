import 'dart:async';
import 'package:Openbook/models/push_notifications/push_notification.dart';
import 'package:Openbook/pages/home/lib/poppable_page_controller.dart';
import 'package:Openbook/services/intercom.dart';
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
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/badges/badge.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBHomePageState();
  }
}

class OBHomePageState extends State<OBHomePage> with WidgetsBindingObserver {
  static const String oneSignalAppId = '66074bf4-9943-4504-a011-531c2635698b';
  UserService _userService;
  ToastService _toastService;
  PushNotificationsService _pushNotificationsService;
  IntercomService _intercomService;

  int _currentIndex;
  int _lastIndex;
  bool _needsBootstrap;

  StreamSubscription _loggedInUserChangeSubscription;
  StreamSubscription _loggedInUserUpdateSubscription;
  StreamSubscription _pushNotificationOpenedSubscription;
  StreamSubscription _pushNotificationSubscription;

  OBTimelinePageController _timelinePageController;
  OBOwnProfilePageController _ownProfilePageController;
  OBMainSearchPageController _searchPageController;
  OBMainMenuPageController _mainMenuPageController;
  OBCommunitiesPageController _communitiesPageController;
  OBNotificationsPageController _notificationsPageController;

  int _loggedInUserUnreadNotifications;
  String _loggedInUserAvatarUrl;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(_backButtonInterceptor);
    WidgetsBinding.instance.addObserver(this);
    _needsBootstrap = true;
    _loggedInUserUnreadNotifications = 0;
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
    BackButtonInterceptor.remove(_backButtonInterceptor);
    WidgetsBinding.instance.removeObserver(this);
    _loggedInUserChangeSubscription.cancel();
    if (_loggedInUserUpdateSubscription != null)
      _loggedInUserUpdateSubscription.cancel();
    if (_pushNotificationOpenedSubscription != null) {
      _pushNotificationOpenedSubscription.cancel();
    }
    if (_pushNotificationSubscription != null) {
      _pushNotificationSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _pushNotificationsService = openbookProvider.pushNotificationsService;
      _intercomService = openbookProvider.intercomService;
      _toastService = openbookProvider.toastService;
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
      case OBHomePageTabs.timeline:
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

        if (tappedTab == OBHomePageTabs.timeline &&
            currentTab == OBHomePageTabs.timeline) {
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

        if (currentTab == OBHomePageTabs.notifications) {
          // If we're coming from the notifications page, make sure to clear!
          _resetLoggedInUserUnreadNotificationsCount();
        }

        if (tappedTab == OBHomePageTabs.notifications) {
          if (currentTab == OBHomePageTabs.notifications) {
            if (_notificationsPageController.isFirstRoute()) {
              _notificationsPageController.scrollToTop();
            } else {
              _notificationsPageController.popUntilFirstRoute();
            }
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
          icon: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              const OBIcon(OBIcons.notifications),
              _loggedInUserUnreadNotifications > 0
                  ? Positioned(
                      right: -8,
                      child: OBBadge(
                        size: 10,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
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
      await _userService.loginWithStoredUserData();
    } catch (error) {
      if (error is AuthTokenMissingError) {
        _logout();
      } else if (error is HttpieRequestError) {
        HttpieResponse response = error.response;
        if (response.isForbidden() || response.isUnauthorized()) {
          _logout();
        } else {
          _onError(error);
        }
      } else {
        _onError(error);
      }
    }
  }

  Future _logout() async {
    _pushNotificationsService.disablePushNotifications();
    _intercomService.disableIntercom();
    await _userService.logout();
  }

  bool _backButtonInterceptor(bool stopDefaultButtonEvent) {
    OBHomePageTabs currentTab = OBHomePageTabs.values[_lastIndex];
    PoppablePageController currentTabController;

    switch (currentTab) {
      case OBHomePageTabs.notifications:
        currentTabController = _notificationsPageController;
        break;
      case OBHomePageTabs.communities:
        currentTabController = _communitiesPageController;
        break;
      case OBHomePageTabs.timeline:
        currentTabController = _timelinePageController;
        break;
      case OBHomePageTabs.menu:
        currentTabController = _mainMenuPageController;
        break;
      case OBHomePageTabs.search:
        currentTabController = _searchPageController;
        break;
      case OBHomePageTabs.profile:
        currentTabController = _ownProfilePageController;
        break;
      default:
        throw 'No tab controller to pop';
    }

    bool stopDefault = currentTabController.canPop();

    if (stopDefault) {
      currentTabController.pop();
    }

    return stopDefault;
  }

  void _onLoggedInUserChange(User newUser) async {
    if (newUser == null) {
      Navigator.pushReplacementNamed(context, '/auth');
    } else {
      _pushNotificationsService.bootstrap();
      _pushNotificationsService.enablePushNotifications();
      _intercomService.enableIntercom();

      _loggedInUserUpdateSubscription =
          newUser.updateSubject.listen(_onLoggedInUserUpdate);

      _pushNotificationOpenedSubscription = _pushNotificationsService
          .pushNotificationOpened
          .listen(_onPushNotificationOpened);

      _pushNotificationSubscription = _pushNotificationsService.pushNotification
          .listen(_onPushNotification);
    }
  }

  void _onPushNotification(PushNotification pushNotification) {
    OBHomePageTabs currentTab = OBHomePageTabs.values[_lastIndex];

    if (currentTab != OBHomePageTabs.notifications) {
      // When a user taps in notifications, notifications count should be removed
      // Therefore if the user is already there, dont increment.
      User loggedInUser = _userService.getLoggedInUser();
      if (loggedInUser != null) {
        loggedInUser.incrementUnreadNotificationsCount();
      }
    }
  }

  void _onPushNotificationOpened(
      PushNotificationOpenedResult pushNotificationOpenedResult) {
    // int newIndex = OBHomePageTabs.values.indexOf(OBHomePageTabs.notifications);
    // This only works once... bug with flutter.
    // Reported it here https://github.com/flutter/flutter/issues/28992
    //_setCurrentIndex(newIndex);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      bool hasAuthToken = await _userService.hasAuthToken();
      if (hasAuthToken) _userService.refreshUser();
    }
  }

  void _onLoggedInUserUpdate(User user) {
    _setAvatarUrl(user.getProfileAvatar());
    OBHomePageTabs currentTab = _getCurrentTab();
    if (currentTab != OBHomePageTabs.notifications) {
      _setUnreadNotifications(user.unreadNotificationsCount);
    }
  }

  void _setAvatarUrl(String avatarUrl) {
    setState(() {
      _loggedInUserAvatarUrl = avatarUrl;
    });
  }

  void _setUnreadNotifications(int unreadNotifications) {
    setState(() {
      _loggedInUserUnreadNotifications = unreadNotifications;
    });
  }

  OBHomePageTabs _getCurrentTab() {
    return OBHomePageTabs.values[_lastIndex];
  }

  void _resetLoggedInUserUnreadNotificationsCount() {
    User loggedInUser = _userService.getLoggedInUser();
    if (loggedInUser != null) {
      loggedInUser.resetUnreadNotificationsCount();
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }
}

enum OBHomePageTabs {
  timeline,
  search,
  communities,
  notifications,
  profile,
  menu
}
