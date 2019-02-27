import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/emoji_group.dart';
import 'package:Openbook/widgets/emoji_picker/emoji_picker.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPickFollowsListEmojiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Pick emoji',
      ),
      child: OBPrimaryColorContainer(
        child: OBEmojiPicker(
          onEmojiPicked: (Emoji pickedEmoji, EmojiGroup emojiGroup) {
            Navigator.pop(context, pickedEmoji);
          },
        ),
      ),
    );
  }
}
