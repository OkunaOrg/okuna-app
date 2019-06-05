import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_circles.dart';
import 'package:Openbook/widgets/post/widgets/post_header/post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions/post_reactions.dart';
import 'package:Openbook/widgets/theming/post_divider.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';


class OBPostPreview extends StatelessWidget {
  final Post post;
  final Function(Post) onPostDeleted;
  final VoidCallback focusCommentInput;
  GlobalKey _keyPostBody = GlobalKey();
  
  OBPostPreview({this.post, this.onPostDeleted, this.focusCommentInput});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OBPostHeader(
          post: this.post,
          onPostDeleted: this.onPostDeleted,
        ),
        Container(
          key: _keyPostBody,
          child: OBPostBody(this.post),
        ),
        OBPostReactions(this.post),
        OBPostCircles(this.post),
        OBPostActions(
          this.post,
          onWantsToCommentPost: this.focusCommentInput,
        ),
        const SizedBox(
          height: 16,
        ),
        OBPostDivider()
      ],
    );
  }
}