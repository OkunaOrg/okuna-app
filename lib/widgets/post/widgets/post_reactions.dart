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
import 'package:async/async.dart';
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

  CancelableOperation _requestOperation;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  void dispose() {
    super.dispose();
    if (_requestOperation != null) _requestOperation.cancel();
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

          return Opacity(
            opacity: _requestInProgress ? 0.6 : 1,
            child: SizedBox(
              height: 35,
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 10,);
                },
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const ClampingScrollPhysics(),
                itemCount: emojiCounts.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  ReactionsEmojiCount emojiCount = emojiCounts[index];

                  return OBEmojiReactionButton(
                    emojiCount,
                    reacted: widget.post.isReactionEmoji(emojiCount.emoji),
                    onLongPressed: (pressedEmojiCount) {
                      _navigationService.navigateToPostReactions(
                          post: widget.post,
                          reactionsEmojiCounts: emojiCounts,
                          context: context,
                          reactionEmoji: pressedEmojiCount.emoji);
                    },
                    onPressed: _onEmojiReactionCountPressed,
                  );
                },
              ),
            ),
          );
        });
  }

  void _onEmojiReactionCountPressed(
      ReactionsEmojiCount pressedEmojiCount) async {
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
    PostReaction postReaction;
    try {
      _requestOperation = CancelableOperation.fromFuture(
          _userService.reactToPost(post: widget.post, emoji: emoji));
      postReaction = await _requestOperation.value;
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }

    return postReaction;
  }

  Future<void> _deleteReaction() async {
    _setRequestInProgress(true);
    try {
      _requestOperation = CancelableOperation.fromFuture(
          _userService.deletePostReaction(
              postReaction: widget.post.reaction, post: widget.post));
      await _requestOperation.value;
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
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

  void _setRequestInProgress(requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
