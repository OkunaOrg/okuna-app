import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/post/widgets/post_comment/post_comment.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:Openbook/widgets/cirles_wrap.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostCircles extends StatelessWidget {
  final Post _post;

  OBPostCircles(this._post);

  @override
  Widget build(BuildContext context) {
    if (!_post.hasCircles()) return SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: OBCirclesWrap(
          leading: OBText(
            'Shared with',
            size: OBTextSize.small,
          ),
          circles: _post.getPostCircles()),
    );
  }
}
