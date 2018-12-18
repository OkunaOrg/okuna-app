import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/lib/poppable_page_controller.dart';
import 'package:Openbook/pages/home/pages/timeline/widgets/timeline-posts.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/buttons/floating_action_button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_accent_text.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
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

class OBTimelinePageState extends State<OBTimelinePage> {
  OBTimelinePostsController _timelinePostsController;

  @override
  void initState() {
    super.initState();
    _timelinePostsController = OBTimelinePostsController();
    if (widget.controller != null)
      widget.controller.attach(context: context, state: this);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var modalService = openbookProvider.modalService;

    return OBCupertinoPageScaffold(
        navigationBar: OBNavigationBar(
          title: 'Home',
          trailing: OBIcon(OBIcons.filter, themeColor: OBIconThemeColor.primaryAccent,),
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

class OBTimelinePageController extends PoppablePageController {
  OBTimelinePageState _state;

  void attach({@required BuildContext context, OBTimelinePageState state}) {
    super.attach(context: context);
    _state = state;
  }

  void scrollToTop() {
    _state.scrollToTop();
  }
}
