import 'package:Openbook/libs/pretty_count.dart';
import 'package:Openbook/models/circle.dart';
import 'package:Openbook/widgets/checkbox.dart';
import 'package:Openbook/widgets/circle_color_preview.dart';
import 'package:Openbook/widgets/circles_picker/widgets/circles_search_results.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCircleHorizontalListItem extends StatelessWidget {
  final bool isSelected;
  final bool isDisabled;
  final Circle circle;
  final OnCirclePressed onCirclePressed;

  OBCircleHorizontalListItem(this.circle,
      {@required this.onCirclePressed, this.isSelected, this.isDisabled});

  @override
  Widget build(BuildContext context) {
    int usersCount = circle.usersCount;
    String prettyUsersCount =
        getPrettyCount(isSelected ? usersCount + 1 : usersCount);

    Widget item = GestureDetector(
      onTap: () {
        if (this.onCirclePressed != null && !isDisabled) {
          this.onCirclePressed(circle);
        }
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 90, minWidth: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                OBCircleColorPreview(
                  circle,
                  size: OBCircleColorPreviewSize.large,
                ),
                Positioned(
                  child: OBCheckbox(
                    value: isSelected,
                  ),
                  bottom: -5,
                  right: -5,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            OBText(
              circle.name,
              maxLines: 1,
              style: TextStyle(
                fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
            OBText(
              '$prettyUsersCount People',
              maxLines: 1,
              size: OBTextSize.extraSmall,
              style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );

    if (isDisabled) {
      item = Opacity(
        opacity: 0.5,
        child: item,
      );
    }

    return item;
  }
}
