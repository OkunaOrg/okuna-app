import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/cirles_wrap.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostCircles extends StatelessWidget {
  final Post _post;

  OBPostCircles(this._post);

  @override
  Widget build(BuildContext context) {
    if (_post.hasCircles()) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: OBCirclesWrap(
            textSize: OBTextSize.small,
            circlePreviewSize: OBCircleColorPreviewSize.extraSmall,
            leading: const OBText(
              'You shared with',
              size: OBTextSize.small,
            ),
            circles: _post.getPostCircles()),
      );
    } else if (_post.isEncircled != null && _post.isEncircled) {
      String postCreatorUsername = _post.creator.username;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          children: <Widget>[
            OBText(
              'Shared privately on',
              size: OBTextSize.small,
            ),
            SizedBox(
              width: 10,
            ),
            OBCircleColorPreview(
              Circle(color: '#ffffff'),
              size: OBCircleColorPreviewSize.extraSmall,
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: OBActionableSmartText(
                text: '@$postCreatorUsername \'s circles',
                size: OBTextSize.small,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox();
  }
}
