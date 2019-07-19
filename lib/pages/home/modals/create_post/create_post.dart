import 'dart:io';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/modals/create_post/pages/share_post/share_post.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/create_post_text.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/post_community_previewer.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/post_image_previewer.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/post_video_previewer.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/remaining_post_characters.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/bottom_sheet.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/image_picker.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/pill_button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class CreatePostModal extends StatefulWidget {
  final Community community;
  final String text;
  final File image;

  const CreatePostModal({Key key, this.community, this.text, this.image})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreatePostModalState();
  }
}

class CreatePostModalState extends State<CreatePostModal> {
  ValidationService _validationService;
  NavigationService _navigationService;
  ImagePickerService _imagePickerService;
  ToastService _toastService;
  LocalizationService _localizationService;
  UserService _userService;

  TextEditingController _textController;
  FocusNode _focusNode;
  int _charactersCount;

  bool _isPostTextAllowedLength;
  bool _hasFocus;
  bool _hasImage;
  bool _hasVideo;
  File _postImage;
  File _postVideo;

  VoidCallback _postImageWidgetRemover;
  VoidCallback _postVideoWidgetRemover;

  List<Widget> _postItemsWidgets;

  bool _isCreateCommunityPostInProgress;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    if (widget.text != null) {
      _textController.text = widget.text;
    }
    _textController.addListener(_onPostTextChanged);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusNodeChanged);
    _hasFocus = false;
    _charactersCount = 0;
    _isPostTextAllowedLength = false;
    _hasImage = false;
    _hasVideo = false;
    _postItemsWidgets = [
      OBCreatePostText(controller: _textController, focusNode: _focusNode)
    ];

    if (widget.community != null)
      _postItemsWidgets.add(OBPostCommunityPreviewer(
        community: widget.community,
      ));
    if (widget.image != null) {
      _setPostImage(widget.image);
    }
    _isCreateCommunityPostInProgress = false;
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
    _navigationService = openbookProvider.navigationService;
    _imagePickerService = openbookProvider.imagePickerService;
    _userService = openbookProvider.userService;
    _localizationService = openbookProvider.localizationService;
    _toastService = openbookProvider.toastService;

    return CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[_buildNewPostContent(), _buildPostActions()],
        )));
  }

  Widget _buildNavigationBar() {
    bool isPrimaryActionButtonIsEnabled =
        (_isPostTextAllowedLength && _charactersCount > 0) ||
            _hasImage ||
            _hasVideo;

    return OBThemedNavigationBar(
      leading: GestureDetector(
        child: const OBIcon(OBIcons.close),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: _localizationService.trans('post__create_new'),
      trailing:
          _buildPrimaryActionButton(isEnabled: isPrimaryActionButtonIsEnabled),
    );
  }

  Widget _buildPrimaryActionButton({bool isEnabled}) {
    Widget nextButton;

    if (widget.community != null) {
      return OBButton(
          type: OBButtonType.primary,
          child: Text(_localizationService.trans('post__share')),
          size: OBButtonSize.small,
          onPressed: _createCommunityPost,
          isDisabled: !isEnabled || _isCreateCommunityPostInProgress,
          isLoading: _isCreateCommunityPostInProgress);
    } else {
      if (isEnabled) {
        nextButton = GestureDetector(
          onTap: _onWantsToGoNext,
          child: OBText(_localizationService.trans('post__create_next')),
        );
      } else {
        nextButton = Opacity(
          opacity: 0.5,
          child: OBText(_localizationService.trans('post__create_next')),
        );
      }
    }

    return nextButton;
  }

  void _onWantsToGoNext() async {
    Post sharedPost = await _navigationService.navigateToSharePost(
        context: context,
        sharePostData:
            SharePostData(text: _textController.text, image: _postImage));

    if (sharedPost != null) {
      // Remove modal
      Navigator.pop(context, sharedPost);
    }
  }

  Widget _buildNewPostContent() {
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

  Widget _buildPostActions() {
    List<Widget> postActions = [];

    if (!_hasImage && !_hasVideo) {
      postActions.addAll(_getImagePostActions());
    }

    if (postActions.isEmpty) return const SizedBox();

    return Container(
      height: _hasFocus == true ? 51 : 67,
      padding: EdgeInsets.only(top: 8.0, bottom: _hasFocus == true ? 8 : 24),
      color: Color.fromARGB(5, 0, 0, 0),
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        itemCount: postActions.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, index) {
          var postAction = postActions[index];

          return index == 0
              ? Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 10,
                    ),
                    postAction
                  ],
                )
              : postAction;
        },
        separatorBuilder: (BuildContext context, index) {
          return const SizedBox(
            width: 10,
          );
        },
      ),
    );
  }

  List<Widget> _getImagePostActions() {
    return [
      OBPillButton(
        text: _localizationService.trans('post__create_photo'),
        color: Pigment.fromString('#FCC14B'),
        icon: const OBIcon(OBIcons.photo),
        onPressed: () async {
          _unfocusTextField();
          File pickedPhoto =
              await _imagePickerService.pickImage(imageType: OBImageType.post);
          if (pickedPhoto != null) _setPostImage(pickedPhoto);
        },
      ),
    ];
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

  void _setPostImage(File image) {
    setState(() {
      this._postImage = image;
      _hasImage = true;

      var postImageWidget = OBPostImagePreviewer(
        _postImage,
        onRemove: () {
          _removePostImage();
        },
      );

      _postImageWidgetRemover = _addPostItemWidget(postImageWidget);
    });
  }

  void _setPostVideo(File video) {
    setState(() {
      this._postVideo = video;
      _hasVideo = true;

      var postVideoWidget = OBPostVideoPreviewer(
        _postVideo,
        onRemove: () {
          _removePostVideo();
        },
      );

      _postVideoWidgetRemover = _addPostItemWidget(postVideoWidget);
    });
  }

  Future<void> _createCommunityPost() async {
    _setCreateCommunityPostInProgress(true);

    try {
      Post createdPost = await _userService.createPostForCommunity(
          widget.community,
          text: _textController.text,
          image: _postImage,
          video: _postVideo);
      // Remove modal
      Navigator.pop(context, createdPost);
    } catch (error) {
      _onError(error);
    } finally {
      _setCreateCommunityPostInProgress(false);
    }
  }

  void _setCreateCommunityPostInProgress(bool createCommunityPostInProgress) {
    setState(() {
      _isCreateCommunityPostInProgress = createCommunityPostInProgress;
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
      _toastService.error(message: _localizationService.trans('error__unknown_error'), context: context);
      throw error;
    }
  }

  void _removePostImage() {
    setState(() {
      if (this._postImage != null) this._postImage.delete();
      _hasImage = false;
      _postImageWidgetRemover();
    });
  }

  void _removePostVideo() {
    setState(() {
      if (this._postVideo != null) this._postVideo.delete();
      _hasVideo = false;
      _postVideoWidgetRemover();
    });
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

  void _unfocusTextField() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
