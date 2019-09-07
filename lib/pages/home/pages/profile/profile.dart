import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/user.dart';
import 'package:Okuna/pages/home/pages/profile/widgets/profile_card/profile_card.dart';
import 'package:Okuna/pages/home/pages/profile/widgets/profile_cover.dart';
import 'package:Okuna/pages/home/pages/profile/widgets/profile_nav_bar.dart';
import 'package:Okuna/pages/home/pages/profile/widgets/profile_no_posts.dart';
import 'package:Okuna/widgets/loadmore/loadmore_delegate.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/post/post.dart';
import 'package:Okuna/widgets/posts_stream/posts_stream.dart';
import 'package:Okuna/widgets/progress_indicator.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Okuna/widgets/load_more.dart';

class OBProfilePage extends StatefulWidget {
  final OBProfilePageController controller;
  final User user;

  OBProfilePage(
    this.user, {
    this.controller,
  });

  @override
  OBProfilePageState createState() {
    return OBProfilePageState();
  }
}

class OBProfilePageState extends State<OBProfilePage> {
  User _user;
  bool _needsBootstrap;
  UserService _userService;
  OBPostsStreamController _obPostsStreamController;
  bool _profileCommunityPostsVisible;

  @override
  void initState() {
    super.initState();
    _obPostsStreamController = OBPostsStreamController();
    _needsBootstrap = true;
    _user = widget.user;
    if (widget.controller != null) widget.controller.attach(this);
    _profileCommunityPostsVisible =
        widget.user.getProfileCommunityPostsVisible();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBProfileNavBar(_user),
        child: OBPrimaryColorContainer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: OBPostsStream(
                    streamIdentifier: 'profile_${widget.user.username}',
                    prependedItems: <Widget>[
                      OBProfileCover(_user),
                      OBProfileCard(
                        _user,
                        onUserProfileUpdated: _onUserProfileUpdated,
                      ),
                    ],
                    controller: _obPostsStreamController,
                    secondaryRefresher: _refreshUser,
                    refresher: _refreshPosts,
                    onScrollLoader: _loadMorePosts,
                    statusTileEmptyBuilder: _postsStreamStatusTileEmptyBuilder),
              )
            ],
          ),
        ));
  }

  Widget _postsStreamStatusTileEmptyBuilder(BuildContext context) {
    return OBProfileNoPosts(
      widget.user,
      onWantsToRefreshProfile: _obPostsStreamController.refreshPosts,
    );
  }

  void _onUserProfileUpdated() {
    if (_profileCommunityPostsVisible !=
        _user.getProfileCommunityPostsVisible()) {
      _refreshPosts();
    }
  }

  void scrollToTop() {
    _obPostsStreamController.scrollToTop();
  }

  Future<void> _refreshUser() async {
    var user = await _userService.getUserWithUsername(_user.username);
    _setUser(user);
  }

  Future<List<Post>> _refreshPosts() async {
    return (await _userService.getTimelinePosts(username: _user.username))
        .posts;
  }

  Future<List<Post>> _loadMorePosts(List<Post> posts) async {
    Post lastPost = posts.last;

    return (await _userService.getTimelinePosts(
            maxId: lastPost.id, username: _user.username))
        .posts;
  }

  void _setUser(User user) {
    setState(() {
      _user = user;
    });
  }
}

class OBProfilePageController {
  OBProfilePageState _timelinePageState;

  void attach(OBProfilePageState profilePageState) {
    assert(profilePageState != null, 'Cannot attach to empty state');
    _timelinePageState = profilePageState;
  }

  void scrollToTop() {
    if (_timelinePageState != null) _timelinePageState.scrollToTop();
  }
}

typedef void OnWantsToEditUserProfile(User user);
