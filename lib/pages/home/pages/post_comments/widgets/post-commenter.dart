import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/remaining_post_characters.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/alerts/alert.dart';
import 'package:Openbook/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/fields/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/services/httpie.dart';

class OBPostCommenter extends StatefulWidget {
  final Post post;
  final bool autofocus;
  final FocusNode commentTextFieldFocusNode;
  final OnPostCommentCreatedCallback onPostCommentCreated;
  final OnPostCommentWillBeCreatedCallback onPostCommentWillBeCreated;

  OBPostCommenter(this.post,
      {this.autofocus = false,
      this.commentTextFieldFocusNode,
      this.onPostCommentCreated,
      this.onPostCommentWillBeCreated});

  @override
  State<StatefulWidget> createState() {
    return OBPostCommenterState();
  }
}

class OBPostCommenterState extends State<OBPostCommenter> {
  TextEditingController _textController;
  bool _commentInProgress;
  bool _formWasSubmitted;
  bool _needsBootstrap;

  int _charactersCount;
  bool _isMultiline;

  UserService _userService;
  ToastService _toastService;
  ValidationService _validationService;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _commentInProgress = false;
    _formWasSubmitted = false;
    _needsBootstrap = true;
    _charactersCount = 0;
    _isMultiline = false;

    _textController.addListener(_onPostCommentChanged);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _userService = provider.userService;
      _toastService = provider.toastService;
      _validationService = provider.validationService;
      _needsBootstrap = false;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width: 20.0,
          ),
          Column(
            children: <Widget>[
              OBLoggedInUserAvatar(
                size: OBAvatarSize.medium,
              ),
              _isMultiline
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: OBRemainingPostCharacters(
                        maxCharacters:
                            ValidationService.POST_COMMENT_MAX_LENGTH,
                        currentCharacters: _charactersCount,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: OBAlert(
              padding: const EdgeInsets.all(0),
              child: Form(
                  key: _formKey,
                  child: LayoutBuilder(builder: (context, size) {
                    TextStyle style = TextStyle(fontSize: 14.0);
                    TextSpan text =
                        new TextSpan(text: _textController.text, style: style);

                    TextPainter tp = new TextPainter(
                      text: text,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                    );
                    tp.layout(maxWidth: size.maxWidth);

                    int lines =
                        (tp.size.height / tp.preferredLineHeight).ceil();

                    _isMultiline = lines > 3;

                    int maxLines = 5;

                    return _buildTextFormField(
                        lines < maxLines ? null : maxLines, style);
                  })),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0, left: 10.0),
            child: OBButton(
              isLoading: _commentInProgress,
              size: OBButtonSize.small,
              onPressed: _submitForm,
              child: Text('Post'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextFormField(int maxLines, TextStyle style) {
    EdgeInsetsGeometry inputContentPadding =
        EdgeInsets.symmetric(vertical: 8.0, horizontal: 10);

    bool autofocus = widget.autofocus;
    FocusNode focusNode = widget.commentTextFieldFocusNode ?? null;

    return OBTextFormField(
      controller: _textController,
      focusNode: focusNode,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: maxLines,
      style: style,
      decoration: InputDecoration(
        hintText: 'Write something...',
        contentPadding: inputContentPadding,
      ),
      hasBorder: false,
      autofocus: autofocus,
      autocorrect: true,
      validator: (String comment) {
        if (!_formWasSubmitted) return null;
        return _validationService.validatePostComment(_textController.text);
      },
    );
  }

  void _submitForm() async {
    _setFormWasSubmitted(true);

    bool formIsValid = _validateForm();

    if (!formIsValid) return;

    _setCommentInProgress(true);
    try {
      await (widget.onPostCommentWillBeCreated != null
          ? widget.onPostCommentWillBeCreated()
          : Future.value());
      String commentText = _textController.text;
      PostComment createdPostComment =
          await _userService.commentPost(text: commentText, post: widget.post);
      widget.post.incrementCommentsCount();
      _textController.clear();
      _setFormWasSubmitted(false);
      _validateForm();
      _setCommentInProgress(false);
      if (widget.onPostCommentCreated != null)
        widget.onPostCommentCreated(createdPostComment);
    } catch (error) {
      _onError(error);
    } finally {
      _setCommentInProgress(false);
    }
  }

  void _onPostCommentChanged() {
    int charactersCount = _textController.text.length;
    _setCharactersCount(charactersCount);
    if (charactersCount == 0) _setFormWasSubmitted(false);
    if (!_formWasSubmitted) return;
    _validateForm();
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
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

  void _setCommentInProgress(bool commentInProgress) {
    setState(() {
      _commentInProgress = commentInProgress;
    });
  }

  void _setFormWasSubmitted(bool formWasSubmitted) {
    setState(() {
      _formWasSubmitted = formWasSubmitted;
    });
  }

  void _setIsMultilline(bool isMultiline) {
    setState(() {
      _isMultiline = isMultiline;
    });
  }

  void _setCharactersCount(int charactersCount) {
    setState(() {
      _charactersCount = charactersCount;
    });
  }
}

typedef void OnPostCommentCreatedCallback(PostComment createdPostComment);
typedef Future OnPostCommentWillBeCreatedCallback();
