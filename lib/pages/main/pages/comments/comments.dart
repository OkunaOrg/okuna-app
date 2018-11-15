import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/main/pages/comments/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
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
              _buildCommentAction(context)
            ],
          ),
        ));
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

  Widget _buildCommentAction(context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color.fromARGB(10, 0, 0, 0)))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          OBLoggedInUserAvatar(
            size: OBUserAvatarSize.medium,
          ),
          SizedBox(
            width: 20.0,
          ),
          Flexible(
            child: TextField(
              autofocus: true,
              autocorrect: true,
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            child: Text('Go?'),
          )
        ],
      ),
    );
  }
}
