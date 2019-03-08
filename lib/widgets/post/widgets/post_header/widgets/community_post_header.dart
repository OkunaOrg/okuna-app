import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/bottom_sheets/post_actions.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/avatars/community_avatar.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCommunityPostHeader extends StatelessWidget {
  final Post _post;
  final OnPostDeleted onPostDeleted;

  const OBCommunityPostHeader(this._post,
      {Key key, @required this.onPostDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var navigationService = openbookProvider.navigationService;
    var bottomSheetService = openbookProvider.bottomSheetService;

    return StreamBuilder(
        stream: _post.community.updateSubject,
        builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
          Community community = snapshot.data;

          if (community == null) return const SizedBox();

          return ListTile(
            leading: OBCommunityAvatar(
              community: community,
              onPressed: () {
                navigationService.navigateToCommunity(
                    community: community, context: context);
              },
              size: OBAvatarSize.medium,
            ),
            trailing: IconButton(
                icon: const OBIcon(OBIcons.moreVertical),
                onPressed: () {
                  bottomSheetService.showPostActions(
                      context: context,
                      post: _post,
                      onPostDeleted: onPostDeleted,
                      onPostReported: null);
                }),
            title: GestureDetector(
              onTap: () {
                navigationService.navigateToCommunity(
                    community: community, context: context);
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OBText(
                      'c/' + community.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            subtitle: GestureDetector(
              onTap: () {
                navigationService.navigateToUserProfile(
                    user: _post.creator, context: context);
              },
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: OBSecondaryText(
                      '@' + _post.creator.username + ' ',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  OBSecondaryText(
                    _post.getRelativeCreated(),
                    style: TextStyle(fontSize: 12.0),
                  )
                ],
              ),
            ),
          );
        });
  }
}
