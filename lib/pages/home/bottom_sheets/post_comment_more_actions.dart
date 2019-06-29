import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

class OBPostCommentMoreActionsBottomSheet extends StatefulWidget {
  final PostComment postComment;
  final Post post;
  final ValueChanged<PostComment> onPostCommentDeleted;
  final ValueChanged<PostComment> onPostCommentReported;

  const OBPostCommentMoreActionsBottomSheet({
    @required this.post,
    @required this.postComment,
    Key key,
    @required this.onPostCommentDeleted,
    @required this.onPostCommentReported,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBPostCommentMoreActionsBottomSheetState();
  }
}

class OBPostCommentMoreActionsBottomSheetState
    extends State<OBPostCommentMoreActionsBottomSheet> {
  ToastService _toastService;
  UserService _userService;
  NavigationService _navigationService;
  ModalService _modalService;
  bool _requestInProgress;
  CancelableOperation _requestOperation;

  @override
  void initState() {
    _requestInProgress = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_requestOperation != null) _requestOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    OpenbookProviderState provider = OpenbookProvider.of(context);
    _toastService = provider.toastService;
    _userService = provider.userService;
    _navigationService = provider.navigationService;
    _modalService = provider.modalService;

    return OBPrimaryColorContainer(
      mainAxisSize: MainAxisSize.min,
      child: Opacity(
        opacity: _requestInProgress ? 0.5 : 1,
        child: Column(
          children: _buildActionTiles(),
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }

  List<Widget> _buildActionTiles() {
    List<Widget> actionTiles = [];
    User loggedInUser = _userService.getLoggedInUser();

    if (loggedInUser.canDeletePostComment(widget.post, widget.postComment)) {
      actionTiles.add(
        ListTile(
          leading: const OBIcon(OBIcons.deletePost),
          title: const OBText(
            'Delete comment',
          ),
          onTap: _deletePostComment,
        ),
      );
    }

    if (loggedInUser.canReportPostComment(widget.postComment)) {
      actionTiles.add(
        Opacity(
          opacity: widget.postComment.isReported ?? false ? 0.5 : 1,
          child: ListTile(
            leading: const OBIcon(OBIcons.report),
            title: OBText(
                widget.postComment.isReported ?? false ? 'Reported' : 'Report'),
            onTap: _reportPostComment,
          ),
        ),
      );
    }

    if (loggedInUser.canEditPostComment(widget.postComment, widget.post)) {
      actionTiles.add(
        ListTile(
          leading: const OBIcon(OBIcons.edit),
          title: const OBText(
            'Edit comment',
          ),
          onTap: _editPostComment,
        ),
      );
    }

    return actionTiles;
  }

  void _reportPostComment() async {
    _dismissMoreActions();
    await _navigationService.navigateToReportObject(
        context: context,
        object: widget.postComment,
        extraData: {'post': widget.post},
        onObjectReported: (dynamic reportedObject) {
          if (widget.onPostCommentReported != null && reportedObject != null)
            widget.onPostCommentReported(reportedObject as PostComment);
        });
  }

  void _deletePostComment() async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);
    _dismissMoreActions();
    try {
      _requestOperation = CancelableOperation.fromFuture(
          _userService.deletePostComment(
              postComment: widget.postComment, post: widget.post));

      await _requestOperation.value;
      if (widget.postComment.parentComment == null)
        widget.post.decreaseCommentsCount();
      _toastService.success(message: 'Comment deleted', context: context);
      if (widget.onPostCommentDeleted != null) {
        widget.onPostCommentDeleted(widget.postComment);
      }
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _editPostComment() async {
    _dismissMoreActions();
    await _modalService.openExpandedCommenter(
        context: context, post: widget.post, postComment: widget.postComment);
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

  void _dismissMoreActions() {
    Navigator.pop(context);
  }
}
