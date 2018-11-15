import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions.dart';
import 'package:Openbook/widgets/post/widgets/post_timestamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCommentsPage extends StatelessWidget {
  final Post post;

  OBCommentsPage(this.post);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: _buildPost(),
          ),
          _buildCommentAction()
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: Colors.white,
      middle: Text('Comments'),
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

  Widget _buildCommentAction() {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color.fromARGB(10, 0, 0, 0)))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('Hi')
        ],
      ),
    );
  }
}
