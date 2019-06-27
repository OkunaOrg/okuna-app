import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/bottom_sheet.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

class OBPostCommentActions extends StatefulWidget {
  final ValueChanged<PostComment> onReplyDeleted;
  final ValueChanged<PostComment> onReplyAdded;
  final ValueChanged<PostComment> onPostCommentDeleted;
  final ValueChanged<PostComment> onPostCommentReported;
  final Post post;
  final PostComment postComment;

  const OBPostCommentActions(
      {Key key,
      @required this.post,
      @required this.postComment,
      this.onReplyDeleted,
      this.onReplyAdded,
      this.onPostCommentDeleted,
      this.onPostCommentReported})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBPostCommentActionsState();
  }
}

class OBPostCommentActionsState extends State<OBPostCommentActions> {
  ModalService _modalService;
  NavigationService _navigationService;
  BottomSheetService _bottomSheetService;
  UserService _userService;
  ToastService _toastService;

  bool _requestInProgress;
  CancelableOperation _requestOperation;

  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _bottomSheetService = openbookProvider.bottomSheetService;
      _navigationService = openbookProvider.navigationService;
      _modalService = openbookProvider.modalService;
      _needsBootstrap = false;
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: OBSecondaryText(
            widget.postComment.getRelativeCreated(),
            style: TextStyle(fontSize: 12.0),
          ),
        ),
        _buildReplyButton(),
        _buildReactButton(),
        _buildMoreButton(),
      ],
    );
  }

  Widget _buildMoreButton() {
    return Expanded(
      child: FlatButton(
          onPressed: _onWantsToOpenMoreActions,
          child: OBIcon(
            OBIcons.moreHorizontal,
            themeColor: OBIconThemeColor.secondaryText,
          )),
    );
  }

  Widget _buildReactButton() {
    return Expanded(
      child: FlatButton(
          onPressed: _reactToPostComment,
          child: StreamBuilder(
              initialData: widget.postComment,
              builder:
                  (BuildContext context, AsyncSnapshot<PostComment> snapshot) {
                return OBSecondaryText(
                  'React',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              })),
    );
  }

  Widget _buildReplyButton() {
    User loggedInUser = _userService.getLoggedInUser();

    if (!loggedInUser.canReplyPostComment(widget.postComment))
      return const SizedBox();

    return Expanded(
      child: FlatButton(
          onPressed: _replyToPostComment,
          child: OBSecondaryText(
            'Reply',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_requestOperation != null) _requestOperation.cancel();
  }

  void _replyToPostComment() async {
    PostComment comment = await _modalService.openExpandedReplyCommenter(
        context: context,
        post: widget.post,
        postComment: widget.postComment,
        onReplyDeleted: widget.onReplyDeleted,
        onReplyAdded: widget.onReplyAdded);
    if (comment != null) {
      await _navigationService.navigateToPostCommentReplies(
          post: widget.post,
          postComment: widget.postComment,
          onReplyAdded: widget.onReplyAdded,
          onReplyDeleted: widget.onReplyDeleted,
          context: context);
    }
  }

  void _reactToPostComment() {
    if (widget.post.hasReaction()) {
      _clearPostReaction();
    } else {
      _bottomSheetService.showReactToPost(post: widget.post, context: context);
    }
  }

  Future _clearPostReaction() async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);

    try {
      _requestOperation = CancelableOperation.fromFuture(
          _userService.deletePostReaction(
              postReaction: widget.post.reaction, post: widget.post));

      await _requestOperation.value;
      widget.post.clearReaction();
    } catch (error) {
      _onError(error);
    } finally {
      _requestOperation = null;
      _setRequestInProgress(false);
    }
  }

  void _onWantsToOpenMoreActions() {
    _bottomSheetService.showMoreCommentActions(
        context: context,
        post: widget.post,
        postComment: widget.postComment,
        onPostCommentDeleted: widget.onPostCommentDeleted,
        onPostCommentReported: widget.onPostCommentReported);
  }

  void _setRequestInProgress(bool clearPostReactionInProgress) {
    setState(() {
      _requestInProgress = clearPostReactionInProgress;
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
