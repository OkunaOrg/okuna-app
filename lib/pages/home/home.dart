import 'dart:async';

import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/modals/create_post/create_post.dart';
import 'package:Openbook/pages/home/modals/edit_user_profile/edit_user_profile.dart';
import 'package:Openbook/pages/home/modals/react_to_post/react_to_post.dart';
import 'package:Openbook/pages/home/pages/own_profile.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/pages/home/pages/timeline/timeline.dart';
import 'package:Openbook/pages/home/pages/menu/menu.dart';
import 'package:Openbook/pages/home/pages/notifications.dart';
import 'package:Openbook/pages/home/pages/search.dart';
import 'package:Openbook/pages/home/widgets/bottom-tab-bar.dart';
import 'package:Openbook/pages/home/widgets/tab-scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

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
  StreamSubscription _loggedInUserChangeSubscription;
  OBTimelinePageController _timelinePageController;
  OBOwnProfilePageController _ownProfilePageController;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _lastIndex = 0;
    _currentIndex = 0;
    _timelinePageController = OBTimelinePageController();
    _ownProfilePageController = OBOwnProfilePageController();
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
    switch (OBHomePageTabs.values[index]) {
      case OBHomePageTabs.home:
        page = OBTimelinePage(
          controller: _timelinePageController,
          onWantsToReactToPost: _onWantsToReactToPost,
          onWantsToCreatePost: _onWantsToCreatePost,
          onWantsToEditUserProfile: _onWantsToEditUserProfile,
        );
        break;
      case OBHomePageTabs.search:
        page = OBMainSearchPage();
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
            controller: _ownProfilePageController);
        break;
      case OBHomePageTabs.menu:
        page = OBMainMenuPage();
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
            _timelinePageController.popUntilTimeline();
          } else {
            _timelinePageController.scrollToTop();
          }
        }

        if (tappedTab == OBHomePageTabs.profile &&
            currentTab == OBHomePageTabs.profile) {
          if (_ownProfilePageController.hasPushedRoutes()) {
            _ownProfilePageController.popUntilProfile();
          } else {
            _ownProfilePageController.scrollToTop();
          }
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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500),
                  border: Border.all(color: Colors.red)),
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

  Future<void> _onWantsToEditUserProfile(User user) async {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute<PostReaction>(
            fullscreenDialog: true,
            builder: (BuildContext context) => Material(
                  child: OBEditUserProfileModal(user),
                )));
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
    }
  }
}

enum OBHomePageTabs { home, search, notifications, communities, profile, menu }
