import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBModeratedObjectActions extends StatelessWidget {
  final Community community;
  final ModeratedObject moderatedObject;

  OBModeratedObjectActions(
      {@required this.community, @required this.moderatedObject});

  @override
  Widget build(BuildContext context) {
    LocalizationService _localizationService = OpenbookProvider.of(context).localizationService;
    List<Widget> moderatedObjectActions = [
      Expanded(
          child: OBButton(
              type: OBButtonType.highlight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const OBIcon(
                    OBIcons.reviewModeratedObject,
                    customSize: 20.0,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  OBText(_localizationService.trans('moderation__actions_review')),
                ],
              ),
              onPressed: () {
                OpenbookProviderState openbookProvider =
                    OpenbookProvider.of(context);
                if (community != null) {
                  openbookProvider.navigationService
                      .navigateToModeratedObjectCommunityReview(
                          moderatedObject: moderatedObject,
                          community: community,
                          context: context);
                } else {
                  openbookProvider.navigationService
                      .navigateToModeratedObjectGlobalReview(
                          moderatedObject: moderatedObject, context: context);
                }
              })),
    ];

    return Padding(
        padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: moderatedObjectActions,
            )
          ],
        ));
  }
}
