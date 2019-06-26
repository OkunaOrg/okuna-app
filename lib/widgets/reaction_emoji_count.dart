import 'package:Openbook/models/reactions_emoji_count.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

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

    return GestureDetector(
      onTap: () {
        if (onPressed != null) onPressed(postReactionsEmojiCount);
      },
      onLongPress: () {
        if (onLongPressed != null) onLongPressed(postReactionsEmojiCount);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
          ],
        ),
      ),
    );
  }
}
