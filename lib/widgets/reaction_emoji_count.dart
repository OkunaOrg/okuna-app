import 'package:Openbook/models/reactions_emoji_count.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

import 'buttons/button.dart';

class OBEmojiReactionButton extends StatelessWidget {
  final ReactionsEmojiCount postReactionsEmojiCount;
  final bool reacted;
  final ValueChanged<ReactionsEmojiCount> onPressed;
  final ValueChanged<ReactionsEmojiCount> onLongPressed;

  const OBEmojiReactionButton(this.postReactionsEmojiCount,
      {this.onPressed, this.reacted, this.onLongPressed});

  @override
  Widget build(BuildContext context) {
    var emoji = postReactionsEmojiCount.emoji;

    List<Widget> buttonRowItems = [
      Image(
        height: 18.0,
        image: AdvancedNetworkImage(emoji.image, useDiskCache: true),
      ),
      const SizedBox(
        width: 10.0,
      ),
      OBText(
        postReactionsEmojiCount.getPrettyCount(),
        style: TextStyle(
            fontWeight: reacted ? FontWeight.bold : FontWeight.normal),
      )
    ];

    Widget buttonChild = Row(
        mainAxisAlignment: MainAxisAlignment.center, children: buttonRowItems);

    return OBButton(
      minWidth: 50,
      child: buttonChild,
      onLongPressed: () {
        if (onLongPressed != null) onLongPressed(postReactionsEmojiCount);
      },
      onPressed: () {
        if (onPressed != null) onPressed(postReactionsEmojiCount);
      },
      //isLoading: _clearPostCommentReactionInProgress,
      type: OBButtonType.highlight,
    );
  }
}
