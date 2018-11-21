import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/models/post_reactions_emoji_count.dart';
import 'package:Openbook/models/post_reactions_emoji_count_list.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions/widgets/reaction_emoji_count.dart';
import 'package:flutter/material.dart';

class OBPostReactions extends StatefulWidget {
  final Post post;

  OBPostReactions(this.post);

  @override
  State<StatefulWidget> createState() {
    return OBPostReactionsState();
  }
}

class OBPostReactionsState extends State<OBPostReactions> {
  UserService _userService;
  ToastService _toastService;

  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return Container(
        height: 51,
        child: StreamBuilder(
            stream: widget.post.reactionsEmojiCountsChangeSubject,
            initialData: widget.post.reactionsEmojiCounts,
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
                  reacted: widget.post.isReactionEmoji(emojiCount.emoji),
                  onPressed: _requestInProgress
                      ? null
                      : (pressedEmojiCount) {
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

    bool reacted = widget.post.isReactionEmoji(pressedEmojiCount.emoji);

    if (reacted) {
      await _deleteReaction();
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
      widget.post.clearReaction();
    } else {
      PostReaction previousReaction = widget.post.reaction;
      // React
      PostReaction newPostReaction =
          await _reactToPost(pressedEmojiCount.emoji);

      widget.post.setReaction(newPostReaction);

      newEmojiCounts = newEmojiCounts.map((emojiCount) {
        int count = emojiCount.count;
        if (previousReaction != null &&
            previousReaction.getEmojiId() == emojiCount.getEmojiId()) {
          // Decrement
          count = count - 1;
        } else if (newPostReaction.getEmojiId() == emojiCount.getEmojiId()) {
          // Increment
          count = count + 1;
        }
        return emojiCount.copy(newCount: count);
      }).toList();
    }

    widget.post.setReactionsEmojiCounts(
        PostReactionsEmojiCountList(reactions: newEmojiCounts));
  }

  Future<PostReaction> _reactToPost(Emoji emoji) async {
    _setRequestInProgress(true);
    try {
      return await _userService.reactToPost(post: widget.post, emoji: emoji);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection');
    } catch (e) {
      _toastService.error(message: 'Unknown error.');
      rethrow;
    } finally {
      _setRequestInProgress(false);
    }
  }

  Future<void> _deleteReaction() async {
    _setRequestInProgress(true);
    try {
      await _userService.deletePostReaction(
          postReaction: widget.post.reaction, post: widget.post);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection');
    } catch (e) {
      _toastService.error(message: 'Unknown error.');
      rethrow;
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
