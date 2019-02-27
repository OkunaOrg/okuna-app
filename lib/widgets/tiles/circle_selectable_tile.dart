import 'package:Openbook/libs/pretty_count.dart';
import 'package:Openbook/models/circle.dart';
import 'package:Openbook/widgets/circle_color_preview.dart';
import 'package:Openbook/widgets/fields/checkbox_field.dart';
import 'package:flutter/material.dart';

class OBCircleSelectableTile extends StatelessWidget {
  final Circle circle;
  final OnCirclePressed onCirclePressed;
  final bool isSelected;
  final bool isDisabled;

  const OBCircleSelectableTile(this.circle,
      {Key key, this.onCirclePressed, this.isSelected, this.isDisabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int usersCount = circle.usersCount;

    return OBCheckboxField(
      isDisabled: isDisabled,
      value: isSelected,
      title: circle.name,
      subtitle:
          usersCount != null ? getPrettyCount(usersCount) + ' people' : null,
      onTap: () {
        onCirclePressed(circle);
      },
      leading: SizedBox(
        height: 40,
        width: 40,
        child: Center(
          child: OBCircleColorPreview(
            circle,
            size: OBCircleColorPreviewSize.small,
          ),
        ),
      ),
    );
  }
}

typedef void OnCirclePressed(Circle pressedCircle);
