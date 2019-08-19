import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/models/post.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/post/widgets/post-body/widgets/post_link_preview.dart';
import 'package:Okuna/widgets/theming/actionable_smart_text.dart';
import 'package:Okuna/widgets/theming/collapsible_smart_text.dart';
import 'package:Okuna/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';

class OBPostBodyText extends StatefulWidget {
  final Post _post;
  final OnTextExpandedChange onTextExpandedChange;

  OBPostBodyText(this._post, {this.onTextExpandedChange}) : super();

  @override
  OBPostBodyTextState createState() {
    return OBPostBodyTextState();
  }
}

class OBPostBodyTextState extends State<OBPostBodyText> {
  static const int MAX_LENGTH_LIMIT = 1300;

  ToastService _toastService;
  UserService _userService;
  LocalizationService _localizationService;
  BuildContext _context;
  String _translatedText;
  bool _translationInProgress;
  bool _requestInProgress;
  bool _needsBootstrap;
  CancelableOperation _fetchPreviewDataOperation;

  @override
  void initState() {
    super.initState();
    _translationInProgress = false;
    _translatedText = null;
    _requestInProgress = false;
    _needsBootstrap = true;
  }

  @override
  void dispose() {
    super.dispose();
    if (_fetchPreviewDataOperation != null)
      _fetchPreviewDataOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _toastService = OpenbookProvider.of(context).toastService;
    _userService = OpenbookProvider.of(context).userService;
    _localizationService = OpenbookProvider.of(context).localizationService;
    _context = context;

    return GestureDetector(
      onLongPress: _copyText,
      child: _buildFullPostText(),
    );
  }

  Widget _buildFullPostText() {
    if (widget._post.hasPreviewLink() && !widget._post.hasPreviewQueryData()) {
      this._fetchPreviewData();
    }

    return StreamBuilder(
        stream: widget._post.updateSubject,
        initialData: widget._post,
        builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
          if (!widget._post.hasPreviewLink()) {
            return _buildPostText();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _requestInProgress == true ? _getPreviewLoading() : OBPostLinkPreview(post: widget._post),
                _buildPostText(),
              ],
            );
          }
        });
  }

  Widget _getPreviewLoading() {
    return const Center(
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildPostText() {
    return Padding(padding: EdgeInsets.only(top: 20.0, left:20, right: 20), child: _buildActionablePostText());
  }

  Future<String> _translatePostText() async {
    String translatedText;
    try {
      _setTranslationInProgress(true);
      translatedText = await _userService.translatePost(post: widget._post);
    } catch (error) {
      _onError(error);
    } finally {
      _setTranslationInProgress(false);
    }
    return translatedText;
  }

  Future _fetchPreviewData() async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);
    try {
      _fetchPreviewDataOperation = CancelableOperation.fromFuture(
          _userService.getPreviewDataForPost(post: widget._post));

      await _fetchPreviewDataOperation.value;
    } catch (error) {
      _onError(error);
    } finally {
      _fetchPreviewDataOperation = null;
      _setRequestInProgress(false);
    }
  }

  Widget _buildActionablePostText() {
    if (widget._post.isEdited != null && widget._post.isEdited) {
      return OBCollapsibleSmartText(
        text: _translatedText != null ? _translatedText : widget._post.text,
        trailingSmartTextElement: SecondaryTextElement(' (edited)'),
        maxlength: MAX_LENGTH_LIMIT,
        getChild: _buildTranslationButton,
      );
    } else {
      return OBCollapsibleSmartText(
        text: _translatedText != null ? _translatedText : widget._post.text,
        maxlength: MAX_LENGTH_LIMIT,
        getChild: _buildTranslationButton,
      );
    }
  }

  Widget _buildTranslationButton() {
    if (_userService.getLoggedInUser() != null && !_userService.getLoggedInUser().canTranslatePost(widget._post)) {
      return SizedBox();
    }

    if (_translationInProgress) {
      return Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          width: 10.0,
          height: 10.0,
          child: CircularProgressIndicator(strokeWidth: 2.0),
        )
      );
    }

    return GestureDetector(
      onTap: () async {
        if (_translatedText == null) {
          String translatedText = await _translatePostText();
          _setTranslatedText(translatedText);
        } else {
          _setTranslatedText(null);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: _translatedText != null ?
        OBSecondaryText(_localizationService.trans('user__translate_show_original'), size: OBTextSize.large):
        OBSecondaryText(_localizationService.trans('user__translate_see_translation'), size: OBTextSize.large),
      ),
    );
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: widget._post.text));
    _toastService.toast(
        message: _localizationService.post__text_copied, context: _context, type: ToastType.info);
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setTranslationInProgress(bool translationInProgress) {
    setState(() {
      _translationInProgress = translationInProgress;
    });
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _setTranslatedText(String translatedText) {
    setState(() {
      _translatedText = translatedText;
    });
  }
}

typedef void OnTextExpandedChange(
    {@required Post post, @required bool isExpanded});
