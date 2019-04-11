import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OBPostActionReact extends StatefulWidget {
  final Post post;

  OBPostActionReact(this.post);

  @override
  State<StatefulWidget> createState() {
    return OBPostActionReactState();
  }
}

class OBPostActionReactState extends State<OBPostActionReact> {
  CancelableOperation _clearPostReactionOperation;
  bool _clearPostReactionInProgress;

  @override
  void initState() {
    super.initState();
    _clearPostReactionInProgress = false;
  }

  @override
  void dispose() {
    super.dispose();
    if (_clearPostReactionOperation != null)
      _clearPostReactionOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.post.updateSubject,
      initialData: widget.post,
      builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
        Post post = snapshot.data;
        PostReaction reaction = post.reaction;
        bool hasReaction = reaction != null;

        Widget buttonChild = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            const SizedBox(
              width: 10.0,
            ),
            OBText(
              hasReaction ? reaction.getEmojiKeyword() : 'React',
              style: TextStyle(
                color: hasReaction ? Colors.white : null,
                fontWeight: hasReaction ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );

        return OBButton(
          child: buttonChild,
          isLoading: _clearPostReactionInProgress,
          onPressed: _onPressed,
          type: hasReaction ? OBButtonType.primary : OBButtonType.highlight,
        );
      },
    );
  }

  void _onPressed() {
    if (widget.post.hasReaction()) {
      _clearPostReaction();
    } else {
      var openbookProvider = OpenbookProvider.of(context);
      openbookProvider.bottomSheetService
          .showReactToPost(post: widget.post, context: context);
    }
  }

  Future _clearPostReaction() async {
    if (_clearPostReactionInProgress) return;
    _setClearPostReactionInProgress(true);
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

    try {
      _clearPostReactionOperation = CancelableOperation.fromFuture(
          openbookProvider.userService.deletePostReaction(
              postReaction: widget.post.reaction, post: widget.post));

      await _clearPostReactionOperation.value;
      widget.post.clearReaction();
    } catch (error) {
      _onError(error: error, openbookProvider: openbookProvider);
    } finally {
      _clearPostReactionOperation = null;
      _setClearPostReactionInProgress(false);
    }
  }

  void _setClearPostReactionInProgress(bool clearPostReactionInProgress) {
    setState(() {
      _clearPostReactionInProgress = clearPostReactionInProgress;
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

typedef void OnWantsToReactToPost(Post post);
