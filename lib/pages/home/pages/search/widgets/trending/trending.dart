import 'package:Openbook/pages/home/pages/post/widgets/post_comment/post_comment.dart';
import 'package:Openbook/pages/home/pages/search/widgets/trending/widgets/trending_posts.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_comment.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:Openbook/widgets/post/widgets/post_comments/post_comments.dart';
import 'package:flutter/material.dart';

class OBTrending extends StatefulWidget {
  final OBTrendingController controller;
  final OnWantsToCommentPost onWantsToCommentPost;
  final OnWantsToReactToPost onWantsToReactToPost;
  final OnWantsToSeePostComments onWantsToSeePostComments;
  final OnWantsToSeeUserProfile onWantsToSeeUserProfile;

  OBTrending(
      {this.controller,
      this.onWantsToSeePostComments,
      this.onWantsToCommentPost,
      this.onWantsToReactToPost,
      this.onWantsToSeeUserProfile});

  @override
  State<StatefulWidget> createState() {
    return OBTrendingState();
  }
}

class OBTrendingState extends State<OBTrending> {
  ScrollController _scrollController;
  OBTrendingPostsController _trendingPostsController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller.attach(this);
    _trendingPostsController = OBTrendingPostsController();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: ListView.builder(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            itemCount: 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return OBTrendingPosts(
                  controller: _trendingPostsController,
                  onWantsToReactToPost: widget.onWantsToReactToPost,
                  onWantsToSeeUserProfile: widget.onWantsToSeeUserProfile,
                  onWantsToSeePostComments: widget.onWantsToSeePostComments,
                  onWantsToCommentPost: widget.onWantsToCommentPost,
                );
              }
            }),
        onRefresh: _refresh);
  }

  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  Future<void> _refresh() {
    return _trendingPostsController.refresh();
  }
}

class OBTrendingController {
  OBTrendingState _state;

  void attach(OBTrendingState state) {
    _state = state;
  }

  void scrollToTop() {
    _state.scrollToTop();
  }
}
