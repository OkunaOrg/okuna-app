import 'package:Openbook/models/community.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCommunityFavorite extends StatelessWidget {
  final Community community;

  const OBCommunityFavorite(this.community);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      initialData: community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        Community community = snapshot.data;
        if (community.isFavorite == null || !community.isFavorite)
          return const SizedBox();

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OBIcon(
              OBIcons.favoriteCommunity,
              themeColor: OBIconThemeColor.primaryAccent,
              size: OBIconSize.small,
            ),
            const SizedBox(
              width: 10,
            ),
            OBText(
              'In favorites',
              style: TextStyle(fontSize: 16),
            )
          ],
        );
      },
    );
  }
}
