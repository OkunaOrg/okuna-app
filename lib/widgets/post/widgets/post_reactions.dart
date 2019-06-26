import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/models/reactions_emoji_count.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/reaction_emoji_count.dart';
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
  NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _navigationService = openbookProvider.navigationService;

    return StreamBuilder(
        stream: widget.post.updateSubject,
        initialData: widget.post,
        builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
          var post = snapshot.data;

          List<ReactionsEmojiCount> emojiCounts =
              post.reactionsEmojiCounts?.counts;

          if (emojiCounts == null || emojiCounts.length == 0)
            return const SizedBox(
              height: 35,
            );

          return SizedBox(
            height: 35,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              physics: const ClampingScrollPhysics(),
              itemCount: emojiCounts.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                ReactionsEmojiCount emojiCount = emojiCounts[index];

                return OBEmojiReactionButton(
                  emojiCount,
                  reacted: widget.post.isReactionEmoji(emojiCount.emoji),
                  onPressed: (pressedEmojiCount) {
                    _navigationService.navigateToPostReactions(
                        post: widget.post,
                        reactionsEmojiCounts: emojiCounts,
                        context: context,
                        reactionEmoji: pressedEmojiCount.emoji);
                  },
                );
              },
            ),
          );
        });
  }

  void _onEmojiReactionCountPressed(ReactionsEmojiCount pressedEmojiCount,
      List<ReactionsEmojiCount> emojiCounts) async {
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
    PostReaction postReaction;
    try {
      postReaction =
          await _userService.reactToPost(post: widget.post, emoji: emoji);
    } catch (error) {
      _onError(error);
    }

    return postReaction;
  }

  Future<void> _deleteReaction() async {
    try {
      await _userService.deletePostReaction(
          postReaction: widget.post.reaction, post: widget.post);
    } catch (error) {
      _onError(error);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }
}
