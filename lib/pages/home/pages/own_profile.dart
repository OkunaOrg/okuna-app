import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/pages/home/pages/post/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBOwnProfilePage extends StatefulWidget {
  final OnWantsToReactToPost onWantsToReactToPost;
  final OnWantsToEditUserProfile onWantsToEditUserProfile;
  final OBOwnProfilePageController controller;

  OBOwnProfilePage(
      {this.onWantsToReactToPost,
      this.controller,
      this.onWantsToEditUserProfile});

  @override
  State<StatefulWidget> createState() {
    return OBOwnProfilePageState();
  }
}

class OBOwnProfilePageState extends State<OBOwnProfilePage> {
  OBProfilePageController _profilePageController;
  int _pushedRoutes;

  @override
  void initState() {
    super.initState();
    _pushedRoutes = 0;
    _profilePageController = OBProfilePageController();
    if (widget.controller != null) widget.controller.attach(this);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;

    return StreamBuilder(
      stream: userService.loggedInUserChange,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var data = snapshot.data;
        if (data == null) return SizedBox();
        return OBProfilePage(
          data,
          controller: _profilePageController,
          onWantsToReactToPost: widget.onWantsToReactToPost,
          onWantsToEditUserProfile: widget.onWantsToEditUserProfile,
          onWantsToSeeUserProfile: _onWantsToSeeUserProfile,
          onWantsToSeePostComments: _onWantsToSeePostComments,
          onWantsToCommentPost: _onWantsToCommentPost,
        );
      },
    );
  }

  void scrollToTop() {
    _profilePageController.scrollToTop();
  }

  void popUntilFirst() {
    Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst);
    _pushedRoutes = 0;
  }

  bool hasPushedRoutes() {
    return _pushedRoutes > 0;
  }

  void _incrementPushedRoutes() {
    _pushedRoutes += 1;
  }

  void _decrementPushedRoutes() {
    if (_pushedRoutes == 0) return;
    _pushedRoutes -= 1;
  }

  void _onWantsToSeeUserProfile(User user) async {
    _incrementPushedRoutes();
    await Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => Material(
              child: OBProfilePage(user,
                  onWantsToSeeUserProfile: _onWantsToSeeUserProfile,
                  onWantsToSeePostComments: _onWantsToSeePostComments,
                  onWantsToCommentPost: _onWantsToCommentPost,
                  onWantsToReactToPost: widget.onWantsToReactToPost),
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
}

class OBOwnProfilePageController {
  OBOwnProfilePageState _ownProfilePageState;

  void attach(OBOwnProfilePageState ownProfilePageState) {
    assert(ownProfilePageState != null, 'Cannot attach to empty state');
    _ownProfilePageState = ownProfilePageState;
  }

  void scrollToTop() {
    _ownProfilePageState.scrollToTop();
  }

  void popUntilProfile() {
    _ownProfilePageState.popUntilFirst();
  }

  bool hasPushedRoutes() {
    return _ownProfilePageState.hasPushedRoutes();
  }
}
