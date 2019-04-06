import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/create_post_text.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/post_community_previewer.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/remaining_post_characters.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class EditPostModal extends StatefulWidget {
  final Post post;

  const EditPostModal({Key key, this.post})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditPostModalState();
  }
}

class EditPostModalState extends State<EditPostModal> {
  ValidationService _validationService;
  ToastService _toastService;
  UserService _userService;

  TextEditingController _textController;
  FocusNode _focusNode;
  int _charactersCount;

  bool _isPostTextAllowedLength;
  bool _hasFocus;
  bool _hasImage;
  bool _hasVideo;
  String _originalText;

  List<Widget> _postItemsWidgets;

  bool _isSaveInProgress;

  @override
  void initState() {
    super.initState();
    _originalText = widget.post.hasText() ? widget.post.getText() : null;
    _textController = TextEditingController(text: _originalText);
    _textController.addListener(_onPostTextChanged);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusNodeChanged);
    _hasFocus = false;
    _charactersCount = 0;
    _isPostTextAllowedLength = false;
    _hasImage = false;
    _hasVideo = false;
    _postItemsWidgets = [OBCreatePostText(controller: _textController, focusNode: _focusNode)];

    if (widget.post.hasCommunity())
      _postItemsWidgets.add(OBPostCommunityPreviewer(
        community: widget.post.community,
      ));

    if (widget.post.hasImage()) {
      _setPostImage(widget.post.getImage());
    }
    if (widget.post.hasVideo()) {
      _setPostImage(widget.post.getVideo());
    }
    _isSaveInProgress = false;
  }

  @override
  void dispose() {
    super.dispose();
    _textController.removeListener(_onPostTextChanged);
    _focusNode.removeListener(_onFocusNodeChanged);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _validationService = openbookProvider.validationService;
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
            child: Column(
              children: <Widget>[_buildEditPostContent()],
            )));
  }

  Widget _buildNavigationBar() {
    bool isPrimaryActionButtonIsEnabled =
        _isPostTextAllowedLength && _charactersCount > 0 && (_originalText != _textController.text);

    return OBThemedNavigationBar(
      leading: GestureDetector(
        child: const OBIcon(OBIcons.close),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: 'Edit post',
      trailing:
      _buildPrimaryActionButton(isEnabled: isPrimaryActionButtonIsEnabled),
    );
  }

  Widget _buildPrimaryActionButton({bool isEnabled}) {
    return OBButton(
            type: OBButtonType.primary,
            child: Text('Save'),
            size: OBButtonSize.small,
            onPressed: _onWantsToSavePost,
            isDisabled: !isEnabled,
            isLoading: _isSaveInProgress);
  }

  void _onWantsToSavePost() async {
    _setSaveInProgress(true);
    Post editedPost;
    try {
      editedPost = await _userService.editPost(
          postUuid: widget.post.uuid,
          text: _textController.text);
    } catch(error) {
      _onError(error);
    } finally {
      _setSaveInProgress(false);
    }

    if (editedPost != null) {
      // Remove modal
      Navigator.pop(context, editedPost);
    }
  }

  Widget _buildEditPostContent() {
    return Expanded(
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
                    maxCharacters: ValidationService.POST_MAX_LENGTH,
                    currentCharacters: _charactersCount,
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                      padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _postItemsWidgets)),
                ),
              )
            ],
          ),
        ));
  }

  void _onPostTextChanged() {
    String text = _textController.text;
    setState(() {
      _charactersCount = text.length;
      _isPostTextAllowedLength =
          _validationService.isPostTextAllowedLength(text);
    });
  }

  void _onFocusNodeChanged() {
    _hasFocus = _focusNode.hasFocus;
  }

  void _setPostImage(String imageUrl) {
    setState(() {
      _hasImage = true;

      var postImageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child:  Image(
              height: 200.0,
              width: 200.0,
              fit: BoxFit.cover,
              image: AdvancedNetworkImage(imageUrl,
                  useDiskCache: true,
                  fallbackAssetImage: 'assets/images/fallbacks/post-fallback.png',
                  retryLimit: 0
              )
          ),
        );

      _addPostItemWidget(postImageWidget);
    });
  }

  void _setPostVideo(String videoUrl) {
    setState(() {
      _hasVideo = true;

      //@todo: Construct postVideo widget from http url here
      Widget postVideoWidget = SizedBox();
       _addPostItemWidget(postVideoWidget);
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

  VoidCallback _addPostItemWidget(Widget postItemWidget) {
    var widgetSpacing = const SizedBox(
      height: 20.0,
    );

    List<Widget> newPostItemsWidgets = List.from(_postItemsWidgets);
    newPostItemsWidgets.insert(1, widgetSpacing);
    newPostItemsWidgets.insert(1, postItemWidget);

    _setPostItemsWidgets(newPostItemsWidgets);

    return () {
      List<Widget> newPostItemsWidgets = List.from(_postItemsWidgets);
      newPostItemsWidgets.remove(postItemWidget);
      newPostItemsWidgets.remove(widgetSpacing);
      _setPostItemsWidgets(newPostItemsWidgets);
    };
  }

  void _setPostItemsWidgets(List<Widget> postItemsWidgets) {
    setState(() {
      _postItemsWidgets = postItemsWidgets;
    });
  }

  void _setSaveInProgress(bool saveInProgress) {
    setState(() {
      _isSaveInProgress = saveInProgress;
    });
  }

  void _unfocusTextField() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
