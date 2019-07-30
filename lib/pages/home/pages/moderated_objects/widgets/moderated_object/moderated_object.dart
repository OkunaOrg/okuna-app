import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/pages/widgets/moderated_object_category/moderated_object_category.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/widgets/moderated_object/widgets/moderated_object_actions.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/widgets/moderated_object/widgets/moderated_object_preview.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/divider.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tile_group_title.dart';
import 'package:Openbook/widgets/tiles/moderated_object_status_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../provider.dart';

class OBModeratedObject extends StatelessWidget {
  final ModeratedObject moderatedObject;
  final Community community;

  const OBModeratedObject(
      {Key key, @required this.moderatedObject, this.community})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService _localizationService = OpenbookProvider.of(context).localizationService;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OBTileGroupTitle(
          title: _localizationService.moderation__moderated_object_title,
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
                    title: _localizationService.moderation__moderated_object_status,
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
                    title: _localizationService.moderation__moderated_object_reports_count,
                  ),
                  ListTile(
                      title: OBText(moderatedObject.reportsCount.toString())),
                ],
              ),
            ),
          ],
        ),
        OBTileGroupTitle(
          title: community != null ? _localizationService.moderation__moderated_object_verified_by_staff : _localizationService.moderation__moderated_object_verified,
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
                    moderatedObject.verified ? _localizationService.moderation__moderated_object_true_text : _localizationService.moderation__moderated_object_false_text,
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
