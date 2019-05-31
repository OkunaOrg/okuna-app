import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/widgets/moderated_object/widgets/moderated_object_actions.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post_comment/post_comment.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_header/post_header.dart';
import 'package:Openbook/widgets/theming/divider.dart';
import 'package:Openbook/widgets/theming/post_divider.dart';
import 'package:Openbook/widgets/tiles/community_tile.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';

class OBModeratedObject extends StatelessWidget {
  final ModeratedObject moderatedObject;
  final Community community;

  const OBModeratedObject(
      {Key key, @required this.moderatedObject, this.community})
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget,
        OBModeratedObjectActions(
          moderatedObject: moderatedObject,
          community: community,
        ),
        OBDivider()
      ],
    );
  }
}
