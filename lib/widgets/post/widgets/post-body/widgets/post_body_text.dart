import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:flutter/material.dart';

class OBPostBodyText extends StatelessWidget {
  final Post _post;

  OBPostBodyText(this._post);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: OBActionableSmartText(
          text: _post.getText(),
        ));
  }
}
