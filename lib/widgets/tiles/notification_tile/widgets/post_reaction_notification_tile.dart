import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/models/notifications/post_reaction_notification.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/emoji_picker/widgets/emoji_groups/widgets/emoji_group/widgets/emoji.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBPostReactionNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final PostReactionNotification postReactionNotification;
  static final double postImagePreviewSize = 40;
  final VoidCallback onPressed;

  const OBPostReactionNotificationTile(
      {Key key,
      @required this.notification,
      @required this.postReactionNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostReaction postReaction = postReactionNotification.postReaction;
    Post post = postReaction.post;

    Widget postImagePreview;
    if (post.hasImage()) {
      postImagePreview = Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                image:
                    AdvancedNetworkImage(post.getImage(), useDiskCache: true),
                height: postImagePreviewSize,
                width: postImagePreviewSize,
                fit: BoxFit.cover,
              )));
    }
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    var utilsService = openbookProvider.utilsService;

    Function navigateToReactorProfile = () {
      openbookProvider.navigationService
          .navigateToUserProfile(user: postReaction.reactor, context: context);
    };

    return OBNotificationTileSkeleton(
      onTap: () {
        if (onPressed != null) onPressed();
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
        openbookProvider.navigationService
            .navigateToPost(post: postReaction.post, context: context);
      },
      leading: OBAvatar(
        onPressed: navigateToReactorProfile,
        size: OBAvatarSize.medium,
        avatarUrl: postReaction.reactor.getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        text: TextSpan(text: ' reacted to your post'),
        onUsernamePressed: navigateToReactorProfile,
        user: postReaction.reactor,
      ),
      subtitle: OBSecondaryText(utilsService.timeAgo(notification.created)),
      trailing: Row(
        children: <Widget>[
          OBEmoji(
            postReaction.emoji,
          ),
          postImagePreview ?? const SizedBox()
        ],
      ),
    );
  }
}
