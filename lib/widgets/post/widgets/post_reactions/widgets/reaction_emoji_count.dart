import 'package:Openbook/models/post_reactions_emoji_count.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';

class OBEmojiReactionCount extends StatelessWidget {
  PostReactionsEmojiCount postReactionsEmojiCount;
  bool reacted;
  ValueChanged<PostReactionsEmojiCount> onPressed;
  ValueChanged<PostReactionsEmojiCount> onLongPressed;

  OBEmojiReactionCount(this.postReactionsEmojiCount,
      {this.onPressed, this.reacted, this.onLongPressed});

  @override
  Widget build(BuildContext context) {
    var emoji = postReactionsEmojiCount.emoji;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 100,
      ),
      child: GestureDetector(
        onTap: () {
          if (onPressed != null) onPressed(postReactionsEmojiCount);
        },
        onLongPress: () {
          if (onLongPressed != null) onLongPressed(postReactionsEmojiCount);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              height: 18.0,
              image: AdvancedNetworkImage(emoji.image, useDiskCache: true),
            ),
            SizedBox(
              width: 10.0,
            ),
            OBText(
              postReactionsEmojiCount.getPrettyCount(),
              style: TextStyle(
                  fontWeight: reacted ? FontWeight.bold : FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}
