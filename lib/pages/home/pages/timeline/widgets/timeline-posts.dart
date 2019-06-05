import 'dart:async';

import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/posts_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/post/post.dart';
import 'package:Openbook/widgets/scroll_container.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/loading_indicator_tile.dart';
import 'package:Openbook/widgets/tiles/retry_tile.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

class OBTimelinePosts extends StatefulWidget {
  final OBTimelinePostsController controller;

  const OBTimelinePosts({
    this.controller,
  });

  @override
  OBTimelinePostsState createState() {
    return OBTimelinePostsState();
  }
}

class OBTimelinePostsState extends State<OBTimelinePosts> {
  List<Post> _posts;
  List<Circle> _filteredCircles;
  List<FollowsList> _filteredFollowsLists;
  bool _needsBootstrap;
  bool _cacheLoadAttempted;
  bool _isFirstLoad;
  UserService _userService;
  ToastService _toastService;
  StreamSubscription _loggedInUserChangeSubscription;
  ScrollController _postsScrollController;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  OBTimelinePostsStatus _status;
  CancelableOperation _timelineRequest;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller.attach(this);
    _posts = [];
    _filteredCircles = [];
    _filteredFollowsLists = [];
    _needsBootstrap = true;
    _cacheLoadAttempted = false;
    _isFirstLoad = true;
    _status = OBTimelinePostsStatus.refreshingPosts;
    _postsScrollController = ScrollController();
    _postsScrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _loggedInUserChangeSubscription.cancel();
    _postsScrollController.removeListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _userService = provider.userService;
      _toastService = provider.toastService;
      _bootstrap();
      _needsBootstrap = false;
    }

    Widget timelinePostsWidget = _posts.isEmpty && _cacheLoadAttempted
        ? _buildDrHoo()
        : _buildTimelinePosts();

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshPosts,
      child: timelinePostsWidget,
    );
  }

  Widget _buildTimelinePosts() {
    return OBScrollContainer(
      scroll: ListView.builder(
          controller: _postsScrollController,
          physics: const ClampingScrollPhysics(),
          cacheExtent: 30,
          padding: const EdgeInsets.all(0),
          itemCount: _posts.length,
          itemBuilder: _buildTimelinePost),
    );
  }

  Widget _buildTimelinePost(BuildContext context, int index) {
    Post post = _posts[index];

    OBPost postWidget = OBPost(
      post,
      onPostDeleted: _onPostDeleted,
      key: Key(
        post.id.toString(),
      ),
    );

    bool isLastItem = index == _posts.length - 1;

    if (isLastItem && _status != OBTimelinePostsStatus.idle) {
      switch (_status) {
        case OBTimelinePostsStatus.loadingMorePosts:
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              postWidget,
              OBLoadingIndicatorTile(),
            ],
          );
          break;
        case OBTimelinePostsStatus.loadingMorePostsFailed:
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              postWidget,
              OBRetryTile(
                onWantsToRetry: _loadMorePosts,
              ),
            ],
          );
          break;
        case OBTimelinePostsStatus.noMorePostsToLoad:
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              postWidget,
              ListTile(
                title: OBSecondaryText(
                  '🎉  All posts loaded',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        default:
      }
    }

    return postWidget;

  }

  Widget _buildDrHoo() {
    String drHooTitle;
    String drHooSubtitle;
    bool hasRefreshButton = !_isFirstLoad;
    Function refreshFunction = _refreshPosts;

    switch (_status) {
      case OBTimelinePostsStatus.refreshingPosts:
        drHooTitle = 'Hang in there!';
        drHooSubtitle = 'Loading your timeline.';
        break;
      case OBTimelinePostsStatus.noMorePostsToLoad:
        drHooTitle = 'Your timeline is empty.';
        drHooSubtitle = 'Follow users or join a community to get started!';
        break;
      case OBTimelinePostsStatus.loadingMorePostsFailed:
        drHooTitle = 'Could not load your timeline.';
        drHooSubtitle = 'Try again in a couple seconds';
        refreshFunction = _bootstrapPosts;
        hasRefreshButton = true;
        break;
      default:
        drHooTitle = 'Something\'s not right.';
        drHooSubtitle = 'Try refreshing the timeline.';
        hasRefreshButton = true;
    }

    List<Widget> drHooColumnItems = [
      Image.asset(
        'assets/images/stickers/owl-instructor.png',
        height: 100,
      ),
      const SizedBox(
        height: 20.0,
      ),
      OBText(
        drHooTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 10.0,
      ),
      OBText(
        drHooSubtitle,
        textAlign: TextAlign.center,
      )
    ];

    if (hasRefreshButton) {
      drHooColumnItems.addAll([
        const SizedBox(
          height: 30,
        ),
        OBButton(
          icon: const OBIcon(
            OBIcons.refresh,
            size: OBIconSize.small,
          ),
          type: OBButtonType.highlight,
          child: const OBText('Refresh posts'),
          onPressed: refreshFunction,
          isLoading: _timelineRequest != null,
        )
      ]);
    }

    return SizedBox(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: drHooColumnItems,
          ),
        ),
      ),
    );
  }

  void scrollToTop() {
    if (_postsScrollController.hasClients) {
      if (_postsScrollController.offset == 0) {
        _refreshIndicatorKey.currentState.show();
      }

      _postsScrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  void addPostToTop(Post post) {
    setState(() {
      this._posts.insert(0, post);
    });
  }

  Future<void> setFilters(
      {List<Circle> circles, List<FollowsList> followsLists}) async {
    _filteredCircles = circles;
    _filteredFollowsLists = followsLists;
    return _refreshPosts();
  }

  Future<void> clearFilters() {
    _filteredCircles = [];
    _filteredFollowsLists = [];
    return _refreshPosts();
  }

  List<Circle> getFilteredCircles() {
    return _filteredCircles.toList();
  }

  List<FollowsList> getFilteredFollowsLists() {
    return _filteredFollowsLists.toList();
  }

  void _bootstrap() async {
    _loggedInUserChangeSubscription =
        _userService.loggedInUserChange.listen(_onLoggedInUserChange);
  }

  void _onScroll() {
    if (_status == OBTimelinePostsStatus.loadingMorePosts ||
        _status == OBTimelinePostsStatus.noMorePostsToLoad) return;
    if (_postsScrollController.position.pixels >
        _postsScrollController.position.maxScrollExtent * 0.1) {
      _loadMorePosts();
    }
  }

  void _cancelPreviousTimelineRequest() {
    if (_timelineRequest != null) {
      _timelineRequest.cancel();
      _timelineRequest = null;
    }
  }

  void _onLoggedInUserChange(User newUser) async {
    if (newUser == null) return;
    _bootstrapPosts();
    _loggedInUserChangeSubscription.cancel();
  }

  Future _bootstrapPosts() async {
    PostsList storedPosts = await _userService.getStoredFirstPosts();
    if (storedPosts.posts != null) _setPosts(storedPosts.posts);
    _setCacheLoadAttempted(true);
    _refreshIndicatorKey.currentState.show();
  }

  Future<void> _refreshPosts() async {
    _cancelPreviousTimelineRequest();
    _setStatus(OBTimelinePostsStatus.refreshingPosts);
    try {
      bool areFirstPosts = _isFirstLoad;
      bool cachePosts =
          _filteredCircles.isEmpty && _filteredFollowsLists.isEmpty;

      Future<PostsList> postsListFuture = _userService.getTimelinePosts(
          count: 10,
          circles: _filteredCircles,
          followsLists: _filteredFollowsLists,
          cachePosts: cachePosts,
          areFirstPosts: areFirstPosts);

      _timelineRequest = CancelableOperation.fromFuture(postsListFuture);

      List<Post> posts = (await postsListFuture).posts;

      if (_isFirstLoad) _isFirstLoad = false;

      if (posts.length == 0) {
        _setStatus(OBTimelinePostsStatus.noMorePostsToLoad);
      } else {
        _setStatus(OBTimelinePostsStatus.idle);
      }
      _setPosts(posts);
    } catch (error) {
      _setStatus(OBTimelinePostsStatus.loadingMorePostsFailed);
      _onError(error);
    } finally {
      _timelineRequest = null;
    }
  }

  Future _loadMorePosts() async {
    if (_status == OBTimelinePostsStatus.refreshingPosts ||
        _status == OBTimelinePostsStatus.noMorePostsToLoad) return null;
    _cancelPreviousTimelineRequest();
    _setStatus(OBTimelinePostsStatus.loadingMorePosts);

    var lastPost = _posts.last;
    var lastPostId = lastPost.id;
    try {
      Future<PostsList> morePostsListFuture = _userService.getTimelinePosts(
          maxId: lastPostId,
          circles: _filteredCircles,
          count: 10,
          followsLists: _filteredFollowsLists);

      _timelineRequest = CancelableOperation.fromFuture(morePostsListFuture);

      List<Post> morePosts = (await morePostsListFuture).posts;

      if (morePosts.length == 0) {
        _setStatus(OBTimelinePostsStatus.noMorePostsToLoad);
      } else {
        _setStatus(OBTimelinePostsStatus.idle);
        _addPosts(morePosts);
      }
    } catch (error) {
      _setStatus(OBTimelinePostsStatus.loadingMorePostsFailed);
      _onError(error);
    } finally {
      _timelineRequest = null;
    }
  }

  void _onPostDeleted(Post deletedPost) {
    setState(() {
      _posts.remove(deletedPost);
    });
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

  void _setPosts(List<Post> posts) {
    setState(() {
      _posts = posts;
    });
  }

  void _addPosts(List<Post> posts) {
    setState(() {
      _posts.addAll(posts);
    });
  }

  void _setStatus(OBTimelinePostsStatus status) {
    setState(() {
      _status = status;
    });
  }

  void _setCacheLoadAttempted(bool cacheLoadAttempted) {
    setState(() {
      _cacheLoadAttempted = cacheLoadAttempted;
    });
  }
}

class OBTimelinePostsController {
  OBTimelinePostsState _homePostsState;

  /// Register the OBHomePostsState to the controller
  void attach(OBTimelinePostsState homePostsState) {
    assert(homePostsState != null, 'Cannot attach to empty state');
    _homePostsState = homePostsState;
  }

  void addPostToTop(Post post) {
    _homePostsState.addPostToTop(post);
  }

  void scrollToTop() {
    _homePostsState.scrollToTop();
  }

  void refreshPosts() {
    _homePostsState._refreshPosts();
  }

  bool isAttached() {
    return _homePostsState != null;
  }

  Future<void> setFilters(
      {List<Circle> circles, List<FollowsList> followsLists}) async {
    return _homePostsState.setFilters(
        circles: circles, followsLists: followsLists);
  }

  Future<void> clearFilters() {
    return _homePostsState.clearFilters();
  }

  List<Circle> getFilteredCircles() {
    return _homePostsState.getFilteredCircles();
  }

  List<FollowsList> getFilteredFollowsLists() {
    return _homePostsState.getFilteredFollowsLists();
  }

  int countFilters() {
    return _homePostsState.getFilteredCircles().length +
        _homePostsState.getFilteredFollowsLists().length;
  }
}

enum OBTimelinePostsStatus {
  refreshingPosts,
  loadingMorePosts,
  loadingMorePostsFailed,
  noMorePostsToLoad,
  idle
}
