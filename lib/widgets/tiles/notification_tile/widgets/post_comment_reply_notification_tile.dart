import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/models/notifications/post_comment_notification.dart';
import 'package:Openbook/models/notifications/post_comment_reply_notification.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class OBPostCommentReplyNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final PostCommentReplyNotification postCommentNotification;
  static final double postImagePreviewSize = 40;
  final VoidCallback onPressed;

  const OBPostCommentReplyNotificationTile(
      {Key key,
        @required this.notification,
        @required this.postCommentNotification,
        this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostComment postComment = postCommentNotification.postComment;
    PostComment parentComment = postCommentNotification.parentComment;
    Post post = postComment.post;
    String postCommenterUsername = postComment.getCommenterUsername();
    String postCommentText = postComment.text;

    int postCreatorId = postCommentNotification.getPostCreatorId();
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    bool isOwnPostNotification =
        openbookProvider.userService.getLoggedInUser().id == postCreatorId;

    Widget postImagePreview;
    if (post.hasImage()) {
      postImagePreview = ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image(
          image: AdvancedNetworkImage(post.getImage(), useDiskCache: true),
          height: postImagePreviewSize,
          width: postImagePreviewSize,
          fit: BoxFit.cover,
        ),
      );
    }

    Function navigateToCommenterProfile = () {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

      openbookProvider.navigationService
          .navigateToUserProfile(user: postComment.commenter, context: context);
    };

    return ListTile(
      onTap: () {
        if (onPressed != null) onPressed();
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

        openbookProvider.navigationService.navigateToPostCommentRepliesLinked(
            postComment: postComment, context: context, parentComment: parentComment);
      },
      leading: OBAvatar(
        onPressed: navigateToCommenterProfile,
        size: OBAvatarSize.medium,
        avatarUrl: postComment.commenter.getProfileAvatar(),
      ),
      title: OBActionableSmartText(
        text: isOwnPostNotification
            ? '@$postCommenterUsername replied: $postCommentText'
            : '@$postCommenterUsername also replied: $postCommentText',
      ),
      trailing: postImagePreview,
      subtitle: OBSecondaryText(notification.getRelativeCreated()),
    );
  }
}
