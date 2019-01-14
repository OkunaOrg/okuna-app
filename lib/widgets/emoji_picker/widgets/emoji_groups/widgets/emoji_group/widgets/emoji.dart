import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/emoji_group.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum OBEmojiSize { small, medium, large }

class OBEmoji extends StatelessWidget {
  final Emoji emoji;
  final EmojiGroup emojiGroup;
  final OnEmojiPressed onEmojiPressed;
  final OBEmojiSize size;

  OBEmoji(this.emoji,
      {this.onEmojiPressed, this.emojiGroup, this.size = OBEmojiSize.medium});

  @override
  Widget build(BuildContext context) {
    double dimensions = getIconDimensions(size);

    return IconButton(
        icon: CachedNetworkImage(
          height: dimensions,
          imageUrl: emoji.image,
          placeholder: SizedBox(),
          errorWidget: Text('?'),
        ),
        onPressed: onEmojiPressed != null
            ? () {
                onEmojiPressed(emoji, emojiGroup);
              }
            : null);
  }

  double getIconDimensions(OBEmojiSize size) {
    double iconSize;

    switch (size) {
      case OBEmojiSize.large:
        iconSize = 45;
        break;
      case OBEmojiSize.medium:
        iconSize = 25;
        break;
      case OBEmojiSize.small:
        iconSize = 15;
        break;
      default:
    }

    return iconSize;
  }
}

typedef void OnEmojiPressed(Emoji pressedEmoji, EmojiGroup emojiGroup);
