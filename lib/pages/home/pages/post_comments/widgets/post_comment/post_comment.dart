import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/post_comment_reaction.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post_comment/widgets/post_comment_reactions/post_comment_reactions.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post_comment/widgets/post_comment_tile.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/user_preferences.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OBPostComment extends StatefulWidget {
  final PostComment postComment;
  final Post post;
  final Function(PostComment) onPostCommentDeletedCallback;
  final ValueChanged<PostComment> onPostCommentReported;

  OBPostComment(
      {@required this.post,
      @required this.postComment,
      this.onPostCommentDeletedCallback,
      this.onPostCommentReported,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBPostCommentState();
  }
}

class OBPostCommentState extends State<OBPostComment> {
  NavigationService _navigationService;
  UserService _userService;
  UserPreferencesService _userPreferencesService;
  ToastService _toastService;
  ModalService _modalService;
  bool _requestInProgress;
  int _repliesCount;
  List<PostComment> _replies;

  CancelableOperation _requestOperation;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
    _repliesCount = widget.postComment.repliesCount;
    _replies = widget.postComment.getPostCommentReplies();
  }

  @override
  void dispose() {
    super.dispose();
    if (_requestOperation != null) _requestOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _navigationService = provider.navigationService;
    _userService = provider.userService;
    _userPreferencesService = provider.userPreferencesService;
    _toastService = provider.toastService;
    _modalService = provider.modalService;
    Widget commentTile = OBPostCommentTile(post:widget.post, postComment: widget.postComment);

    Widget postComment = _buildPostCommentActions(
      child: commentTile,
    );

    if (_requestInProgress) {
      postComment = IgnorePointer(
        child: Opacity(
          opacity: 0.5,
          child: postComment,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        postComment,
        OBPostCommentReactions(
          postComment: widget.postComment,
          post: widget.post,
        ),
        _buildPostCommentReplies()
      ],
    );
  }

  Widget _buildPostCommentActions({@required Widget child}) {
    List<Widget> _commentActions = [];
    User loggedInUser = _userService.getLoggedInUser();

    if (loggedInUser.canDeletePostComment(widget.post, widget.postComment)) {
      _commentActions.add(
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: _deletePostComment,
        ),
      );
    }

    if (loggedInUser.canReportPostComment(widget.postComment)) {
      _commentActions.add(
        Opacity(
          opacity: widget.postComment.isReported ?? false ? 0.5 : 1,
          child: IconSlideAction(
            caption:
            widget.postComment.isReported ?? false ? 'Reported' : 'Report',
            color: Colors.black38,
            icon: Icons.report,
            onTap: _reportPostComment,
          ),
        ),
      );
    }

    if (loggedInUser.canEditPostComment(widget.postComment, widget.post)) {
      _commentActions.add(
        new IconSlideAction(
          caption: 'Edit',
          color: Colors.blueGrey,
          icon: Icons.edit,
          onTap: _editPostComment,
        ),
      );
    }

    if (loggedInUser.canReplyPostComment(widget.postComment)) {
      _commentActions.add(
          new IconSlideAction(
            caption: 'Reply',
            color: Colors.blue,
            icon: Icons.reply,
            onTap: _replyPostComment,
          )
      );
    }

    return Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.2,
      child: child,
      secondaryActions: _commentActions,
    );
  }

  Widget _buildPostCommentReplies() {
    if (_repliesCount == 0) return SizedBox();
    return Padding(
        padding: EdgeInsets.only(left: 30.0, top: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.all(0),
                itemCount: widget.postComment.getPostCommentReplies().length,
                itemBuilder: (context, index) {
                  PostComment reply =
                      widget.postComment.getPostCommentReplies()[index];

                  return OBPostComment(
                    key: Key('postCommentReply#${reply.id}'),
                    postComment: reply,
                    post: widget.post,
                    onPostCommentDeletedCallback: _onReplyDeleted,
                  );
                }),
            _buildViewAllReplies()
          ],
        ));
  }

  Widget _buildViewAllReplies() {
    if (!widget.postComment.hasReplies() ||
        (_repliesCount == _replies.length)) {
      return SizedBox();
    }

    return FlatButton(
        child: OBSecondaryText(
          'View all $_repliesCount replies',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: _onWantsToViewAllReplies);
  }

  void _onWantsToViewAllReplies() {
    _navigationService.navigateToPostCommentReplies(
        post: widget.post,
        postComment: widget.postComment,
        context: context,
        onReplyDeleted: _onReplyDeleted,
        onReplyAdded: _onReplyAdded);
  }

  void _onReplyDeleted(PostComment postCommentReply) async {
    setState(() {
      _repliesCount -= 1;
      _replies.removeWhere((reply) => reply.id == postCommentReply.id);
    });
  }

  void _onReplyAdded(PostComment postCommentReply) async {
    PostCommentsSortType sortType =
        await _userPreferencesService.getPostCommentsSortType();
    setState(() {
      if (sortType == PostCommentsSortType.dec) {
        _replies.insert(0, postCommentReply);
      } else if (_repliesCount == _replies.length) {
        _replies.add(postCommentReply);
      }
      _repliesCount += 1;
    });
  }

  void _editPostComment() async {
    await _modalService.openExpandedCommenter(
        context: context, post: widget.post, postComment: widget.postComment);
  }

  void _reportPostComment() async {
    await _navigationService.navigateToReportObject(
        context: context,
        object: widget.postComment,
        extraData: {'post': widget.post},
        onObjectReported: (dynamic reportedObject) {
          if (widget.onPostCommentReported != null && reportedObject != null)
            widget.onPostCommentReported(reportedObject as PostComment);
        });
  }

  void _replyPostComment() async {
    PostComment comment = await _modalService.openExpandedReplyCommenter(
        context: context,
        post: widget.post,
        postComment: widget.postComment,
        onReplyDeleted: _onReplyDeleted,
        onReplyAdded: _onReplyAdded);
    if (comment != null) {
      await _navigationService.navigateToPostCommentReplies(
          post: widget.post,
          postComment: widget.postComment,
          onReplyAdded: _onReplyAdded,
          onReplyDeleted: _onReplyDeleted,
          context: context);
    }
  }

  void _deletePostComment() async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);
    try {
      _requestOperation = CancelableOperation.fromFuture(
          _userService.deletePostComment(
              postComment: widget.postComment, post: widget.post));

      await _requestOperation.value;
      if (widget.postComment.parentComment == null) widget.post.decreaseCommentsCount();
      _toastService.success(message: 'Comment deleted', context: context);
      if (widget.onPostCommentDeletedCallback != null) {
        widget.onPostCommentDeletedCallback(widget.postComment);
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

typedef void OnWantsToSeeUserProfile(User user);
