import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/theme.dart';
import 'package:Okuna/models/user.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/user_badge.dart';
import 'package:flutter/material.dart';

class OBPostCreatorIdentifier extends StatelessWidget {
  final Post post;
  final VoidCallback onUsernamePressed;

  static int postCommentMaxVisibleLength = 500;

  OBPostCreatorIdentifier({
    Key key,
    @required this.onUsernamePressed,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          OBTheme theme = snapshot.data;

          Color primaryTextColor =
              themeValueParserService.parseColor(theme.secondaryTextColor);

          String name = post.creator.getProfileName();

          return GestureDetector(
            onTap: onUsernamePressed,
            child: Row(
              children: <Widget>[
                Flexible(
                  child: SizedBox(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          style: TextStyle(
                               fontSize: 14),
                          children: [
                            TextSpan(
                                text: '$name',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ]),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                _buildBadge()
              ],
            ),
          );
        });
  }

  Widget _buildBadge() {
    User postCommenter = post.creator;

    if (postCommenter.hasProfileBadges()) return _buildProfileBadge();

    return const SizedBox();
  }

  Widget _buildProfileBadge() {
    return OBUserBadge(
        badge: post.creator.getDisplayedProfileBadge(),
        size: OBUserBadgeSize.small);
  }
}
