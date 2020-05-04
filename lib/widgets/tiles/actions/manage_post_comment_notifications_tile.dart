import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_comment.dart';
import 'package:Okuna/pages/home/bottom_sheets/manage_notifications/manage_post_notifications.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/bottom_sheet.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBManagePostCommentNotificationsTile extends StatefulWidget {
  final Post post;
  final PostComment postComment;
  final OnNotificationSettingsSave onNotificationSettingsSave;

  const OBManagePostCommentNotificationsTile({
    Key key,
    @required this.post,
    @required this.postComment,
    this.onNotificationSettingsSave,
  }) : super(key: key);

  @override
  OBManagePostCommentNotificationsTileState createState() {
    return OBManagePostCommentNotificationsTileState();
  }
}

class OBManagePostCommentNotificationsTileState
    extends State<OBManagePostCommentNotificationsTile> {
  BottomSheetService _bottomSheetService;
  LocalizationService _localizationService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _bottomSheetService = openbookProvider.bottomSheetService;
    _localizationService = openbookProvider.localizationService;

    return StreamBuilder(
      stream: widget.postComment.updateSubject,
      initialData: widget.postComment,
      builder: (BuildContext context, AsyncSnapshot<PostComment> snapshot) {
        var postComment = snapshot.data;

        return ListTile(
          leading: OBIcon(OBIcons.notifications),
          title: OBText(postComment.postCommentNotificationsSubscription != null
              ? _localizationService.post__manage_post_comment_notifications
              : _localizationService
                  .post__subscribe_post_comment_notifications),
          onTap: _navigateToManagePostComment,
        );
      },
    );
  }

  void _navigateToManagePostComment() {
    _bottomSheetService.showManagePostCommentNotifications(
        context: context,
        post: widget.post,
        postComment: widget.postComment,
        onNotificationSettingsSave: () {
          if (widget.onNotificationSettingsSave != null)
            widget.onNotificationSettingsSave();
        });
  }
}
