import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBPostActionComment extends StatelessWidget {
  final Post _post;

  OBPostActionComment(this._post);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (){},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          OBIcon(OBIcons.comment, size: OBIconSize.medium,),
          SizedBox(width: 10.0,),
          Text('Comment')
        ],
      ),
    );
  }
}
