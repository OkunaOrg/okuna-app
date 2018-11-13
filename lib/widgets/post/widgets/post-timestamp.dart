import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/avatars/user-avatar.dart';
import 'package:flutter/material.dart';

class OBPostTimestamp extends StatelessWidget {
  final Post _post;

  OBPostTimestamp(this._post);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            _post.getRelativeCreated().toUpperCase(),
            style: TextStyle(fontSize: 10.0),
          )
        ],
      ),
    );
  }
}
