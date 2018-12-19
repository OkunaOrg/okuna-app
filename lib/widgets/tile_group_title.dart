import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBTileGroupTitle extends StatelessWidget {
  final String title;

  const OBTileGroupTitle({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: OBText(
        title,
        size: OBTextSize.large,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
