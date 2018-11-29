import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/pages/home/pages/timeline//widgets/timeline-posts.dart';
import 'package:Openbook/pages/home/pages/post/post.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBTimelinePage extends StatefulWidget {
  final OnWantsToReactToPost onWantsToReactToPost;
  final OnWantsToEditUserProfile onWantsToEditUserProfile;
  final OnWantsToCreatePost onWantsToCreatePost;
  final OBTimelinePageController controller;

  OBTimelinePage(
      {this.onWantsToReactToPost,
      this.onWantsToCreatePost,
      this.controller,
      this.onWantsToEditUserProfile});

  @override
  OBTimelinePageState createState() {
    return OBTimelinePageState();
  }
}

class OBTimelinePageState extends State<OBTimelinePage> {
  OBTimelinePostsController _timelinePostsController;
  int _pushedRoutes;

  @override
  void initState() {
    super.initState();
    _pushedRoutes = 0;
    _timelinePostsController = OBTimelinePostsController();
    if (widget.controller != null) widget.controller.attach(this);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          backgroundColor: Colors.white,
          middle: Text(
            'Home',
          ),
        ),
        child: Stack(
          children: <Widget>[
            OBTimelinePosts(
                controller: _timelinePostsController,
                onWantsToReactToPost: widget.onWantsToReactToPost,
                onWantsToSeeUserProfile: _onWantsToSeeUserProfile,
                onWantsToCommentPost: _onWantsToCommentPost,
                onWantsToSeePostComments: _onWantsToSeePostComments),
            Positioned(
                bottom: 20.0,
                right: 20.0,
                child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      Post createdPost = await widget.onWantsToCreatePost();
                      if (createdPost != null) {
                        _timelinePostsController.addPostToTop(createdPost);
                        _timelinePostsController.scrollToTop();
                      }
                    },
                    child: OBIcon(OBIcons.createPost)))
          ],
        ));
  }

  void scrollToTop() {
    _timelinePostsController.scrollToTop();
  }

  void popUntilFirst() {
    Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst);
    _pushedRoutes = 0;
  }

  bool hasPushedRoutes() {
    return _pushedRoutes > 0;
  }

  void _onWantsToSeeUserProfile(User user) async {
    _incrementPushedRoutes();
    await Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => Material(
              child: OBProfilePage(
                user,
                onWantsToSeeUserProfile: _onWantsToSeeUserProfile,
                onWantsToSeePostComments: _onWantsToSeePostComments,
                onWantsToCommentPost: _onWantsToCommentPost,
                onWantsToReactToPost: widget.onWantsToReactToPost,
                onWantsToEditUserProfile: widget.onWantsToEditUserProfile,
              ),
            )));
    _decrementPushedRoutes();
  }

  void _onWantsToCommentPost(Post post) async {
    _incrementPushedRoutes();
    await Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => Material(
              child: OBPostPage(post,
                  autofocusCommentInput: true,
                  onWantsToReactToPost: widget.onWantsToReactToPost),
            )));
    _decrementPushedRoutes();
  }

  void _onWantsToSeePostComments(Post post) async {
    _incrementPushedRoutes();
    await Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => Material(
              child: OBPostPage(post,
                  autofocusCommentInput: false,
                  onWantsToReactToPost: widget.onWantsToReactToPost),
            )));
    _decrementPushedRoutes();
  }

  void _incrementPushedRoutes() {
    _pushedRoutes += 1;
  }

  void _decrementPushedRoutes() {
    if (_pushedRoutes == 0) return;
    _pushedRoutes -= 1;
  }
}

class OBTimelinePageController {
  OBTimelinePageState _timelinePageState;

  /// Register the OBHomePostsState to the controller
  void attach(OBTimelinePageState timelinePageState) {
    assert(timelinePageState != null, 'Cannot attach to empty state');
    _timelinePageState = timelinePageState;
  }

  void scrollToTop() {
    _timelinePageState.scrollToTop();
  }

  void popUntilTimeline() {
    _timelinePageState.popUntilFirst();
  }

  bool hasPushedRoutes() {
    return _timelinePageState.hasPushedRoutes();
  }
}

typedef Future<Post> OnWantsToCreatePost();
