import 'package:Openbook/models/emoji_group.dart';
import 'package:Openbook/pages/main/modals/react_to_post/widgets/emoji_groups/widgets/emoji_group/emoji_group.dart';
import 'package:Openbook/pages/main/modals/react_to_post/widgets/emoji_groups/widgets/emoji_group/widgets/emoji.dart';
import 'package:flutter/material.dart';

class OBEmojiGroups extends StatelessWidget {
  final OnEmojiPressed onEmojiPressed;
  final List<EmojiGroup> emojiGroups;

  OBEmojiGroups(this.emojiGroups, {this.onEmojiPressed});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: emojiGroups.length,
        itemBuilder: (BuildContext context, index) {
          EmojiGroup emojiGroup = emojiGroups[index];
          return OBEmojiGroup(
            emojiGroup,
            onEmojiPressed: onEmojiPressed,
          );
        });
  }
}
