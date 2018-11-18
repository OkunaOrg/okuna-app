import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/buttons/pill_button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBPostActionReact extends StatelessWidget {
  final Post _post;

  OBPostActionReact(this._post);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OBIcon(OBIcons.like),
            SizedBox(
              width: 10.0,
            ),
            Text('Like'),
          ],
        ),
        color: Color.fromARGB(5, 0, 0, 0),
        onPressed: () {},
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)));
  }
}
