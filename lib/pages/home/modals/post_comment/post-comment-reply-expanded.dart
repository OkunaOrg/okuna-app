import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/create_post_text.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/remaining_post_characters.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post_comment/widgets/post_comment_tile.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/theming/post_divider.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class OBPostCommentReplyExpandedModal extends StatefulWidget {
  final Post post;
  final PostComment postComment;
  final Function(PostComment) onReplyAdded;
  final Function(PostComment) onReplyDeleted;

  const OBPostCommentReplyExpandedModal({Key key, this.post, this.postComment, this.onReplyAdded, this.onReplyDeleted}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBPostCommentReplyExpandedModalState();
  }
}

class OBPostCommentReplyExpandedModalState extends State<OBPostCommentReplyExpandedModal> {
  ValidationService _validationService;
  NavigationService _navigationService;
  ToastService _toastService;
  UserService _userService;

  TextEditingController _textController;
  int _charactersCount;
  bool _isPostCommentTextAllowedLength;
  List<Widget> _postCommentItemsWidgets;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(_onPostCommentTextChanged);
    _charactersCount = 0;
    _isPostCommentTextAllowedLength = false;
    String hintText = 'Your reply...';
    _postCommentItemsWidgets = [OBCreatePostText(controller: _textController, hintText: hintText)];

  }

  @override
  void dispose() {
    super.dispose();
    _textController.removeListener(_onPostCommentTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _validationService = openbookProvider.validationService;
    _navigationService = openbookProvider.navigationService;
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
            child: Column(
              children: <Widget>[_buildPostCommentContent()],
            )));
  }

  Widget _buildNavigationBar() {
    bool isPrimaryActionButtonIsEnabled =
    (_isPostCommentTextAllowedLength && _charactersCount > 0);

    return OBThemedNavigationBar(
      leading: GestureDetector(
        child: const OBIcon(OBIcons.close),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: 'Reply comment',
      trailing:
      _buildPrimaryActionButton(isEnabled: isPrimaryActionButtonIsEnabled),
    );
  }

  Widget _buildPrimaryActionButton({bool isEnabled}) {
    Widget primaryButton;

    if (isEnabled) {
      primaryButton = GestureDetector(
        onTap: _onWantsToReplyComment,
        child: const OBText('Post'),
      );
    } else {
      primaryButton = Opacity(
        opacity: 0.5,
        child: const OBText('Post'),
      );
    }

    return primaryButton;
  }

  void _onWantsToReplyComment() async {
    PostComment comment;
    if (widget.postComment != null) {
      comment = await _userService.replyPostComment(
          post: widget.post,
          postComment: widget.postComment,
          text: _textController.text);
    }
    if (comment != null) {
      // Remove modal
      if (widget.onReplyAdded != null) widget.onReplyAdded(comment);
      Navigator.pop(context, comment);
      _navigationService.navigateToPostCommentReplies(
          post: widget.post,
          postComment: widget.postComment,
          onReplyAdded: widget.onReplyAdded,
          onReplyDeleted: widget.onReplyDeleted,
          context: context);
    }
  }

  Widget _buildPostCommentContent() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 0.0, top: 20.0),
        child: Column(
          children: <Widget>[
            OBPostCommentTile(post:widget.post, postComment: widget.postComment),
            OBPostDivider(),
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10.0),
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Column(
                  children: <Widget>[
                      OBLoggedInUserAvatar(
                        size: OBAvatarSize.medium,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      OBRemainingPostCharacters(
                        maxCharacters: ValidationService.POST_COMMENT_MAX_LENGTH,
                        currentCharacters: _charactersCount,
                      ),
                    ],
                  ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                      padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0, top: 0.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _postCommentItemsWidgets)),
                      ),
                    )
                  ],
          ),
        )
      ],
    )
    ));
  }

  void _onPostCommentTextChanged() {
    String text = _textController.text;
    setState(() {
      _charactersCount = text.length;
      _isPostCommentTextAllowedLength =
          _validationService.isPostCommentAllowedLength(text);
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

  void _unfocusTextField() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
