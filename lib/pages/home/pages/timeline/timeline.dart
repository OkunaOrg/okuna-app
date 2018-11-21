import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/pages/timeline//widgets/timeline-posts.dart';
import 'package:Openbook/pages/home/pages/post/post.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBTimelinePage extends StatefulWidget {
  final OnWantsToReactToPost onWantsToReactToPost;
  final OnWantsToCreatePost onWantsToCreatePost;
  final OBTimelinePageController controller;

  OBTimelinePage(
      {this.onWantsToReactToPost, this.onWantsToCreatePost, this.controller});

  @override
  OBTimelinePageState createState() {
    return OBTimelinePageState();
  }
}

class OBTimelinePageState extends State<OBTimelinePage> {
  OBTimelinePostsController _timelinePostsController;

  @override
  void initState() {
    super.initState();
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
              onWantsToCommentPost: (Post post) {
                Navigator.of(context).push(CupertinoPageRoute<void>(
                    builder: (BuildContext context) => Material(
                          child: OBPostPage(post,
                              autofocusCommentInput: true,
                              onWantsToReactToPost:
                                  widget.onWantsToReactToPost),
                        )));
              },
              onWantsToSeePostComments: (Post post) {
                Navigator.of(context).push(CupertinoPageRoute<void>(
                    builder: (BuildContext context) => Material(
                          child: OBPostPage(post,
                              autofocusCommentInput: false,
                              onWantsToReactToPost:
                                  widget.onWantsToReactToPost),
                        )));
              },
            ),
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
}

typedef Future<Post> OnWantsToCreatePost();
