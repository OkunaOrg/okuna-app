import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/pages/widgets/moderated_object_category/moderated_object_category.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/widgets/moderated_object/widgets/moderated_object_actions.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/widgets/moderated_object/widgets/moderated_object_preview.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post_comment/post_comment.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_header/post_header.dart';
import 'package:Openbook/widgets/theming/divider.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tile_group_title.dart';
import 'package:Openbook/widgets/tiles/community_tile.dart';
import 'package:Openbook/widgets/tiles/moderated_object_status_tile.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBModeratedObject extends StatelessWidget {
  final ModeratedObject moderatedObject;
  final Community community;

  const OBModeratedObject(
      {Key key, @required this.moderatedObject, this.community})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OBTileGroupTitle(
          title: 'Object',
        ),
        OBModeratedObjectPreview(
          moderatedObject: moderatedObject,
        ),
        OBModeratedObjectCategory(
          moderatedObject: moderatedObject,
          isEditable: false,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  OBTileGroupTitle(
                    title: 'Status',
                  ),
                  OBModeratedObjectStatusTile(
                    moderatedObject: moderatedObject,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  OBTileGroupTitle(
                    title: 'Reports count',
                  ),
                  ListTile(
                      title: OBText(moderatedObject.reportsCount.toString())),
                ],
              ),
            ),
          ],
        ),
        OBModeratedObjectActions(
          moderatedObject: moderatedObject,
          community: community,
        ),
        const SizedBox(
          height: 10,
        ),
        const OBDivider()
      ],
    );
  }
}
