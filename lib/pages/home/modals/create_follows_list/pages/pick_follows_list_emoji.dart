import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/widgets/emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPickFollowsListEmojiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.white,
        middle: Text('Pick emoji'),
      ),
      child: OBEmojiPicker(
        onEmojiPicked: (Emoji pickedEmoji) {
          Navigator.pop(context, pickedEmoji);
        },
      ),
    );
  }
}
