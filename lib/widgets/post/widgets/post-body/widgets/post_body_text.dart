import 'package:Openbook/models/post.dart';
import 'package:flutter/material.dart';

class OBPostBodyText extends StatelessWidget {
  final Post _post;

  OBPostBodyText(this._post);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: RichText(text: TextSpan(children: [
        TextSpan(text: _post.getText(), style: TextStyle(color: Colors.black87, fontSize: 16.0))
      ])),
    );
  }
}
