import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/lib/base_state.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/pages/home/pages/post/post.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:Openbook/widgets/routes/slide_right_route.dart';
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

class OBOwnProfilePageState extends OBBasePageState<OBOwnProfilePage> {
  OBProfilePageController _profilePageController;

  @override
  void initState() {
    super.initState();
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

  void _onWantsToSeeUserProfile(User user) async {
    incrementPushedRoutes();
    await Navigator.push(context,
        OBSlideRightRoute(
            key: Key('obSlideProfileViewFromProfile'),
            widget: OBProfilePage(
              user,
              onWantsToSeeUserProfile: _onWantsToSeeUserProfile,
              onWantsToSeePostComments: _onWantsToSeePostComments,
              onWantsToCommentPost: _onWantsToCommentPost,
              onWantsToReactToPost: widget.onWantsToReactToPost,
              onWantsToEditUserProfile: widget.onWantsToEditUserProfile,
            )
        ));
    decrementPushedRoutes();
  }

  void _onWantsToCommentPost(Post post) async {
    incrementPushedRoutes();
    await Navigator.push(context,
        OBSlideRightRoute(
            key: Key('obSlidePostCommentsFromProfile'),
            widget: OBPostPage(post,
                autofocusCommentInput: true,
                onWantsToReactToPost: widget.onWantsToReactToPost)
        )
      );
    decrementPushedRoutes();
  }

  void _onWantsToSeePostComments(Post post) async {
    incrementPushedRoutes();
    await Navigator.push(context,
        OBSlideRightRoute(
            key: Key('obSlidePostCommentsFromProfile'),
            widget: OBPostPage(post,
                autofocusCommentInput: false,
                onWantsToReactToPost: widget.onWantsToReactToPost)
        ));
    decrementPushedRoutes();
  }
}

class OBOwnProfilePageController
    extends OBBasePageStateController<OBOwnProfilePageState> {
  void scrollToTop() {
    state.scrollToTop();
  }
}
