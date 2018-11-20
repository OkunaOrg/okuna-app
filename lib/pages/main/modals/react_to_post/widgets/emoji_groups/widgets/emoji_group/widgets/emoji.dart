import 'package:Openbook/models/emoji.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OBEmoji extends StatelessWidget {
  final Emoji emoji;
  final OnEmojiPressed onEmojiPressed;

  OBEmoji(this.emoji, {this.onEmojiPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: CachedNetworkImage(
        imageUrl: emoji.image,
        placeholder: Image(image: AssetImage('assets/images/loading.gif')),
        errorWidget: Container(
          child: Center(child: Text('?')),
        ),
      ),
      onPressed: this.onEmojiPressed == null
          ? null
          : () {
              onEmojiPressed(emoji);
            },
    );
  }
}

typedef void OnEmojiPressed(Emoji pressedEmoji);
