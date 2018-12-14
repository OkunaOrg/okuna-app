import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/home.dart';
import 'package:Openbook/pages/home/lib/base_state.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/pages/home/pages/timeline//widgets/timeline-posts.dart';
import 'package:Openbook/pages/home/pages/post/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/buttons/floating_action_button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:Openbook/widgets/routes/slide_right_route.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBTimelinePage extends StatefulWidget {
  final OBTimelinePageController controller;

  OBTimelinePage({
    this.controller,
  });

  @override
  OBTimelinePageState createState() {
    return OBTimelinePageState();
  }
}

class OBTimelinePageState extends OBBasePageState<OBTimelinePage> {
  OBTimelinePostsController _timelinePostsController;

  @override
  void initState() {
    super.initState();
    _timelinePostsController = OBTimelinePostsController();
    if (widget.controller != null) widget.controller.attach(this);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var modalService = openbookProvider.modalService;

    return OBCupertinoPageScaffold(
        navigationBar: OBNavigationBar(
          title: 'Home',
        ),
        child: OBPrimaryColorContainer(
          child: Stack(
            children: <Widget>[
              OBTimelinePosts(
                controller: _timelinePostsController,
              ),
              Positioned(
                  bottom: 20.0,
                  right: 20.0,
                  child: OBFloatingActionButton(
                      onPressed: () async {
                        Post createdPost =
                            await modalService.openCreatePost(context: context);
                        if (createdPost != null) {
                          _timelinePostsController.addPostToTop(createdPost);
                          _timelinePostsController.scrollToTop();
                        }
                      },
                      child: OBIcon(OBIcons.createPost,
                          size: OBIconSize.large, color: Colors.white)))
            ],
          ),
        ));
  }

  void scrollToTop() {
    _timelinePostsController.scrollToTop();
  }
}

class OBTimelinePageController
    extends OBBasePageStateController<OBTimelinePageState> {
  void scrollToTop() {
    state.scrollToTop();
  }
}
