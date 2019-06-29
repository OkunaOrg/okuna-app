import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/user_badge.dart';
import 'package:flutter/material.dart';

class OBCommunityPostCreatorIdentifier extends StatelessWidget {
  final Post post;
  final VoidCallback onUsernamePressed;

  static int postCommentMaxVisibleLength = 500;

  OBCommunityPostCreatorIdentifier({
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

          Color secondaryTextColor =
              themeValueParserService.parseColor(theme.secondaryTextColor);

          String commenterUsername = post.creator.username;
          String commenterName = post.creator.getProfileName();
          String created = post.getRelativeCreated();

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
                              color: secondaryTextColor, fontSize: 12),
                          children: [
                            TextSpan(
                                text: '$commenterName',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: ' @$commenterUsername',
                                style: TextStyle(
                                    fontSize: 12)),
                            TextSpan(
                                text: ' · $created',
                                style: TextStyle(fontSize: 12)),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
