import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/collapsible_smart_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OBPostCommentCommenterIdentifier extends StatelessWidget {
  final PostComment postComment;
  final VoidCallback onUsernamePressed;
  final Widget badge;

  static int postCommentMaxVisibleLength = 500;

  OBPostCommentCommenterIdentifier({
    Key key,
    @required this.onUsernamePressed,
    @required this.badge,
    @required this.postComment,
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

          String commenterUsername = postComment.commenter.username;
          String commenterName = postComment.commenter.getProfileName();

          return GestureDetector(
            onTap: onUsernamePressed,
            child: RichText(
              text: TextSpan(
                  style: TextStyle(color: secondaryTextColor, fontSize: 14),
                  children: [
                    TextSpan(
                        text: '$commenterName',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' · @$commenterUsername',
                        style:
                            TextStyle(fontSize: 12)),
                  ]),
            ),
          );
        });
  }
}
