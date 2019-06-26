import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/post.dart';

import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/post_comment_reaction.dart';
import 'package:Openbook/models/reactions_emoji_count.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post_comment/widgets/post_comment_reactions/widgets/post_comment_react_button.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/reaction_emoji_count.dart';
import 'package:flutter/material.dart';

class OBPostCommentReactions extends StatefulWidget {
  final PostComment postComment;
  final Post post;

  OBPostCommentReactions({@required this.post, @required this.postComment});

  @override
  State<StatefulWidget> createState() {
    return OBPostCommentReactionsState();
  }
}

class OBPostCommentReactionsState extends State<OBPostCommentReactions> {
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
        stream: widget.postComment.updateSubject,
        initialData: widget.postComment,
        builder: (BuildContext context, AsyncSnapshot<PostComment> snapshot) {
          var postComment = snapshot.data;

          List<ReactionsEmojiCount> emojiCounts =
              postComment.reactionsEmojiCounts?.counts ?? [];

          return SizedBox(
            height: 35,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              physics: const ClampingScrollPhysics(),
              itemCount: emojiCounts.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return OBPostCommentReactButton(
                    postComment: widget.postComment,
                    post: widget.post,
                  );
                }

                ReactionsEmojiCount emojiCount = emojiCounts[index - 1];

                return OBEmojiReactionButton(
                  emojiCount,
                  reacted: widget.postComment.isReactionEmoji(emojiCount.emoji),
                  onPressed: _onEmojiReactionCountPressed,
                  onLongPressed: (pressedEmojiCount) {
                    _navigationService.navigateToPostCommentReactions(
                        post: widget.post,
                        postComment: widget.postComment,
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

  void _onEmojiReactionCountPressed(
      ReactionsEmojiCount pressedEmojiCount) async {
    bool isReactionEmoji =
        widget.postComment.isReactionEmoji(pressedEmojiCount.emoji);

    if (isReactionEmoji) {
      await _deleteReaction();
      widget.postComment.clearReaction();
    } else {
      // React
      PostCommentReaction newPostCommentReaction =
          await _reactToPostComment(pressedEmojiCount.emoji);
      widget.postComment.setReaction(newPostCommentReaction);
    }
  }

  Future<PostCommentReaction> _reactToPostComment(Emoji emoji) async {
    PostCommentReaction postCommentReaction;
    try {
      postCommentReaction = await _userService.reactToPostComment(
          post: widget.post, postComment: widget.postComment, emoji: emoji);
    } catch (error) {
      _onError(error);
    }

    return postCommentReaction;
  }

  Future<void> _deleteReaction() async {
    try {
      await _userService.deletePostCommentReaction(
          postCommentReaction: widget.postComment.reaction,
          post: widget.post,
          postComment: widget.postComment);
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
