import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/pages/widgets/moderated_object_category/moderated_object_category.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/widgets/moderated_object/widgets/moderated_object_actions.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/widgets/moderated_object/widgets/moderated_object_preview.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/divider.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tile_group_title.dart';
import 'package:Openbook/widgets/tiles/moderated_object_status_tile.dart';
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
        const SizedBox(
          height: 10,
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
        OBTileGroupTitle(
          title: community != null ? 'Verified by Openbook staff' : 'Verified',
        ),
        StreamBuilder(
          stream: moderatedObject.updateSubject,
          initialData: moderatedObject,
          builder:
              (BuildContext context, AsyncSnapshot<ModeratedObject> snapshot) {
            return Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  OBIcon(
                    moderatedObject.verified
                        ? OBIcons.verify
                        : OBIcons.unverify,
                    size: OBIconSize.small,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OBText(
                    moderatedObject.verified ? 'True' : 'False',
                  )
                ],
              ),
            );
          },
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
