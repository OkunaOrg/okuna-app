import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/post_comment_reaction.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OBPostCommentReactButton extends StatefulWidget {
  final PostComment postComment;
  final Post post;

  OBPostCommentReactButton({@required this.postComment, @required this.post});

  @override
  State<StatefulWidget> createState() {
    return OBPostCommentReactButtonState();
  }
}

class OBPostCommentReactButtonState extends State<OBPostCommentReactButton> {
  CancelableOperation _clearPostCommentReactionOperation;
  bool _clearPostCommentReactionInProgress;

  @override
  void initState() {
    super.initState();
    _clearPostCommentReactionInProgress = false;
  }

  @override
  void dispose() {
    super.dispose();
    if (_clearPostCommentReactionOperation != null)
      _clearPostCommentReactionOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.postComment.updateSubject,
      initialData: widget.postComment,
      builder: (BuildContext context, AsyncSnapshot<PostComment> snapshot) {
        PostComment postComment = snapshot.data;
        PostCommentReaction reaction = postComment.reaction;
        bool hasReaction = reaction != null;

        List<Widget> buttonRowItems = [
          hasReaction
              ? CachedNetworkImage(
                  height: 18.0,
                  imageUrl: reaction.getEmojiImage(),
                  errorWidget:
                      (BuildContext context, String url, Object error) {
                    return SizedBox(
                      child: Center(child: Text('?')),
                    );
                  },
                )
              : const OBIcon(
                  OBIcons.react,
                  customSize: 20.0,
                ),
        ];

        if (hasReaction) {
          buttonRowItems.addAll([
            const SizedBox(
              width: 10.0,
            ),
            OBText(
              reaction.getEmojiKeyword(),
              style: TextStyle(
                color: hasReaction ? Colors.white : null,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
          ]);
        }

        Widget buttonChild = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttonRowItems);

        return OBButton(
          minWidth: 50,
          child: buttonChild,
          isLoading: _clearPostCommentReactionInProgress,
          onPressed: _onPressed,
          type: hasReaction ? OBButtonType.primary : OBButtonType.highlight,
        );
      },
    );
  }

  void _onPressed() {
    if (widget.postComment.hasReaction()) {
      _clearPostCommentReaction();
    } else {
      var openbookProvider = OpenbookProvider.of(context);
      openbookProvider.bottomSheetService.showReactToPostComment(
          post: widget.post, postComment: widget.postComment, context: context);
    }
  }

  Future _clearPostCommentReaction() async {
    if (_clearPostCommentReactionInProgress) return;
    _setClearPostCommentReactionInProgress(true);
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

    try {
      _clearPostCommentReactionOperation = CancelableOperation.fromFuture(
          openbookProvider.userService.deletePostCommentReaction(
              postCommentReaction: widget.postComment.reaction,
              post: widget.post,
              postComment: widget.postComment));

      await _clearPostCommentReactionOperation.value;
      widget.postComment.clearReaction();
    } catch (error) {
      _onError(error: error, openbookProvider: openbookProvider);
    } finally {
      _clearPostCommentReactionOperation = null;
      _setClearPostCommentReactionInProgress(false);
    }
  }

  void _setClearPostCommentReactionInProgress(
      bool clearPostCommentReactionInProgress) {
    setState(() {
      _clearPostCommentReactionInProgress = clearPostCommentReactionInProgress;
    });
  }

  void _onError(
      {@required error,
      @required OpenbookProviderState openbookProvider}) async {
    ToastService toastService = openbookProvider.toastService;

    if (error is HttpieConnectionRefusedError) {
      toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      toastService.error(message: errorMessage, context: context);
    } else {
      toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }
}
