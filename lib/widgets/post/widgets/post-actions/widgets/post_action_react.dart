import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBPostActionReact extends StatelessWidget {
  final Post _post;

  OBPostActionReact(this._post);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 50,
      minWidth: 50,
      child: FlatButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(500.0)),
          color: Color.fromARGB(5, 0, 0, 0),
          onPressed: () {},
          child: OBIcon(
            OBIcons.react,
            size: OBIconSize.medium,
          )),
    );
  }
}
