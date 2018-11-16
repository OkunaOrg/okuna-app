import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/main/pages/post/widgets/page_scaffold.dart';
import 'package:Openbook/pages/main/pages/post/widgets/post-commenter.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions.dart';
import 'package:Openbook/widgets/post/widgets/post_timestamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostPage extends StatelessWidget {
  final Post post;
  final bool autofocusCommentInput;

  OBPostPage(this.post, {this.autofocusCommentInput: false});

  @override
  Widget build(BuildContext context) {
    return OBCupertinoPageScaffold(
        //resizeToAvoidBottomInset: true,
        navigationBar: _buildNavigationBar(),
        child: Container(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: _buildPost(),
                ),
              ),
              OBPostCommenter(post, autofocus:autofocusCommentInput)
            ],
          ),
        ));
  }

  Widget _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: Colors.white,
      middle: Text('Post'),
    );
  }

  Widget _buildPost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OBPostHeader(post),
        OBPostBody(post),
        OBPostReactions(post),
        OBPostActions(post),
        OBPostTimestamp(post),
      ],
    );
  }
}
