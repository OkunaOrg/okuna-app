import 'dart:async';
import 'dart:convert';
import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/top_post.dart';
import 'package:Okuna/models/top_posts_list.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/icon_button.dart';
import 'package:Okuna/widgets/post/post.dart';
import 'package:Okuna/widgets/posts_stream/posts_stream.dart';
import 'package:Okuna/widgets/theming/primary_accent_text.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

class OBTopPosts extends StatefulWidget {
  final OBTopPostsController controller;

  OBTopPosts({
    this.controller,
  });

  @override
  State<StatefulWidget> createState() {
    return OBTopPostsState();
  }
}

class OBTopPostsState extends State<OBTopPosts> with AutomaticKeepAliveClientMixin {
  UserService _userService;
  LocalizationService _localizationService;
  NavigationService _navigationService;
  CancelableOperation _getTrendingPostsOperation;
  OBPostsStreamController _obPostsStreamController;

  bool _needsBootstrap;
  List<TopPost> _currentTopPosts = [];
  List<Post> _currentPosts = [];
  List<int> _excludedCommunities = [];
  List<Post> _topPostsCacheData = [];
  double _topPostScrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _obPostsStreamController = OBPostsStreamController();
    if (widget.controller != null) widget.controller.attach(this);
  }

  @override
  void dispose() async {
    super.dispose();
    await _userService.setStoredTopPosts(_currentTopPosts);
    if (_getTrendingPostsOperation != null) _getTrendingPostsOperation.cancel();
  }

  Future refresh() {
    return _obPostsStreamController.refreshPosts();
  }

  void scrollToTop() {
    _obPostsStreamController.scrollToTop();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _localizationService = openbookProvider.localizationService;
    _navigationService = openbookProvider.navigationService;

    if (_needsBootstrap) _bootstrap();

    return OBPostsStream(
      streamIdentifier: 'explorePostsTab',
      refresher: _postsStreamRefresher,
      onScrollLoader: _postsStreamOnScrollLoader,
      controller: _obPostsStreamController,
      isTopPostsStream: true,
      initialPosts: _topPostsCacheData,
      refreshOnCreate: _topPostsCacheData.length == 0,
      postBuilder: _topPostBuilder,
      prependedItems: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            OBPrimaryAccentText(
                _localizationService.post__top_posts_title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            OBIconButton(
              OBIcons.settings,
              themeColor: OBIconThemeColor.primaryAccent,
              onPressed: _onWantsToSeeExcludedCommunities,
            )
    ],
          ),
        )
      ],
    );
  }

  void _bootstrap() async {
    _topPostScrollPosition = await _userService.getStoredTopPostsScrollPosition();
    TopPostsList topPostsList = await _userService.getStoredTopPosts();
    if (topPostsList.posts != null) {
      List<Post> posts = topPostsList.posts.map((topPost) => topPost.post).toList();
      _topPostsCacheData = posts;
      print(posts);
    }
  }

  Widget _topPostBuilder(BuildContext context, Post post, String streamUniqueIdentifier, Function(Post) onPostDeleted) {
    if (_excludedCommunities.contains(post.community.id)) {
      post.updateIsFromExcludedCommunity(true);
    } else {
      post.updateIsFromExcludedCommunity(false);
    }

    String inViewId = '${streamUniqueIdentifier}_${post.id.toString()}';

    return OBPost(
      post,
      key: Key(inViewId),
      onPostDeleted: onPostDeleted,
      onCommunityExcluded: _onCommunityExcluded,
      onUndoCommunityExcluded: _onUndoCommunityExcluded,
      inViewId: inViewId,
      isTopPost: true,
    );
  }

  void _onWantsToSeeExcludedCommunities() {
    _navigationService.navigateToTopPostsExcludedCommunities(context: context);
  }

  void _onCommunityExcluded(Community community) {
      _excludedCommunities.add(community.id);
      _currentPosts.forEach((post) {
        if(post.community.id == community.id) {
          post.updateIsFromExcludedCommunity(true);
        }
      });
  }

  void _onUndoCommunityExcluded(Community community) {
      _excludedCommunities.remove(community.id);
      _currentPosts.forEach((post) {
        if(post.community.id == community.id) {
          post.updateIsFromExcludedCommunity(false);
        }
      });
  }

  Future<List<Post>> _postsStreamRefresher() async {
    List<TopPost> topPosts = (await _userService.getTopPosts(count: 2)).posts;
    List<Post> posts = topPosts.map((topPost) => topPost.post).toList();
    _setTopPosts(topPosts);
    _setPosts(posts);
    _clearExcludedCommunities();

    return posts;
  }

  Future<List<Post>> _postsStreamOnScrollLoader(List<Post> posts) async {
    TopPost lastTopPost = _currentTopPosts.last;
    int lastTopPostId = lastTopPost.id;

    List<TopPost> moreTopPosts = (await _userService.getTopPosts(
        maxId: lastTopPostId,
        count: 10))
        .posts;

    List<Post> morePosts = moreTopPosts.map((topPost) => topPost.post).toList();

    _appendCurrentTopPosts(moreTopPosts);
    _appendCurrentPosts(morePosts);

    return morePosts;
  }

  void _clearExcludedCommunities() {
    setState(() {
      _excludedCommunities = [];
    });
  }

  void _setTopPosts(List<TopPost> posts) async {
    setState(() {
      _currentTopPosts = posts;
    });
    await _userService.setStoredTopPosts(_currentTopPosts);
  }

  void _setPosts(List<Post> posts) {
    setState(() {
      _currentPosts = posts;
    });
  }

  void _appendCurrentTopPosts(List<TopPost> posts) {
    List<TopPost> newPosts = _currentTopPosts + posts;
    setState(() {
      _currentTopPosts = newPosts;
    });
  }

  void _appendCurrentPosts(List<Post> posts) {
    List<Post> newPosts = _currentPosts + posts;
    setState(() {
      _currentPosts = newPosts;
    });
  }


  @override
  bool get wantKeepAlive => true;

}

class OBTopPostsController {
  OBTopPostsState _state;

  void attach(OBTopPostsState state) {
    _state = state;
  }

  Future<void> refresh() {
    return _state.refresh();
  }

  void scrollToTop() {
    _state.scrollToTop();
  }
}