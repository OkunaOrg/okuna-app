import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/post/widgets/expanded_post_comment.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/profile_card.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_cover.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_nav_bar.dart';
import 'package:Openbook/pages/home/pages/timeline/widgets/timeline-posts.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/post/post.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_comment.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:Openbook/widgets/post/widgets/post_comments/post_comments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore_widget.dart';

class OBProfilePage extends StatefulWidget {
  final User user;
  final OnWantsToCommentPost onWantsToCommentPost;
  final OnWantsToReactToPost onWantsToReactToPost;
  final OnWantsToSeePostComments onWantsToSeePostComments;
  final OnWantsToSeeUserProfile onWantsToSeeUserProfile;

  OBProfilePage(this.user,
      {this.onWantsToSeeUserProfile,
      this.onWantsToSeePostComments,
      this.onWantsToReactToPost,
      this.onWantsToCommentPost});

  @override
  OBProfilePageState createState() {
    return OBProfilePageState();
  }
}

class OBProfilePageState extends State<OBProfilePage> {
  User _user;
  bool _needsBootstrap;
  bool _refreshUserInProgress;
  bool _refreshPostsInProgress;
  bool _morePostsToLoad;
  List<Post> _posts;
  UserService _userService;
  ToastService _toastService;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _refreshUserInProgress = false;
    _needsBootstrap = true;
    _morePostsToLoad = false;
    _user = widget.user;
    _posts = [];
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
      navigationBar: CupertinoNavigationBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        middle: Text(
          '@' + _user.username,
          style: TextStyle(color: Colors.black),
        ),
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(child: OBProfileCover(_user)),
          Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      child: LoadMore(
                          whenEmptyLoad: false,
                          isFinish: !_morePostsToLoad,
                          delegate: OBHomePostsLoadMoreDelegate(),
                          child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.all(0),
                              itemCount: _posts.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(top: 200),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(50),
                                                  topLeft: Radius.circular(50)),
                                              color: Colors.white),
                                          child: OBProfileCard(_user)),
                                    ],
                                  );
                                }

                                int postIndex = index - 1;

                                var post = _posts[postIndex];

                                return OBPost(
                                  post,
                                  onWantsToReactToPost:
                                      widget.onWantsToReactToPost,
                                  onWantsToCommentPost:
                                      widget.onWantsToCommentPost,
                                  onWantsToSeePostComments:
                                      widget.onWantsToSeePostComments,
                                  onWantsToSeeUserProfile:
                                      widget.onWantsToSeeUserProfile,
                                );
                              }),
                          onLoadMore: _loadMorePosts),
                      onRefresh: _refresh),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _bootstrap() async {
    await _refresh();
  }

  Future<void> _refresh() async {
    await Future.wait([_refreshUser(), _refreshPosts()]);
  }

  Future<void> _refreshUser() async {
    _setRefreshUserInProgress(true);

    try {
      var user = await _userService.getUserWithUsername(_user.username);
      _setUser(user);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection');
    } catch (e) {
      _toastService.error(message: 'Unknown error.');
      rethrow;
    } finally {
      _setRefreshUserInProgress(false);
    }
  }

  Future<void> _refreshPosts() async {
    _setRefreshPostsInProgress(true);
    try {
      _posts = (await _userService.getTimelinePosts()).posts;
      _setPosts(_posts);
    } on HttpieConnectionRefusedError catch (error) {
      _toastService.error(message: 'No internet connection');
    } catch (error) {
      _toastService.error(message: 'Unknown error.');
      rethrow;
    } finally {
      _setRefreshPostsInProgress(false);
    }
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
    } on HttpieConnectionRefusedError catch (error) {
      _toastService.error(message: 'No internet connection');
    } catch (error) {
      _toastService.error(message: 'Unknown error.');
      rethrow;
    }

    return false;
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

  void _setRefreshUserInProgress(bool refreshUserInProgress) {
    setState(() {
      this._refreshUserInProgress = refreshUserInProgress;
    });
  }

  void _setRefreshPostsInProgress(bool refreshPostsInProgress) {
    setState(() {
      this._refreshPostsInProgress = refreshPostsInProgress;
    });
  }

  void _setMorePostsToLoad(bool morePostsToLoad) {
    setState(() {
      _morePostsToLoad = morePostsToLoad;
    });
  }
}
