import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/widgets/follows_list_icon.dart';
import 'package:flutter/material.dart';

class OBEmojiField extends StatelessWidget {
  final Emoji emoji;
  final String subtitle;
  final String labelText;
  final String errorText;
  final OnEmojiFieldTapped onEmojiFieldTapped;

  const OBEmojiField(
      {Key key,
      this.emoji,
      this.subtitle,
      this.labelText,
      this.onEmojiFieldTapped,
      this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          MergeSemantics(
            child: ListTile(
                title: Text(labelText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                subtitle: errorText != null
                    ? Text(errorText, style: TextStyle(color: Colors.red))
                    : null,
                trailing: OBFollowsListEmoji(followsListEmojiUrl: emoji?.image),
                onTap: () {
                  if (onEmojiFieldTapped != null) onEmojiFieldTapped(emoji);
                }),
          ),
          Divider(),
        ],
      ),
    );
  }
}

typedef void OnEmojiFieldTapped(Emoji currentEmoji);
