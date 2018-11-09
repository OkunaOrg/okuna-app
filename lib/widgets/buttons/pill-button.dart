import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBPillButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final String hexColor;

  final VoidCallback onPressed;

  const OBPillButton(
      {@required this.text,
      @required this.icon,
      @required this.onPressed,
      this.hexColor});

  @override
  Widget build(BuildContext context) {
    var button = FlatButton(
        textColor: Colors.white,
        child: Row(
          children: <Widget>[
            icon,
            SizedBox(
              width: 10.0,
            ),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        color: Pigment.fromString(hexColor),
        onPressed: onPressed,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)));
    return button;
  }
}
