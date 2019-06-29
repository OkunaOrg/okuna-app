import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/models/notifications/post_comment_reaction_notification.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/post_comment_reaction.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/emoji_picker/widgets/emoji_groups/widgets/emoji_group/widgets/emoji.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class OBPostCommentReactionNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final PostCommentReactionNotification postCommentReactionNotification;
  static final double postCommentImagePreviewSize = 40;
  final VoidCallback onPressed;

  const OBPostCommentReactionNotificationTile(
      {Key key,
      @required this.notification,
      @required this.postCommentReactionNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostCommentReaction postCommentReaction =
        postCommentReactionNotification.postCommentReaction;
    PostComment postComment = postCommentReaction.postComment;
    Post post = postComment.post;
    String postCommentReactorUsername =
        postCommentReaction.getReactorUsername();

    Widget postCommentImagePreview;
    if (post.hasImage()) {
      postCommentImagePreview = ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image(
          image: AdvancedNetworkImage(post.getImage(), useDiskCache: true),
          height: postCommentImagePreviewSize,
          width: postCommentImagePreviewSize,
          fit: BoxFit.cover,
        ),
      );
    }

    Function navigateToReactorProfile = () {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

      openbookProvider.navigationService.navigateToUserProfile(
          user: postCommentReaction.reactor, context: context);
    };

    return ListTile(
      onTap: () {
        if (onPressed != null) onPressed();
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
        openbookProvider.navigationService.navigateToPostCommentsLinked(
            postComment: postCommentReaction.postComment, context: context);
      },
      leading: OBAvatar(
        onPressed: navigateToReactorProfile,
        size: OBAvatarSize.medium,
        avatarUrl: postCommentReaction.reactor.getProfileAvatar(),
      ),
      title: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          OBActionableSmartText(
            text: '@$postCommentReactorUsername reacted to your comment:',
          ),
          OBEmoji(
            postCommentReaction.emoji,
          ),
        ],
      ),
      trailing: postCommentImagePreview,
      subtitle: OBSecondaryText(notification.getRelativeCreated()),
    );
  }
}
