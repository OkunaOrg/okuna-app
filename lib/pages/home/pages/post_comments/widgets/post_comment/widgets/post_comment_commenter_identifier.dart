import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/user_badge.dart';
import 'package:flutter/material.dart';

class OBPostCommentCommenterIdentifier extends StatelessWidget {
  final PostComment postComment;
  final Post post;
  final VoidCallback onUsernamePressed;

  static int postCommentMaxVisibleLength = 500;

  OBPostCommentCommenterIdentifier({
    Key key,
    @required this.onUsernamePressed,
    @required this.postComment,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;
    var utilsService = openbookProvider.utilsService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          OBTheme theme = snapshot.data;

          Color secondaryTextColor =
              themeValueParserService.parseColor(theme.secondaryTextColor);

          String commenterUsername = postComment.commenter.username;
          String commenterName = postComment.commenter.getProfileName();
          String created = utilsService.timeAgo(postComment.created);

          return Opacity(
            opacity: 0.8,
            child: GestureDetector(
              onTap: onUsernamePressed,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          style: TextStyle(
                              color: secondaryTextColor, fontSize: 14),
                          children: [
                            TextSpan(
                                text: '$commenterName',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: ' @$commenterUsername',
                                style: TextStyle(fontSize: 12)),
                          ]),
                    ),
                  ),
                  _buildBadge(),
                  OBSecondaryText(
                    ' · $created',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildBadge() {
    User postCommenter = postComment.commenter;

    if (postCommenter.hasProfileBadges()) return _buildProfileBadge();

    Post post = this.post;

    if (post.hasCommunity()) {
      Community postCommunity = post.community;

      bool isCommunityAdministrator =
          postCommenter.isAdministratorOfCommunity(postCommunity);

      if (isCommunityAdministrator) {
        return _buildCommunityAdministratorBadge();
      }

      bool isCommunityModerator =
          postCommenter.isModeratorOfCommunity(postCommunity);

      if (isCommunityModerator) {
        return _buildCommunityModeratorBadge();
      }
    }

    return const SizedBox();
  }

  Widget _buildCommunityAdministratorBadge() {
    return const Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: OBIcon(
        OBIcons.communityAdministrators,
        size: OBIconSize.small,
        themeColor: OBIconThemeColor.primaryAccent,
      ),
    );
  }

  Widget _buildCommunityModeratorBadge() {
    return const OBIcon(
      OBIcons.communityModerators,
      size: OBIconSize.small,
      themeColor: OBIconThemeColor.primaryAccent,
    );
  }

  Widget _buildProfileBadge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: OBUserBadge(
          badge: postComment.commenter.getDisplayedProfileBadge(),
          size: OBUserBadgeSize.small),
    );
  }
}
