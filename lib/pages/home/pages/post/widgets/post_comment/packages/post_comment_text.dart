import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OBPostCommentText extends StatelessWidget {
  final PostComment postComment;
  final VoidCallback onUsernamePressed;

  const OBPostCommentText(this.postComment, {Key key, this.onUsernamePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;

    TapGestureRecognizer gestureRecognizer = TapGestureRecognizer();

    gestureRecognizer.onTap = () {
      if (onUsernamePressed != null) onUsernamePressed();
    };

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;
          return RichText(
              maxLines: null,
              text: TextSpan(children: [
                TextSpan(
                    text: postComment.getCommenterUsername(),
                    recognizer: gestureRecognizer,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeValueParserService.parseColor(theme.secondaryTextColor))),
                TextSpan(text: '  '),
                TextSpan(
                    text: postComment.text,
                    style: TextStyle(
                        color: themeValueParserService.parseColor(theme.primaryTextColor)))
              ]));
        });
  }
}
