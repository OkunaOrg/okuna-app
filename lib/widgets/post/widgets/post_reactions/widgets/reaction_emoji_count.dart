import 'package:Openbook/models/post_reactions_emoji_count.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OBEmojiReactionCount extends StatelessWidget {
  PostReactionsEmojiCount postReactionsEmojiCount;
  OnPressed onPressed;

  OBEmojiReactionCount(this.postReactionsEmojiCount, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool reacted = postReactionsEmojiCount.reacted;
    var emoji = postReactionsEmojiCount.emoji;

    return FlatButton(
      onPressed: () {
        onPressed(postReactionsEmojiCount);
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
            postReactionsEmojiCount.count.toString(),
            style: TextStyle(
                color: reacted ? Colors.black87 : Colors.black38,
                fontWeight: reacted ? FontWeight.bold : FontWeight.normal),
          )
        ],
      ),
    );
  }
}

typedef void OnPressed(PostReactionsEmojiCount postReactionsEmojiCount);
