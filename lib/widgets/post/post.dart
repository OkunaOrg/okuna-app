import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/bottom_sheets/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_circles.dart';
import 'package:Openbook/widgets/post/widgets/post_comments/post_comments.dart';
import 'package:Openbook/widgets/post/widgets/post_header/post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions/post_reactions.dart';
import 'package:Openbook/widgets/theming/post_divider.dart';
import 'package:flutter/material.dart';

class OBPost extends StatelessWidget {
  final Post post;
  final OnPostDeleted onPostDeleted;
  static const HEIGHT_POST_HEADER = 72.0;
  static const HEIGHT_POST_REACTIONS = 35.0;
  static const HEIGHT_POST_CIRCLES = 26.0;
  static const HEIGHT_POST_ACTIONS = 46.0;
  static const HEIGHT_POST_COMMENTS = 34.0;
  static const HEIGHT_POST_DIVIDER = 5.5;
  static const HEIGHT_SIZED_BOX = 16.0;
  static const TOTAL_PADDING_POST_TEXT = 40.0;
  static const SCHRODINGERS_HEIGHT = 2.0; // @todo: find out where its coming from
  static const TOTAL_FIXED_HEIGHT =  HEIGHT_POST_HEADER
      + HEIGHT_POST_REACTIONS + HEIGHT_POST_ACTIONS + HEIGHT_SIZED_BOX + HEIGHT_POST_DIVIDER + SCHRODINGERS_HEIGHT;

  const OBPost(this.post, {Key key, @required this.onPostDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: _getTotalPostHeight(context),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            OBPostHeader(
              post: post,
              onPostDeleted: onPostDeleted,
            ),
            OBPostBody(post),
            OBPostReactions(post),
            OBPostCircles(post),
            OBPostComments(
              post,
            ),
            OBPostActions(
              post,
            ),
            const SizedBox(
              height: 16,
            ),
            OBPostDivider(),
          ],
        ),
    );
  }

  double _getTotalPostHeight(BuildContext context) {
    double aspectRatio;
    double finalMediaScreenHeight = 0.0;
    double finalTextHeight = 0.0;
    double totalHeightPost = 0.0;
    double screenWidth = MediaQuery.of(context).size.width;
    if (post.hasImage()) {
      aspectRatio = post.getImageWidth() / post.getImageHeight();
      finalMediaScreenHeight = screenWidth/aspectRatio;
    }
    if (post.hasVideo()) {
      aspectRatio = post.getVideoWidth() / post.getVideoHeight();
      finalMediaScreenHeight = screenWidth/aspectRatio;
    }

    if (post.hasText()) {
      TextStyle style = TextStyle(fontSize: 16.0);
      TextSpan text =
      new TextSpan(text: post.text, style: style);

      TextPainter textPainter = new TextPainter(
        text: text,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
      );
      textPainter.layout(maxWidth: screenWidth - 40.0); //padding is 20 in OBPostBodyText
      finalTextHeight = textPainter.size.height + TOTAL_PADDING_POST_TEXT;
    }

    if (post.hasCircles() || (post.isEncircled != null && post.isEncircled)) {
      totalHeightPost = totalHeightPost + HEIGHT_POST_CIRCLES;
    }

    if (post.hasCommentsCount()) {
      totalHeightPost = totalHeightPost + HEIGHT_POST_COMMENTS;
    }

    totalHeightPost = totalHeightPost + finalMediaScreenHeight + finalTextHeight + TOTAL_FIXED_HEIGHT;

    return totalHeightPost;
  }
}
