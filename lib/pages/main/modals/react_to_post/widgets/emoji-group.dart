import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/emoji_group.dart';
import 'package:Openbook/pages/main/modals/react_to_post/widgets/emoji.dart';
import 'package:flutter/material.dart';

class OBEmojiGroup extends StatelessWidget {
  final EmojiGroup emojiGroup;

  OBEmojiGroup(this.emojiGroup);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(emojiGroup.keyword,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black38)),
              SizedBox(
                height: 10.0,
              ),
              Wrap(
                spacing: 20.0,
                children: this.emojiGroup.emojis.emojis.map((Emoji emoji) {
                  return OBEmoji(emoji);
                }).toList(),
              )
            ],
          )
        ],
      ),
    );
  }
}
