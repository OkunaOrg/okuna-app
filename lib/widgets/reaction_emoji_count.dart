import 'package:Okuna/models/reactions_emoji_count.dart';
import 'package:Okuna/widgets/progress_indicator.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'buttons/button.dart';

class OBEmojiReactionButton extends StatelessWidget {
  final ReactionsEmojiCount postReactionsEmojiCount;
  final bool reacted;
  final ValueChanged<ReactionsEmojiCount> onPressed;
  final ValueChanged<ReactionsEmojiCount> onLongPressed;
  final OBEmojiReactionButtonSize size;

  const OBEmojiReactionButton(this.postReactionsEmojiCount,
      {this.onPressed,
      this.reacted,
      this.onLongPressed,
      this.size = OBEmojiReactionButtonSize.medium});

  @override
  Widget build(BuildContext context) {
    var emoji = postReactionsEmojiCount.emoji;

    List<Widget> buttonRowItems = [
      ExtendedImage.network(
        emoji.image,
        cache: true,
        height: size == OBEmojiReactionButtonSize.medium ? 18 : 14,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return OBProgressIndicator();
              break;
            default:
              return null;
              break;
          }
        },
      ),
      const SizedBox(
        width: 10.0,
      ),
      OBText(
        postReactionsEmojiCount.getPrettyCount(),
        style: TextStyle(
            fontWeight: reacted ? FontWeight.bold : FontWeight.normal,
            fontSize: size == OBEmojiReactionButtonSize.medium ? null : 12),
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
      type: OBButtonType.highlight,
    );
  }
}

enum OBEmojiReactionButtonSize { small, medium }
