import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/emoji_group.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OBEmoji extends StatelessWidget {
  final Emoji emoji;
  final EmojiGroup emojiGroup;
  final OnEmojiPressed onEmojiPressed;

  OBEmoji(this.emoji,
      {@required this.onEmojiPressed, @required this.emojiGroup});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: CachedNetworkImage(
          imageUrl: emoji.image,
          placeholder: SizedBox(),
          errorWidget: Text('?'),
        ),
        onPressed: () {
          onEmojiPressed(emoji, emojiGroup);
        });
  }
}

typedef void OnEmojiPressed(Emoji pressedEmoji, EmojiGroup emojiGroup);
