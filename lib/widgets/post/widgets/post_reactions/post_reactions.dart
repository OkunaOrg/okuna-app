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

    // Sort list by count
    _emojiCounts.sort((a, b) {
      return b.count.compareTo(a.count);
    });

    return Container(
        height: 51,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: _emojiCounts.map((emojiCount) {
              return OBEmojiReactionCount(
                emojiCount,
                onPressed: _onEmojiReactionCountPressed,
              );
            }).toList()));
  }

  void _onEmojiReactionCountPressed(
      PostReactionsEmojiCount postReactionsEmojiCount) {


    setState(() {
      _emojiCounts.remove(postReactionsEmojiCount);
      if(postReactionsEmojiCount.reacted){
        if (postReactionsEmojiCount.count > 1) {
          // There was more than one reaction. Minus one it.
          var newEmojiCount = postReactionsEmojiCount.copy(
              newReacted: false, newCount: postReactionsEmojiCount.count - 1);
          _emojiCounts.add(newEmojiCount);
        }
      }else{
        // Wants to react this
        var newEmojiCount = postReactionsEmojiCount.copy(
            newReacted: true, newCount: postReactionsEmojiCount.count + 1);
        _emojiCounts.add(newEmojiCount);
      }
    });
  }
}
