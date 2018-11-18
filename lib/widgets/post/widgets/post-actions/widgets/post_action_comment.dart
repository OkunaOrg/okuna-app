import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/main/pages/post/post.dart';
import 'package:Openbook/widgets/buttons/pill_button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostActionComment extends StatelessWidget {
  final Post _post;
  final VoidCallback onWantsToComment;

  OBPostActionComment(this._post, {this.onWantsToComment});

  @override
  Widget build(BuildContext context) {
    VoidCallback finalOnWantsToComment;

    if (this.onWantsToComment != null) {
      finalOnWantsToComment = this.onWantsToComment;
    } else {
      finalOnWantsToComment = () {
        _defaultOnWantsToComment(context);
      };
    }

    return OBPillButton(
      text: 'Comment',
      icon: OBIcon(
        OBIcons.comment,
        size: OBIconSize.medium,
      ),
      color: Color.fromARGB(5, 0, 0, 0),
      textColor: Colors.black87,
      onPressed: finalOnWantsToComment,
    );
  }

  void _defaultOnWantsToComment(BuildContext context) {
    Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => Material(
              child: OBPostPage(
                _post,
                autofocusCommentInput: true,
              ),
            )));
  }
}
