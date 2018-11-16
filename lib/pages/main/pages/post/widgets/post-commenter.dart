import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:Openbook/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

class OBPostCommenter extends StatelessWidget {
  final Post post;
  final bool autofocus;

  OBPostCommenter(this.post, {this.autofocus});

  @override
  Widget build(BuildContext context) {
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
                autofocus: autofocus,
                autocorrect: true,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0, left: 10.0),
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
