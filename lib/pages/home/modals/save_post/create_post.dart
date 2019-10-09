import 'dart:io';
import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_image.dart';
import 'package:Okuna/models/post_media.dart';
import 'package:Okuna/models/post_video.dart';
import 'package:Okuna/pages/home/modals/save_post/widgets/create_post_text.dart';
import 'package:Okuna/pages/home/modals/save_post/widgets/post_community_previewer.dart';
import 'package:Okuna/pages/home/modals/save_post/widgets/post_image_previewer.dart';
import 'package:Okuna/pages/home/modals/save_post/widgets/post_video_previewer.dart';
import 'package:Okuna/pages/home/modals/save_post/widgets/remaining_post_characters.dart';
import 'package:Okuna/pages/home/lib/draft_editing_controller.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/draft.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/link_preview.dart';
import 'package:Okuna/services/media.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/services/share.dart';
import 'package:Okuna/services/text_account_autocompletion.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/services/validation.dart';
import 'package:Okuna/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Okuna/widgets/avatars/avatar.dart';
import 'package:Okuna/widgets/buttons/button.dart';
import 'package:Okuna/widgets/buttons/pill_button.dart';
import 'package:Okuna/widgets/contextual_search_boxes/contextual_search_box_state.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/link_preview.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/new_post_data_uploader.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';
import 'package:Okuna/widgets/theming/smart_text.dart';
import 'package:async/async.dart';

class OBSavePostModal extends StatefulWidget {
  final Community community;
  final String text;
  final File image;
  final File video;
  final Post post;

  const OBSavePostModal(
      {Key key, this.community, this.text, this.image, this.video, this.post})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBSavePostModalState();
  }
}

class OBSavePostModalState extends ContextualSearchBoxState<OBSavePostModal>{
  ValidationService _validationService;
  UserService _userService;
  NavigationService _navigationService;
  MediaService _mediaService;
  ToastService _toastService;
  LocalizationService _localizationService;
  LinkPreviewService _linkPreviewService;
  DraftService _draftService;
  ShareService _shareService;

  TextEditingController _textController;
  FocusNode _focusNode;
  int _charactersCount;
  String _linkPreviewUrl;

  bool _isPostTextAllowedLength;
  bool _hasFocus;
  bool _hasImage;
  bool _hasVideo;

  // When creating a post
  File _postImageFile;
  File _postVideoFile;

  // When editing a post
  PostImage _postImage;
  PostVideo _postVideo;

  VoidCallback _postImageWidgetRemover;
  VoidCallback _postVideoWidgetRemover;
  VoidCallback _linkPreviewWidgetRemover;

  List<Widget> _postItemsWidgets;

  bool _needsBootstrap;
  bool _isCreateCommunityPostInProgress;

  bool _isEditingPost;

  bool _saveInProgress;
  CancelableOperation _saveOperation;

  @override
  void initState() {
    super.initState();
    _isEditingPost = widget.post != null;

    _focusNode = FocusNode();
    _hasFocus = false;
    _linkPreviewUrl = '';
    _isPostTextAllowedLength = false;
    _isCreateCommunityPostInProgress = false;
    _needsBootstrap = true;

    _focusNode.addListener(_onFocusNodeChanged);
  }

