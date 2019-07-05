import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/user_badge.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OBNotificationTileTitle extends StatelessWidget {
  final User user;
  final VoidCallback onUsernamePressed;
  final TextSpan text;

  static int postCommentMaxVisibleLength = 500;

  OBNotificationTileTitle(
      {Key key,
      @required this.onUsernamePressed,
      @required this.user,
      @required this.text})
      : super(key: key);

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
              themeValueParserService.parseColor(theme.primaryTextColor);
          Color secondaryTextColor =
              themeValueParserService.parseColor(theme.secondaryTextColor);

          String commenterUsername = user.username;
          String commenterName = user.getProfileName();

          GestureRecognizer usernameTapGestureRecognizer =
              TapGestureRecognizer()..onTap = onUsernamePressed;

          List<TextSpan> textItems = [
            TextSpan(
                text: '$commenterName',
                recognizer: usernameTapGestureRecognizer,
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text: ' @$commenterUsername',
                recognizer: usernameTapGestureRecognizer,
                style: TextStyle(color: secondaryTextColor)),
            text
          ];

          return Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(color: primaryTextColor, fontSize: 16),
                      children: textItems),
                ),
              ),
            ],
          );
        });
  }
}
