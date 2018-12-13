import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/emoji_group.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/emoji_picker/widgets/emoji_groups/widgets/emoji_group/widgets/emoji.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBEmojiGroup extends StatelessWidget {
  final EmojiGroup emojiGroup;
  final OnEmojiPressed onEmojiPressed;

  OBEmojiGroup(this.emojiGroup, {this.onEmojiPressed});

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var localizationService = openbookProvider.localizationService;

    String translatableGroupKeyword =
        'EMOJI_GROUP.' + emojiGroup.keyword.toUpperCase();

    String groupName = localizationService.trans(translatableGroupKeyword);

    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OBText(groupName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          SizedBox(
            height: 10.0,
          ),
          Wrap(
            runSpacing: 20.0,
            spacing: 20.0,
            children: this.emojiGroup.emojis.emojis.map((Emoji emoji) {
              return OBEmoji(
                emoji,
                onEmojiPressed: onEmojiPressed,
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