  @override
  void bootstrap() {
    super.bootstrap();

    if (_isEditingPost) {
      _saveInProgress = false;
      _textController = TextEditingController(text: widget.post?.text ?? '');
      _postItemsWidgets = [
        OBCreatePostText(controller: _textController, focusNode: _focusNode)
      ];
      if (widget.post.hasMedia()) {
        PostMedia postMedia = widget.post.getFirstMedia();
        if (postMedia.type == PostMediaType.video) {
          _setPostVideo(postMedia.contentObject as PostVideo);
          _hasImage = false;
        } else {
          _setPostImage(postMedia.contentObject as PostImage);
          _hasVideo = false;
        }
      } else {
        _hasVideo = false;
        _hasImage = false;
      }
    } else {
      _textController = DraftTextEditingController.post(
          text: widget.text,
          communityId: widget.community != null ? widget.community.id : null,
          draftService: _draftService);
      setAutocompleteTextController(_textController);
      _postItemsWidgets = [
        OBCreatePostText(controller: _textController, focusNode: _focusNode)
      ];
      _hasImage = false;
      _hasVideo = false;
      if (widget.image != null) {
        _setPostImageFile(widget.image);
      }
      if (widget.video != null) {
        _setPostVideoFile(widget.video);
      }
    }

    if (!_isEditingPost && widget.community != null)
      _postItemsWidgets.add(OBPostCommunityPreviewer(
        community: widget.community,
      ));

    _textController.addListener(_onPostTextChanged);
    _charactersCount = _textController.text.length;
    _isPostTextAllowedLength =
        _validationService.isPostTextAllowedLength(_textController.text);
    if (!_isEditingPost) {
      _shareService.subscribe(_onShare);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textController.removeListener(_onPostTextChanged);
    _focusNode.removeListener(_onFocusNodeChanged);
    _saveOperation?.cancel();
    _shareService.unsubscribe(_onShare);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _validationService = openbookProvider.validationService;
      _navigationService = openbookProvider.navigationService;
      _mediaService = openbookProvider.mediaService;
      _linkPreviewService = openbookProvider.linkPreviewService;
      _localizationService = openbookProvider.localizationService;
      _toastService = openbookProvider.toastService;
      _userService = openbookProvider.userService;
      _draftService = openbookProvider.draftService;
      _shareService = openbookProvider.shareService;
      bootstrap();
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        navigationBar: _buildNavigationBar(_localizationService),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            Expanded(
                flex: isAutocompleting ? 3 : 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: _buildNewPostContent(),
                )),
            isAutocompleting
                ? Expanded(
                    flex: 7,
                    child: buildSearchBox(),
                  )
                : const SizedBox(),
            isAutocompleting || (_hasImage || _hasVideo)
                ? const SizedBox()
                : Container(
                    height: _hasFocus == true ? 51 : 67,
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: _hasFocus == true ? 8 : 24),
                    color: Color.fromARGB(5, 0, 0, 0),
                    child: _buildPostActions(),
                  ),
          ],
        )));
  }

  Widget _buildNavigationBar(LocalizationService _localizationService) {
    bool isPrimaryActionButtonIsEnabled =
        (_isPostTextAllowedLength && _charactersCount > 0) ||
            _hasImage ||
            _hasVideo;

    return OBThemedNavigationBar(
      leading: GestureDetector(
        child: OBIcon(OBIcons.close,
            semanticLabel: _localizationService.post__close_create_post_label),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: _isEditingPost
          ? _localizationService.post__edit_title
          : _localizationService.trans('post__create_new'),
      trailing:
          _buildPrimaryActionButton(isEnabled: isPrimaryActionButtonIsEnabled),
    );
  }

  Widget _buildPrimaryActionButton({bool isEnabled}) {
    Widget nextButton;

    if (_isEditingPost) {
      return OBButton(
          type: OBButtonType.primary,
          child: Text(_localizationService.post__edit_save),
          size: OBButtonSize.small,
          onPressed: _savePost,
          isDisabled: !isEnabled || _saveInProgress,
          isLoading: _saveInProgress);
    } else if (widget.community != null) {
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
    OBNewPostData createPostData = await _navigationService.navigateToSharePost(
        context: context, createPostData: _makeNewPostData());

    if (createPostData != null) {
      // Remove modal
      Navigator.pop(context, createPostData);
      _clearDraft();
    }
  }

  Widget _buildNewPostContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
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
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _postItemsWidgets,
                )),
          ),
        )
      ],
    );
  }

  Widget _buildPostActions() {
    List<Widget> postActions = [];

    if (!_hasImage && !_hasVideo && !_isEditingPost) {
      postActions.addAll(_getImagePostActions());
    }

    if (postActions.isEmpty) return const SizedBox();

    return ListView.separated(
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
          try {
            File pickedPhoto = await _mediaService.pickImage(
                imageType: OBImageType.post,
                context: context,
                flattenGifs: false);
            if (pickedPhoto != null) {
              bool photoIsGif = _mediaService.isGif(pickedPhoto);
              if (photoIsGif) {
                File gifVideo =
                    await _mediaService.convertGifToVideo(pickedPhoto);
                _setPostVideoFile(gifVideo);
              } else {
                _setPostImageFile(pickedPhoto);
              }
            }
          } catch (error) {
            _onError(error);
          }
        },
      ),
      OBPillButton(
        text: _localizationService.post__create_video,
        color: Pigment.fromString('#50b1f2'),
        icon: const OBIcon(OBIcons.video),
        onPressed: () async {
          _unfocusTextField();
          try {
            File pickedVideo = await _mediaService.pickVideo(context: context);
            if (pickedVideo != null) _setPostVideoFile(pickedVideo);
          } catch (error) {
            _onError(error);
          }
        },
      ),
    ];
  }

  void _onPostTextChanged() {
    String text = _textController.text;
    _checkForLinkPreview();
    setState(() {
      _charactersCount = text.length;
      _isPostTextAllowedLength =
          _validationService.isPostTextAllowedLength(text);
    });
  }

  void _onFocusNodeChanged() {
    _hasFocus = _focusNode.hasFocus;
  }

  void _setPostImageFile(File image) {
    setState(() {
      this._postImageFile = image;
      _hasImage = true;

      var postImageWidget = OBPostImagePreviewer(
        postImageFile: _postImageFile,
        onRemove: () {
          _removePostImageFile();
        },
        onWillEditImage: () {
          _unfocusTextField();
        },
        onPostImageEdited: (File editedImage) {
          _removePostImageFile();
          _setPostImageFile(editedImage);
        },
      );

      _postImageWidgetRemover = _addPostItemWidget(postImageWidget);
    });

    _clearLinkPreviewUrl();
  }

  void _setPostVideoFile(File video) {
    setState(() {
      this._postVideoFile = video;
      _hasVideo = true;

      var postVideoWidget = OBPostVideoPreview(
        postVideoFile: _postVideoFile,
        onRemove: () {
          _removePostVideoFile();
        },
      );

      _postVideoWidgetRemover = _addPostItemWidget(postVideoWidget);
    });

    _clearLinkPreviewUrl();
  }

  void _setPostVideo(PostVideo postVideo) {
    // To be called on init only, therefore no setState
    _hasVideo = true;
    _postVideo = postVideo;

    var postVideoWidget = OBPostVideoPreview(
      postVideo: _postVideo,
    );

    _addPostItemWidget(postVideoWidget);
  }

  void _setPostImage(PostImage postImage) {
    // To be called on init only, therefore no setState
    _hasImage = true;
    _postImage = postImage;

    var postImageWidget = OBPostImagePreviewer(
      postImage: _postImage,
    );

    _addPostItemWidget(postImageWidget);
  }

  Future<bool> _onShare({String text, File image, File video}) async {
    if (image != null || video != null) {
      if (_hasImage) {
        _removePostImageFile();
      } else if (_hasVideo) {
        _removePostVideoFile();
      }
    }

    if (text != null) {
      _textController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    if (image != null) {
      _setPostImageFile(image);
    }

    if (video != null) {
      if (_mediaService.isGif(video)) {
        video = await _mediaService.convertGifToVideo(video);
      }

      _setPostVideoFile(video);
    }

    return true;
  }

  Future<void> _createCommunityPost() async {
    OBNewPostData newPostData = _makeNewPostData();
    Navigator.pop(context, newPostData);
    _clearDraft();
  }

  void _savePost() async {
    _setSaveInProgress(true);
    Post editedPost;
    try {
      _saveOperation = CancelableOperation.fromFuture(_userService.editPost(
          postUuid: widget.post.uuid, text: _textController.text));

      editedPost = await _saveOperation.value;
      Navigator.pop(context, editedPost);
    } catch (error) {
      _onError(error);
    } finally {
      _setSaveInProgress(false);
      _clearDraft();
    }
  }

  void _clearDraft() {
    if (_textController is DraftTextEditingController) {
      (_textController as DraftTextEditingController).clearDraft();
    }
  }

  void _checkForLinkPreview() async {
    if (_hasImage || _hasVideo) return;
    String text = _textController.text;

    String linkPreviewUrl = _linkPreviewService.checkForLinkPreviewUrl(text);

    if (linkPreviewUrl == null) {
      _clearLinkPreviewUrl();
      return;
    }

    if (linkPreviewUrl != null && linkPreviewUrl != _linkPreviewUrl) {
      _setLinkPreviewUrl(linkPreviewUrl);
    }
  }

  void _setLinkPreviewUrl(String url) {
    if (_linkPreviewWidgetRemover != null) _linkPreviewWidgetRemover();

    setState(() {
      _linkPreviewUrl = url;
      _linkPreviewWidgetRemover = _addPostItemWidget(OBLinkPreview(
        link: _linkPreviewUrl,
      ));
    });
  }

  void _clearLinkPreviewUrl() {
    setState(() {
      _linkPreviewUrl = null;
      if (_linkPreviewWidgetRemover != null) _linkPreviewWidgetRemover();
    });
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else if (error is FileTooLargeException) {
      int limit = error.getLimitInMB();
      _toastService.error(
          message: _localizationService.image_picker__error_too_large(limit),
          context: context);
    } else {
      _toastService.error(
          message: _localizationService.trans('error__unknown_error'),
          context: context);
      throw error;
    }
  }

  void _removePostImageFile() {
    setState(() {
      if (this._postImageFile != null) this._postImageFile.delete();
      _hasImage = false;
      _postImageWidgetRemover();
    });
  }

  void _removePostVideoFile() {
    setState(() {
      if (this._postVideoFile != null) this._postVideoFile.delete();
      _hasVideo = false;
      _postVideoWidgetRemover();
    });
  }

  OBNewPostData _makeNewPostData() {
    List<File> media = [];
    if (_postImageFile != null) media.add(_postImageFile);
    if (_postVideoFile != null) media.add(_postVideoFile);

    return OBNewPostData(
        text: _textController.text, media: media, community: widget.community);
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
      _saveInProgress = saveInProgress;
    });
  }

  void _unfocusTextField() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  void debugLog(String log) {
    debugPrint('CreatePostModal:$log');
  }
}
