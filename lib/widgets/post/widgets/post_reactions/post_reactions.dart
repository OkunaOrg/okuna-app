import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/models/post_reactions_emoji_count.dart';
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

    return StreamBuilder(
        stream: widget.post.updateSubject,
        builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
          if (snapshot.data == null) return SizedBox();

          var post = snapshot.data;

          List<PostReactionsEmojiCount> emojiCounts =
              post.reactionsEmojiCounts.counts;

          if (emojiCounts.length == 0) return SizedBox();

          return Container(
            height: 51,
            child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: emojiCounts.map((emojiCount) {
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
                }).toList()),
          );
        });
  }

  void _onEmojiReactionCountPressed(PostReactionsEmojiCount pressedEmojiCount,
      List<PostReactionsEmojiCount> emojiCounts) async {
    bool reacted = widget.post.isReactionEmoji(pressedEmojiCount.emoji);

    if (reacted) {
      await _deleteReaction();
      widget.post.clearReaction();
    } else {
      // React
      PostReaction newPostReaction =
          await _reactToPost(pressedEmojiCount.emoji);
      widget.post.setReaction(newPostReaction);
    }
  }

  Future<PostReaction> _reactToPost(Emoji emoji) async {
    _setRequestInProgress(true);
    try {
      return await _userService.reactToPost(post: widget.post, emoji: emoji);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
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
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
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
