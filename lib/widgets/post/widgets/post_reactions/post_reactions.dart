import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/models/post_reactions_emoji_count.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions/widgets/reaction_emoji_count.dart';
import 'package:flutter/material.dart';

class OBPostReactions extends StatefulWidget {
  final Post post;
  final OnWantsToReact onWantsToReact;
  final OnWantsToUnReact onWantsToUnReact;

  OBPostReactions(this.post, {this.onWantsToReact, this.onWantsToUnReact});

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
      PostReactionsEmojiCount pressedEmojiCount) async {
    if (pressedEmojiCount.reacted) {
      await widget.onWantsToUnReact();
      // Remove reaction
      if (pressedEmojiCount.count > 1) {
        // There was more than one reaction. Minus one it.
        var newEmojiCount = pressedEmojiCount.copy(
            newReacted: false, newCount: pressedEmojiCount.count - 1);
        _replaceEmojiCount(pressedEmojiCount, newEmojiCount);
      } else {
        _removeEmojiCount(pressedEmojiCount);
      }
    } else {
      // React
      await widget.onWantsToReact(pressedEmojiCount.emoji);
      // Wants to react this
      var emojiCounts = _emojiCounts.map((emojiCount) {
        bool isPressedEmojiCount = emojiCount == pressedEmojiCount;
        bool reacted = isPressedEmojiCount;
        int count;
        if (emojiCount.reacted) {
          // If was reacted, decrement
          count = emojiCount.count - 1;
        } else {
          // If its the pressed one, add one, else do nothing
          count = isPressedEmojiCount ? emojiCount.count + 1 : emojiCount.count;
        }
        return emojiCount.copy(newReacted: reacted, newCount: count);
      }).toList();

      _setEmojiCounts(emojiCounts);
    }
  }

  void _replaceEmojiCount(emojiCount, newEmojiCount) {
    setState(() {
      int index = _emojiCounts.indexOf(emojiCount);
      _emojiCounts[index] = newEmojiCount;
    });
  }

  void _removeEmojiCount(emojiCount) {
    setState(() {
      _emojiCounts.remove(emojiCount);
    });
  }

  void _setEmojiCounts(emojiCounts) {
    setState(() {
      _emojiCounts = emojiCounts;
    });
  }
}

typedef Future<PostReaction> OnWantsToReact(Emoji emoji);

typedef Future<PostReaction> OnWantsToUnReact();
