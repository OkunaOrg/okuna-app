import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post_comment/post_comment.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_header/post_header.dart';
import 'package:Openbook/widgets/tiles/community_tile.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
import 'package:flutter/material.dart';

class OBModeratedObjectPreview extends StatelessWidget {
  final ModeratedObject moderatedObject;

  const OBModeratedObjectPreview({Key key, @required this.moderatedObject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget;

    switch (moderatedObject.type) {
      case ModeratedObjectType.post:
        widget = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OBPostHeader(
              post: moderatedObject.contentObject,
              hasActions: false,
            ),
            OBPostBody(moderatedObject.contentObject),
          ],
        );
        break;
      case ModeratedObjectType.community:
        widget = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OBCommunityTile(moderatedObject.contentObject),
          ],
        );
        break;
      case ModeratedObjectType.postComment:
        PostComment postComment = moderatedObject.contentObject;
        widget = Column(
          children: <Widget>[
            OBPostComment(
              post: postComment.post,
              postComment: moderatedObject.contentObject,
            ),
          ],
        );
        break;
      case ModeratedObjectType.user:
        widget = Column(
          children: <Widget>[
            OBUserTile(moderatedObject.contentObject),
          ],
        );
        break;
      default:
        widget = const SizedBox();
    }
    return widget;
  }
}
