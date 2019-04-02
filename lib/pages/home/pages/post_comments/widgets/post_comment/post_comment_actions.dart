import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OBPostCommentActions extends StatefulWidget {
  final Post post;
  final PostComment postComment;
  final Widget child;
  final VoidCallback onPostCommentDeletedCallback;
  final void Function(PostComment) onPostCommentEditedCallback;

  const OBPostCommentActions(
      {@required this.post,
       @required this.postComment,
       @required this.child,
       this.onPostCommentDeletedCallback,
       this.onPostCommentEditedCallback,
       Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBPostCommentActionsState();
  }

}

class OBPostCommentActionsState extends State<OBPostCommentActions> {
  UserService _userService;
  ToastService _toastService;
  ModalService _modalService;
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
    _modalService = openbookProvider.modalService;

    List<Widget> _editCommentActions = [];

    User loggedInUser = _userService.getLoggedInUser();
    bool loggedInUserIsCommunityAdministrator = false;
    bool loggedInUserIsCommunityModerator = false;

    Post post = widget.post;
    User postCommenter = widget.postComment.commenter;

    if (post.hasCommunity()) {
      Community postCommunity = post.community;

      loggedInUserIsCommunityAdministrator =
          postCommunity.isAdministrator(loggedInUser);

      loggedInUserIsCommunityModerator =
          postCommunity.isModerator(loggedInUser);
    }

    if (postCommenter.id == loggedInUser.id) {
      _editCommentActions.add(
        new IconSlideAction(
          caption: 'Edit',
          color: Colors.blueGrey,
          icon: Icons.edit,
          onTap: _editPostComment,
        ),
      );
    }

    if (widget.postComment.getCommenterId() == loggedInUser.id ||
        loggedInUserIsCommunityAdministrator ||
        loggedInUserIsCommunityModerator ||
        post.creator.id == loggedInUser.id) {

      _editCommentActions.add(
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: _deletePostComment,
        ),
      );
    }

    return Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.2,
      child: widget.child,
      secondaryActions: _editCommentActions,
    );
  }

  void _editPostComment() async {
    PostComment editedPostComment = await _modalService.openExpandedCommenter(
        context: context,
        post: widget.post,
        postComment: widget.postComment);

    if (widget.onPostCommentEditedCallback != null && editedPostComment != null) {
      widget.onPostCommentEditedCallback(editedPostComment);
    }
  }

  void _deletePostComment() async {
    _setRequestInProgress(true);
    try {
      await _userService.deletePostComment(
          postComment: widget.postComment, post: widget.post);
      widget.post.decreaseCommentsCount();
      _toastService.success(message: 'Comment deleted', context: context);
      if (widget.onPostCommentDeletedCallback != null) {
        widget.onPostCommentDeletedCallback();
      }
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
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
