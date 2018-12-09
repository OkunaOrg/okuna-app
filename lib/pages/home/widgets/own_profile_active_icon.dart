import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:pigment/pigment.dart';

class OBOwnProfileActiveIcon extends StatelessWidget {
  final String avatarUrl;

  const OBOwnProfileActiveIcon({Key key, this.avatarUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500),
                border: Border.all(
                    color: Pigment.fromString(theme.primaryColorAccent))),
            padding: EdgeInsets.all(2.0),
            child: OBUserAvatar(
              avatarUrl: avatarUrl,
              size: OBUserAvatarSize.small,
            ),
          );
        });
  }
}
