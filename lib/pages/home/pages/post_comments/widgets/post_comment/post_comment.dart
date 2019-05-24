import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post_comment/widgets/post_comment_text.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OBPostComment extends StatefulWidget {
  final PostComment postComment;
  final Post post;
  final VoidCallback onPostCommentDeletedCallback;

  OBPostComment(
      {@required this.post,
      @required this.postComment,
      this.onPostCommentDeletedCallback,
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
  ToastService _toastService;
  ModalService _modalService;
  bool _requestInProgress;

  CancelableOperation _requestOperation;

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
    var provider = OpenbookProvider.of(context);
    _navigationService = provider.navigationService;
    _userService = provider.userService;
    _toastService = provider.toastService;
    _modalService = provider.modalService;
    Widget postTile = _buildPostCommentTile(widget.postComment);

    Widget postComment = _buildPostCommentActions(
      child: postTile,
    );

    if (_requestInProgress) {
      postComment = IgnorePointer(
        child: Opacity(
          opacity: 0.5,
          child: postComment,
        ),
      );
    }

    return postComment;
  }

  Widget _buildPostCommentTile(PostComment postComment) {
    return StreamBuilder(
        stream: widget.postComment.updateSubject,
        initialData: widget.postComment,
        builder: (BuildContext context, AsyncSnapshot<PostComment> snapshot) {
          PostComment postComment = snapshot.data;

          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                OBAvatar(
                  onPressed: () {
                    _navigationService.navigateToUserProfile(
                        user: postComment.commenter, context: context);
                  },
                  size: OBAvatarSize.small,
                  avatarUrl: postComment.getCommenterProfileAvatar(),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    OBPostCommentText(
                      postComment,
                      badge: _getCommunityBadge(postComment),
                      onUsernamePressed: () {
                        _navigationService.navigateToUserProfile(
                            user: postComment.commenter, context: context);
                      },
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    OBSecondaryText(
                      postComment.getRelativeCreated(),
                      style: TextStyle(fontSize: 12.0),
                    )
                  ],
                ))
              ],
            ),
          );
        });
  }

  Widget _buildPostCommentActions({@required Widget child}) {
    List<Widget> _editCommentActions = [];
    User loggedInUser = _userService.getLoggedInUser();

    if (loggedInUser.canEditPostComment(widget.postComment, widget.post)) {
      _editCommentActions.add(
        new IconSlideAction(
          caption: 'Edit',
          color: Colors.blueGrey,
          icon: Icons.edit,
          onTap: _editPostComment,
        ),
      );
    }

    if (loggedInUser.canDeletePostComment(widget.post, widget.postComment)) {
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
      child: child,
      secondaryActions: _editCommentActions,
    );
  }

  void _editPostComment() async {
    await _modalService.openExpandedCommenter(
        context: context, post: widget.post, postComment: widget.postComment);
  }

  void _deletePostComment() async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);
    try {
      _requestOperation = CancelableOperation.fromFuture(
          _userService.deletePostComment(
              postComment: widget.postComment, post: widget.post));

      await _requestOperation.value;
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

  Widget _getCommunityBadge(PostComment postComment) {
    Post post = widget.post;
    User postCommenter = postComment.commenter;

    if (post.hasCommunity()) {
      Community postCommunity = post.community;

      bool isCommunityAdministrator =
          postCommenter.isAdministratorOfCommunity(postCommunity);

      if (isCommunityAdministrator) {
        return _buildCommunityAdministratorBadge();
      }

      bool isCommunityModerator =
          postCommenter.isModeratorOfCommunity(postCommunity);

      if (isCommunityModerator) {
        return _buildCommunityModeratorBadge();
      }
    }

    return const SizedBox();
  }

  Widget _buildCommunityAdministratorBadge() {
    return const OBIcon(
      OBIcons.communityAdministrators,
      size: OBIconSize.small,
      themeColor: OBIconThemeColor.primaryAccent,
    );
  }

  Widget _buildCommunityModeratorBadge() {
    return const OBIcon(
      OBIcons.communityModerators,
      size: OBIconSize.small,
      themeColor: OBIconThemeColor.primaryAccent,
    );
  }
}

typedef void OnWantsToSeeUserProfile(User user);
