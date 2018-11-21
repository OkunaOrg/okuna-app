import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reactions_emoji_count.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions/widgets/reaction_emoji_count.dart';
import 'package:flutter/material.dart';

class OBPostReactions extends StatefulWidget {
  final Post post;

  OBPostReactions(this.post);

  @override
  OBPostReactionsState createState() {
    return OBPostReactionsState();
  }
}

class OBPostReactionsState extends State<OBPostReactions> {
  List<PostReactionsEmojiCount> _emojiCounts;

  @override
  void initState() {
    super.initState();
    _emojiCounts = widget.post.getEmojiCounts();
  }

  @override
  Widget build(BuildContext context) {
    if (_emojiCounts == null || _emojiCounts.length == 0) {
      return SizedBox();
    }

    List<Widget> listItems = [
      // Padding
      SizedBox(
        width: 20.0,
      )
    ];

    listItems.addAll(_emojiCounts.map((emojiCount) {
      return OBEmojiReactionCount(
        emojiCount,
        onPressed: _onEmojiReactionCountPressed,
      );
    }));

    return Container(
        height: 51,
        child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: listItems));
  }

  void _onEmojiReactionCountPressed(
      PostReactionsEmojiCount postReactionsEmojiCount) {
    setState(() {
      if (postReactionsEmojiCount.reacted) {
        // Remove reaction
        if (postReactionsEmojiCount.count > 1) {
          // There was more than one reaction. Minus one it.
          var newEmojiCount = postReactionsEmojiCount.copy(
              newReacted: false, newCount: postReactionsEmojiCount.count - 1);
          int index = _emojiCounts.indexOf(postReactionsEmojiCount);
          _emojiCounts[index] = newEmojiCount;
        } else {
          _emojiCounts.remove(postReactionsEmojiCount);
        }
      } else {
        // React
        // Wants to react this
        _emojiCounts = _emojiCounts.map((emojiCount) {
          bool isPressedEmojiCount = emojiCount == postReactionsEmojiCount;
          bool reacted = isPressedEmojiCount;
          int count;
          if (emojiCount.reacted) {
            // If was reacted, decrement
            count = emojiCount.count - 1;
          } else {
            // If its the pressed one, add one, else do nothing
            count =
                isPressedEmojiCount ? emojiCount.count + 1 : emojiCount.count;
          }
          return emojiCount.copy(newReacted: reacted, newCount: count);
        }).toList();
      }
    });
  }
}
