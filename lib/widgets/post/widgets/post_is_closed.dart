import 'package:Okuna/models/circle.dart';
import 'package:Okuna/models/post.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/cirles_wrap.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/actionable_smart_text.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../provider.dart';

class OBPostIsClosed extends StatelessWidget {
  final Post _post;

  OBPostIsClosed(this._post);

  @override
  Widget build(BuildContext context) {
    bool isClosed = _post.isClosed ?? false;
    LocalizationService localizationService = OpenbookProvider.of(context).localizationService;

    if (isClosed) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          children: <Widget>[
            const OBIcon(OBIcons.closePost, size: OBIconSize.small,),
            const SizedBox(width: 10,),
            OBText(localizationService.post__is_closed, size: OBTextSize.small)
          ],
        ),
      );
    }

    return const SizedBox();
  }
}
