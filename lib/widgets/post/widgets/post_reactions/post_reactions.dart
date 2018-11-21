import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/models/post_reactions_emoji_count.dart';
import 'package:Openbook/models/post_reactions_emoji_count_list.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions/widgets/reaction_emoji_count.dart';
import 'package:flutter/material.dart';

class OBPostReactions extends StatelessWidget {
  final Post post;
  final OnWantsToReact onWantsToReact;
  final OnWantsToUnReact onWantsToUnReact;

  OBPostReactions(this.post, {this.onWantsToReact, this.onWantsToUnReact});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 51,
        child: StreamBuilder(
            stream: post.reactionsEmojiCountsChangeSubject,
            initialData: post.reactionsEmojiCounts,
            builder: (BuildContext context,
                AsyncSnapshot<PostReactionsEmojiCountList> snapshot) {
              if (snapshot.data == null) return SizedBox();

              List<PostReactionsEmojiCount> emojiCounts =
                  snapshot.data.reactions;

              if (emojiCounts.length == 0) return SizedBox();

              List<Widget> listItems = [
                // Padding
                SizedBox(
                  width: 20.0,
                )
              ];

              listItems.addAll(emojiCounts.map((emojiCount) {
                return OBEmojiReactionCount(
                  emojiCount,
                  reacted: post.isReactionEmoji(emojiCount.emoji),
                  onPressed: (pressedEmojiCount) {
                    _onEmojiReactionCountPressed(
                        pressedEmojiCount, emojiCounts);
                  },
                );
              }));

              return ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: listItems);
            }));
  }

  void _onEmojiReactionCountPressed(PostReactionsEmojiCount pressedEmojiCount,
      List<PostReactionsEmojiCount> emojiCounts) async {
    var newEmojiCounts = emojiCounts.toList();

    bool reacted = post.isReactionEmoji(pressedEmojiCount.emoji);

    if (reacted) {
      await onWantsToUnReact();
      // Remove reaction
      if (pressedEmojiCount.count > 1) {
        // There was more than one reaction. Minus one it.
        var newEmojiCount = pressedEmojiCount.copy(
            newReacted: false, newCount: pressedEmojiCount.count - 1);
        int index = newEmojiCounts.indexOf(pressedEmojiCount);
        newEmojiCounts[index] = newEmojiCount;
      } else {
        newEmojiCounts.remove(pressedEmojiCount);
      }
      post.clearReaction();
    } else {
      // React
      PostReaction newPostReaction =
          await onWantsToReact(pressedEmojiCount.emoji);

      post.setReaction(newPostReaction);

      newEmojiCounts = newEmojiCounts.map((emojiCount) {
        bool isPressedEmojiCount = emojiCount == pressedEmojiCount;
        int count;
        if (post.isReactionEmoji(emojiCount.emoji)) {
          // If was reacted, decrement
          count = emojiCount.count - 1;
        } else {
          // If its the pressed one, add one, else do nothing
          count = isPressedEmojiCount ? emojiCount.count + 1 : emojiCount.count;
        }
        return emojiCount.copy(newCount: count);
      }).toList();
    }

    post.setReactionsEmojiCounts(
        PostReactionsEmojiCountList(reactions: newEmojiCounts));
  }
}

typedef Future<PostReaction> OnWantsToReact(Emoji emoji);

typedef Future<PostReaction> OnWantsToUnReact();
