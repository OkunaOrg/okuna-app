import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/post_comment_reaction.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/bottom_sheet.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

class OBPostCommentActions extends StatefulWidget {
  final ValueChanged<PostComment> onReplyDeleted;
  final ValueChanged<PostComment> onReplyAdded;
  final ValueChanged<PostComment> onPostCommentDeleted;
  final ValueChanged<PostComment> onPostCommentReported;
  final Post post;
  final PostComment postComment;
  final bool showReplyAction;

  const OBPostCommentActions(
      {Key key,
      @required this.post,
      @required this.postComment,
      this.onReplyDeleted,
      this.onReplyAdded,
      this.onPostCommentDeleted,
      this.onPostCommentReported,
      this.showReplyAction = true})
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
  ThemeService _themeService;
  ThemeValueParserService _themeValueParserService;

  bool _requestInProgress;
  CancelableOperation _requestOperation;

  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
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
      _themeService = openbookProvider.themeService;
      _themeValueParserService = openbookProvider.themeValueParserService;
      _needsBootstrap = false;
    }

    List<Widget> actionItems = [
      _buildReactButton(),
    ];

    if (widget.showReplyAction &&
        _userService
            .getLoggedInUser()
            .canReplyPostComment(widget.postComment)) {
      actionItems.add(_buildReplyButton());
    }

    actionItems.addAll([
      _buildMoreButton(),
    ]);

    return Opacity(
      opacity: 0.8,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actionItems),
    );
  }

  Widget _buildMoreButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
      child: GestureDetector(
          onTap: _onWantsToOpenMoreActions,
          child: SizedBox(
              child: OBIcon(
            OBIcons.moreHorizontal,
            themeColor: OBIconThemeColor.secondaryText,
          ))),
    );
  }

  Widget _buildReactButton() {
    return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
        child: GestureDetector(
          onTap: _reactToPostComment,
          child: SizedBox(
              child: StreamBuilder(
                  initialData: widget.postComment,
                  builder: (BuildContext context,
                      AsyncSnapshot<PostComment> snapshot) {
                    PostComment postComment = snapshot.data;

                    PostCommentReaction reaction = postComment.reaction;
                    bool hasReaction = reaction != null;

                    OBTheme activeTheme = _themeService.getActiveTheme();

                    return hasReaction
                        ? OBText(
                            reaction.getEmojiKeyword(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _themeValueParserService
                                    .parseGradient(
                                        activeTheme.primaryAccentColor)
                                    .colors[1]),
                          )
                        : OBSecondaryText(
                            'React',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                  })),
        ));
  }

  Widget _buildReplyButton() {

    return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
        child: GestureDetector(
          onTap: _replyToPostComment,
          child: SizedBox(
              child: OBSecondaryText(
            'Reply',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        ));
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
    if (widget.postComment.hasReaction()) {
      _clearPostCommentReaction();
    } else {
      _bottomSheetService.showReactToPostComment(
          post: widget.post, postComment: widget.postComment, context: context);
    }
  }

  Future _clearPostCommentReaction() async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);

    try {
      _requestOperation = CancelableOperation.fromFuture(
          _userService.deletePostCommentReaction(
              postComment: widget.postComment,
              postCommentReaction: widget.postComment.reaction,
              post: widget.post));

      await _requestOperation.value;
      widget.postComment.clearReaction();
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
