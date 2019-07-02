import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBMutePostCommentTile extends StatefulWidget {
  final Post post;
  final PostComment postComment;
  final VoidCallback onMutedPostComment;
  final VoidCallback onUnmutedPostComment;

  const OBMutePostCommentTile({
    Key key,
    @required this.postComment,
    this.onMutedPostComment,
    this.onUnmutedPostComment,
    @required this.post,
  }) : super(key: key);

  @override
  OBMutePostCommentTileState createState() {
    return OBMutePostCommentTileState();
  }
}

class OBMutePostCommentTileState extends State<OBMutePostCommentTile> {
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
      stream: widget.postComment.updateSubject,
      initialData: widget.postComment,
      builder: (BuildContext context, AsyncSnapshot<PostComment> snapshot) {
        var postComment = snapshot.data;

        bool isMuted = postComment.isMuted;

        return OBLoadingTile(
          isLoading: _requestInProgress,
          leading: OBIcon(
              isMuted ? OBIcons.unmutePostComment : OBIcons.mutePostComment),
          title: OBText(isMuted
              ? 'Turn on post comment notifications'
              : 'Turn off post comment notifications'),
          onTap: isMuted ? _unmutePostComment : _mutePostComment,
        );
      },
    );
  }

  void _mutePostComment() async {
    _setRequestInProgress(true);
    try {
      await _userService.mutePostComment(
          post: widget.post, postComment: widget.postComment);
      widget.postComment.setIsMuted(true);
      if (widget.onMutedPostComment != null) widget.onMutedPostComment();
    } catch (e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _unmutePostComment() async {
    _setRequestInProgress(true);
    try {
      await _userService.unmutePostComment(
          post: widget.post, postComment: widget.postComment);
      widget.postComment.setIsMuted(false);
      if (widget.onUnmutedPostComment != null) widget.onUnmutedPostComment();
    } catch (e) {
      _onError(e);
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

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
