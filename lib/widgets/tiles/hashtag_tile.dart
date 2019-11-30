import 'package:Okuna/models/hashtag.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:Okuna/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';


class OBHashtagTile extends StatelessWidget {
  final Hashtag hashtag;
  final ValueChanged<Hashtag> onHashtagTilePressed;
  final ValueChanged<Hashtag> onHashtagTileDeleted;

  const OBHashtagTile(this.hashtag,
      {Key key,
      this.onHashtagTilePressed,
      this.onHashtagTileDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    LocalizationService _localizationService = openbookProvider.localizationService;
    Widget tile = ListTile(
      onTap: () {
        if (onHashtagTilePressed != null) onHashtagTilePressed(hashtag);
      },
      leading: Container(
        child: Text('T'),
      ),
      title: Row(children: <Widget>[
        OBText(
          hashtag.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ]),
      subtitle: Row(
        children: [
          OBSecondaryText(hashtag.postsCount.toString()),
        ],
      ),
    );
    return tile;
  }

}

