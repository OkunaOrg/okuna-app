import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/posts_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/profile_card.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_cover.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_nav_bar.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_no_posts.dart';
import 'package:Openbook/pages/home/pages/timeline/widgets/timeline-posts.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/post/post.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

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
  bool _morePostsToLoad;
  List<Post> _posts;
  UserService _userService;
  ToastService _toastService;
  ScrollController _scrollController;
  bool _refreshPostsInProgress;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _needsBootstrap = true;
    _morePostsToLoad = false;
    _user = widget.user;
    _posts = [];
    _refreshPostsInProgress = false;
    if (widget.controller != null) widget.controller.attach(this);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    if (_needsBootstrap) {
      _bootstrap();
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
                child: RefreshIndicator(
                    child: LoadMore(
                        whenEmptyLoad: false,
                        isFinish: !_morePostsToLoad,
                        delegate: OBHomePostsLoadMoreDelegate(),
                        child: ListView.builder(
                            controller: _scrollController,
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.all(0),
                            itemCount: _posts.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                Widget postsItem;

                                if (_refreshPostsInProgress && _posts.isEmpty) {
                                  postsItem = SizedBox(
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: OBProgressIndicator(),
                                      ),
                                    ),
                                  );
                                } else if (_posts.length == 0) {
                                  postsItem = OBProfileNoPosts(
                                    _user,
                                    onWantsToRefreshProfile: _refresh,
                                  );
                                } else {
                                  postsItem = const SizedBox(
                                    height: 20,
                                  );
                                }

                                return Column(
                                  children: <Widget>[
                                    OBProfileCover(_user),
                                    OBProfileCard(
                                      _user,
                                    ),
                                    postsItem
                                  ],
                                );
                              }

                              int postIndex = index - 1;

                              var post = _posts[postIndex];

                              return OBPost(post,
                                  onPostDeleted: _onPostDeleted,
                                  key: Key(post.id.toString()));
                            }),
                        onLoadMore: _loadMorePosts),
                    onRefresh: _refresh),
              )
            ],
          ),
        ));
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _bootstrap() async {
    await _refresh();
  }

  Future<void> _refresh() async {
    try {
      await Future.wait([_refreshUser(), _refreshPosts()]);
    } catch (error) {
      _onError(error);
    }
  }

  Future<void> _refreshUser() async {
    var user = await _userService.getUserWithUsername(_user.username);
    _setUser(user);
  }

  Future<void> _refreshPosts() async {
    _setRefreshPostsInProgress(true);
    PostsList postsList =
        await _userService.getTimelinePosts(username: _user.username);
    _posts = postsList.posts;
    _setPosts(_posts);
    _setRefreshPostsInProgress(false);
  }

  Future<bool> _loadMorePosts() async {
    var lastPost = _posts.last;
    var lastPostId = lastPost.id;
    try {
      var morePosts = (await _userService.getTimelinePosts(
              maxId: lastPostId, username: _user.username))
          .posts;

      if (morePosts.length == 0) {
        _setMorePostsToLoad(false);
      } else {
        setState(() {
          _posts.addAll(morePosts);
        });
      }
      return true;
    } catch (error) {
      _onError(error);
    }

    return false;
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

  void _setUser(User user) {
    setState(() {
      _user = user;
    });
  }

  void _setPosts(List<Post> posts) {
    setState(() {
      _posts = posts;
    });
  }

  void _setMorePostsToLoad(bool morePostsToLoad) {
    setState(() {
      _morePostsToLoad = morePostsToLoad;
    });
  }

  void _setRefreshPostsInProgress(bool refreshPostsInProgress) {
    setState(() {
      _refreshPostsInProgress = refreshPostsInProgress;
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
