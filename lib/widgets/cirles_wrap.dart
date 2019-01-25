
import 'package:Openbook/models/circle.dart';
import 'package:Openbook/widgets/circle_color_preview.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCirclesWrap extends StatelessWidget{

  final List<Circle> circles;
  final Widget leading;

  const OBCirclesWrap({Key key, this.circles, this.leading}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> connectionItems = [];

    if(leading != null) connectionItems.add(leading);

    circles.forEach((Circle circle) {
      connectionItems.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          OBCircleColorPreview(
            circle,
            size: OBCircleColorPreviewSize.extraSmall,
          ),
          const SizedBox(
            width: 5,
          ),
          OBText(
            circle.name,
            size: OBTextSize.small,
          )
        ],
      ));
    });

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: connectionItems,
    );
  }
}