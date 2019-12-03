import 'package:Okuna/models/hashtag.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/hashtag.dart';
import 'package:Okuna/widgets/nav_bars/image_nav_bar.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/posts_count.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBHashtagNavBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final Hashtag hashtag;

  OBHashtagNavBar(this.hashtag);

  @override
  Widget build(BuildContext context) {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    final Color hashtagTextColor =
        openbookProvider.utilsService.parseHexColor(hashtag.textColor);

    return StreamBuilder(
        stream: hashtag.updateSubject,
        initialData: hashtag,
        builder: (BuildContext context, AsyncSnapshot<Hashtag> snapshot) {
          var hashtag = snapshot.data;

          return hashtag.image != null
              ? OBImageNavBar(
                  imageSrc: hashtag.image,
                  middle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      OBHashtag(
                        hashtag: hashtag,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Text('·', style: TextStyle(color: Colors.white),),
                      ),
                      OBPostsCount(hashtag.postsCount, color: Colors.white, showZero: true,)
                    ],
                  ),
                  textColor: hashtagTextColor)
              : OBThemedNavigationBar(
                  middle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      OBHashtag(
                        hashtag: hashtag,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: OBText('·'),
                      ),
                      OBPostsCount(hashtag.postsCount)
                    ],
                  )
                );
        });
  }

  bool get fullObstruction {
    return true;
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(44);
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}
