import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/emoji_group.dart';
import 'package:Openbook/widgets/emoji_picker/widgets/emoji_groups/widgets/emoji_group/widgets/emoji.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBEmojiGroup extends StatelessWidget {
  final EmojiGroup emojiGroup;
  final OnEmojiPressed onEmojiPressed;

  OBEmojiGroup(this.emojiGroup, {this.onEmojiPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OBText(emojiGroup.keyword,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          const SizedBox(
            height: 10.0,
          ),
          Wrap(
            runSpacing: 20.0,
            spacing: 20.0,
            children: this.emojiGroup.emojis.emojis.map((Emoji emoji) {
              return OBEmoji(
                emoji,
                emojiGroup: emojiGroup,
                onEmojiPressed: onEmojiPressed,
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
