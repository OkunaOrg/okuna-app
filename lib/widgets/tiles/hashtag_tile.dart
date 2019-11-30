import 'package:Okuna/models/hashtag.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/avatars/hashtag_avatar.dart';
import 'package:Okuna/widgets/hashtag.dart';
import 'package:Okuna/widgets/posts_count.dart';
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

    int hashtagPosts = hashtag.postsCount;
    String hashtagPostsCount = '${hashtagPosts.toString()} posts';

    Widget tile = ListTile(
      onTap: () {
        if (onHashtagTilePressed != null) onHashtagTilePressed(hashtag);
      },
      leading: OBHashtagAvatar(
        hashtag: hashtag,
        size: OBAvatarSize.medium,
      ),
      title: Row(children: <Widget>[
        OBHashtag(
          hashtag: hashtag,
        ),
      ]),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: OBPostsCount(
              hashtag.postsCount,
              showZero: true,
            ),
          )
        ],
      )
    );
    return tile;
  }

}

