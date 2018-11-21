import 'package:Openbook/models/post_reactions_emoji_count.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OBEmojiReactionCount extends StatelessWidget {
  PostReactionsEmojiCount postReactionsEmojiCount;
  bool reacted;
  OnPressed onPressed;

  OBEmojiReactionCount(this.postReactionsEmojiCount,
      {this.onPressed, this.reacted});

  @override
  Widget build(BuildContext context) {
    var emoji = postReactionsEmojiCount.emoji;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 100,
      ),
      child: FlatButton(
        onPressed: () {
          if (onPressed != null) onPressed(postReactionsEmojiCount);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CachedNetworkImage(
              height: 18.0,
              imageUrl: emoji.image,
              placeholder: SizedBox(),
              errorWidget: Container(
                child: Center(child: Text('?')),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              postReactionsEmojiCount.getPrettyCount(),
              style: TextStyle(
                  color: reacted ? Colors.black87 : Colors.black38,
                  fontWeight: reacted ? FontWeight.bold : FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}

typedef void OnPressed(PostReactionsEmojiCount postReactionsEmojiCount);
