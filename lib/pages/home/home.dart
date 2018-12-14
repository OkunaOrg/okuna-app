import 'dart:async';

import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/modals/create_post/create_post.dart';
import 'package:Openbook/pages/home/modals/edit_user_profile/edit_user_profile.dart';
import 'package:Openbook/pages/home/modals/pick_circles/pick_circles.dart';
import 'package:Openbook/pages/home/modals/react_to_post/react_to_post.dart';
import 'package:Openbook/pages/home/modals/save_connections_circle.dart';
import 'package:Openbook/pages/home/modals/save_follows_list/save_follows_list.dart';
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
  OBMainMenuPageController _menuPageController;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _lastIndex = 0;
    _currentIndex = 0;
    _timelinePageController = OBTimelinePageController();
    _ownProfilePageController = OBOwnProfilePageController();
    _searchPageController = OBMainSearchPageController();
    _menuPageController = OBMainMenuPageController();
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
    switch (OBHomePageTabs.values[index]) {
      case OBHomePageTabs.home:
        page = OBTimelinePage(
            controller: _timelinePageController,
            onWantsToReactToPost: _onWantsToReactToPost,
            onWantsToCreatePost: _onWantsToCreatePost,
            onWantsToEditUserProfile: _onWantsToEditUserProfile,
            onWantsToPickCircles: _onWantsToPickCircles);
        break;
      case OBHomePageTabs.search:
        page = OBMainSearchPage(
            controller: _searchPageController,
            onWantsToReactToPost: _onWantsToReactToPost,
            onWantsToEditUserProfile: _onWantsToEditUserProfile,
            onWantsToPickCircles: _onWantsToPickCircles);
        break;
      case OBHomePageTabs.notifications:
        break;
      case OBHomePageTabs.communities:
        page = OBMainNotificationsPage();
        break;
      case OBHomePageTabs.profile:
        page = OBOwnProfilePage(
            onWantsToEditUserProfile: _onWantsToEditUserProfile,
            onWantsToReactToPost: _onWantsToReactToPost,
            onWantsToPickCircles: _onWantsToPickCircles,
            controller: _ownProfilePageController);
        break;
      case OBHomePageTabs.menu:
        page = OBMainMenuPage(
          controller: _menuPageController,
          onWantsToCreateFollowsList: _onWantsToCreateFollowsList,
          onWantsToEditFollowsList: _onWantsToEditFollowsList,
          onWantsToReactToPost: _onWantsToReactToPost,
          onWantsToEditUserProfile: _onWantsToEditUserProfile,
          onWantsToPickCircles: _onWantsToPickCircles,
          onWantsToCreateConnectionsCircle: _onWantsToCreateConnectionsCircle,
          onWantsToEditConnectionsCircle: _onWantsToEditConnectionsCircle,
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
          if (_timelinePageController.hasPushedRoutes()) {
            _timelinePageController.popUntilFirst();
          } else {
            _timelinePageController.scrollToTop();
          }
        }

        if (tappedTab == OBHomePageTabs.profile &&
            currentTab == OBHomePageTabs.profile) {
          if (_ownProfilePageController.hasPushedRoutes()) {
            _ownProfilePageController.popUntilFirst();
          } else {
            _ownProfilePageController.scrollToTop();
          }
        }

        if (tappedTab == OBHomePageTabs.search &&
            currentTab == OBHomePageTabs.search) {
          if (_searchPageController.hasPushedRoutes()) {
            _searchPageController.popUntilFirst();
          } else {
            _searchPageController.scrollToTop();
          }
        }

        if (tappedTab == OBHomePageTabs.menu &&
            currentTab == OBHomePageTabs.menu) {
          if (_menuPageController.isAttached() &&
              _menuPageController.hasPushedRoutes()) {
            _menuPageController.popUntilFirst();
          } else {
            _menuPageController.scrollToTop();
          }
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

  Future<Post> _onWantsToCreatePost() async {
    Post createdPost = await Navigator.of(context).push(MaterialPageRoute<Post>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return CreatePostModal();
        }));

    return createdPost;
  }

  Future<PostReaction> _onWantsToReactToPost(Post post) async {
    PostReaction postReaction = await Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute<PostReaction>(
            fullscreenDialog: true,
            builder: (BuildContext context) => Material(
                  child: OBReactToPostModal(post),
                )));

    return postReaction;
  }

  Future<List<Circle>> _onWantsToPickCircles() async {
    List<Circle> circles = await Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute<List<Circle>>(
            fullscreenDialog: true,
            builder: (BuildContext context) => Material(
                  child: OBPickCirclesModal(),
                )));

    return circles;
  }

  Future<void> _onWantsToEditUserProfile(User user) async {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute<PostReaction>(
            fullscreenDialog: true,
            builder: (BuildContext context) => Material(
                  child: OBEditUserProfileModal(user),
                )));
  }

  Future<FollowsList> _onWantsToCreateFollowsList() async {
    FollowsList createdFollowsList =
        await Navigator.of(context).push(MaterialPageRoute<FollowsList>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return OBSaveFollowsListModal(
                autofocusNameTextField: true,
              );
            }));

    return createdFollowsList;
  }

  Future<FollowsList> _onWantsToEditFollowsList(FollowsList followsList) async {
    FollowsList editedFollowsList =
        await Navigator.of(context).push(MaterialPageRoute<FollowsList>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return OBSaveFollowsListModal(
                followsList: followsList,
              );
            }));

    return editedFollowsList;
  }

  Future<Circle> _onWantsToCreateConnectionsCircle() async {
    Circle createdConnectionsCircle =
        await Navigator.of(context).push(MaterialPageRoute<Circle>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return OBSaveConnectionsCircleModal(
                autofocusNameTextField: true,
              );
            }));

    return createdConnectionsCircle;
  }

  Future<Circle> _onWantsToEditConnectionsCircle(
      Circle connectionsCircle) async {
    Circle editedConnectionsCircle =
        await Navigator.of(context).push(MaterialPageRoute<Circle>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return OBSaveConnectionsCircleModal(
                connectionsCircle: connectionsCircle,
              );
            }));

    return editedConnectionsCircle;
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

  void _onLoggedInUserChange(User newUser) {
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
