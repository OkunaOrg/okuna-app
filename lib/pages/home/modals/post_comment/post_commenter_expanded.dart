import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_comment.dart';
import 'package:Okuna/models/user.dart';
import 'package:Okuna/pages/home/modals/create_post/widgets/create_post_text.dart';
import 'package:Okuna/pages/home/modals/create_post/widgets/remaining_post_characters.dart';
import 'package:Okuna/widgets/contextual_account_search_box.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/bottom_sheet.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/services/text_account_autocompletion.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/services/validation.dart';
import 'package:Okuna/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Okuna/widgets/avatars/avatar.dart';
import 'package:Okuna/widgets/buttons/button.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostCommenterExpandedModal extends StatefulWidget {
  final Post post;
  final PostComment postComment;

  const OBPostCommenterExpandedModal({Key key, this.post, this.postComment})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBPostCommenterExpandedModalState();
  }
}

class OBPostCommenterExpandedModalState
    extends State<OBPostCommenterExpandedModal> {
  ValidationService _validationService;
  ToastService _toastService;
  UserService _userService;
  LocalizationService _localizationService;

  TextEditingController _textController;
  int _charactersCount;
  bool _isPostCommentTextAllowedLength;
  bool _isPostCommentTextOriginal;
  List<Widget> _postCommentItemsWidgets;
  String _originalText;
  bool _requestInProgress;
  bool _needsBootstrap;
  bool _isSearchingAccount;
  TextAccountAutocompletionService _textAccountAutocompletionService;
  OBContextualAccountSearchBoxController _contextualAccountSearchBoxController;

  CancelableOperation _postCommentOperation;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
        text: widget.postComment != null ? widget.postComment.text : '');
    _textController.addListener(_onPostCommentTextChanged);
    _charactersCount = 0;
    _isPostCommentTextAllowedLength = false;
    _isPostCommentTextOriginal = false;
    _originalText = widget.postComment.text;
    _requestInProgress = false;
    _isSearchingAccount = false;
    _needsBootstrap = true;
    _contextualAccountSearchBoxController =
        OBContextualAccountSearchBoxController();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.removeListener(_onPostCommentTextChanged);
    if (_postCommentOperation != null) _postCommentOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _validationService = openbookProvider.validationService;
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _localizationService = openbookProvider.localizationService;
      _textAccountAutocompletionService =
          openbookProvider.textAccountAutocompletionService;

      String hintText = widget.post.commentsCount > 0
          ? _localizationService.post__commenter_expanded_join_conversation
          : _localizationService.post__commenter_expanded_start_conversation;
      _postCommentItemsWidgets = [
        OBCreatePostText(controller: _textController, hintText: hintText)
      ];
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            _buildPostCommentEditor(),
            _isSearchingAccount ? _buildAccountSearchBox() : const SizedBox()
          ],
        )));
  }

  Widget _buildNavigationBar() {
    bool isPrimaryActionButtonIsEnabled = (_isPostCommentTextAllowedLength &&
        _charactersCount > 0 &&
        !_isPostCommentTextOriginal);

    return OBThemedNavigationBar(
      leading: GestureDetector(
        child: const OBIcon(OBIcons.close),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: _localizationService.post__commenter_expanded_edit_comment,
      trailing:
          _buildPrimaryActionButton(isEnabled: isPrimaryActionButtonIsEnabled),
    );
  }

  Widget _buildPrimaryActionButton({bool isEnabled}) {
    return OBButton(
      isDisabled: !isEnabled,
      isLoading: _requestInProgress,
      size: OBButtonSize.small,
      onPressed: _onWantsToSaveComment,
      child: Text(_localizationService.post__commenter_expanded_save),
    );
  }

  Widget _buildPostCommentEditor() {
    return Expanded(
        flex: _isSearchingAccount ? 3 : 10,
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, top: 20.0),
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
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 30.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _postCommentItemsWidgets)),
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildAccountSearchBox() {
    return Expanded(
        flex: 7,
        child: OBContextualAccountSearchBox(
          post: widget.post,
          controller: _contextualAccountSearchBoxController,
          onPostParticipantPressed: _onAccountSearchBoxUserPressed,
          initialSearchQuery:
              _contextualAccountSearchBoxController.getLastSearchQuery(),
        ));
  }

  void _onPostCommentTextChanged() {
    String text = _textController.text;
    _checkAutocomplete();
    setState(() {
      _charactersCount = text.length;
      _isPostCommentTextAllowedLength =
          _validationService.isPostCommentAllowedLength(text);
      _isPostCommentTextOriginal = _originalText == _textController.text;
    });
  }

  void _checkAutocomplete() {
    TextAccountAutocompletionResult result = _textAccountAutocompletionService
        .checkTextForAutocompletion(_textController);

    if (result.isAutocompleting) {
      debugLog('Wants to search account with searchQuery:' +
          result.autocompleteQuery);
      _setIsSearchingAccount(true);
      _contextualAccountSearchBoxController.search(result.autocompleteQuery);
    } else if (_isSearchingAccount) {
      debugLog('Finished searching accoun');
      _setIsSearchingAccount(false);
    }
  }

  void _onAccountSearchBoxUserPressed(User user) {
    _autocompleteFoundAccountUsername(user.username);
  }

  void _autocompleteFoundAccountUsername(String foundAccountUsername) {
    if (!_isSearchingAccount) {
      debugLog(
          'Tried to autocomplete found account username but was not searching account');
      return;
    }

    debugLog('Autocompleting with username:$foundAccountUsername');
    setState(() {
      _textController.text =
          _textAccountAutocompletionService.autocompleteTextWithUsername(
              _textController.text, foundAccountUsername);
      _textController.selection =
          TextSelection.collapsed(offset: _textController.text.length);
    });
  }

  void _setIsSearchingAccount(bool isSearchingAccount) {
    setState(() {
      _isSearchingAccount = isSearchingAccount;
    });
  }

  void _onWantsToSaveComment() async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);
    try {
      _postCommentOperation = CancelableOperation.fromFuture(
          _userService.editPostComment(
              post: widget.post,
              postComment: widget.postComment,
              text: _textController.text));

      PostComment comment = await _postCommentOperation.value;
      Navigator.pop(context, comment);
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
      _postCommentOperation = null;
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
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setRequestInProgress(requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void debugLog(String log) {
    debugPrint('OBPostCommenterExpandedModal:$log');
  }
}
