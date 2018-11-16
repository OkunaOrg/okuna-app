import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/main/pages/post/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:Openbook/widgets/buttons/primary_button.dart';
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
              _buildCommentAction(context)
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

  Widget _buildCommentAction(context) {
    EdgeInsetsGeometry inputContentPadding =
        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color.fromARGB(10, 0, 0, 0)))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 20.0,
          ),
          OBLoggedInUserAvatar(
            size: OBUserAvatarSize.medium,
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color.fromARGB(10, 0, 0, 0),
              ),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(fontSize: 14.0, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Write something nice...',
                  contentPadding: inputContentPadding,
                  border: InputBorder.none,
                ),
                autofocus: autofocusCommentInput,
                autocorrect: true,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            child: OBPrimaryButton(
              isFullWidth: false,
              isSmall: true,
              onPressed: () {},
              child: Text('Post'),
            ),
          )
        ],
      ),
    );
  }
}
