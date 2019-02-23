import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OBPostCommentText extends StatelessWidget {
  final PostComment postComment;
  final VoidCallback onUsernamePressed;
  final Widget badge;

  const OBPostCommentText(this.postComment,
      {Key key, this.onUsernamePressed, this.badge})
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
          var theme = snapshot.data;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: onUsernamePressed,
                child: Row(
                  children: <Widget>[
                    Text(
                      postComment.getCommenterName(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: themeValueParserService
                              .parseColor(theme.primaryTextColor),
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          badge == null
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: badge,
                                ),
                          Flexible(
                            child: Text(
                              ' @' + postComment.getCommenterUsername(),
                              style: TextStyle(
                                  color: themeValueParserService
                                      .parseColor(theme.secondaryTextColor),
                                  fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  RichText(
                      maxLines: null,
                      text: TextSpan(children: [
                        TextSpan(
                            text: postComment.text,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: themeValueParserService
                                    .parseColor(theme.primaryTextColor)))
                      ]))
                ],
              )
            ],
          );
        });
  }
}
