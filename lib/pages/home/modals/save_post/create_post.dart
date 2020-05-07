import 'dart:io';

import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_image.dart';
import 'package:Okuna/models/post_media.dart';
import 'package:Okuna/models/post_video.dart';
import 'package:Okuna/pages/home/lib/draft_editing_controller.dart';
import 'package:Okuna/pages/home/modals/save_post/widgets/create_post_text.dart';
import 'package:Okuna/pages/home/modals/save_post/widgets/post_community_previewer.dart';
import 'package:Okuna/pages/home/modals/save_post/widgets/post_image_previewer.dart';
import 'package:Okuna/pages/home/modals/save_post/widgets/post_media_previewer.dart';
import 'package:Okuna/pages/home/modals/save_post/widgets/post_video_previewer.dart';
import 'package:Okuna/pages/home/modals/save_post/widgets/remaining_post_characters.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/draft.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/link_preview.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/media/media.dart';
import 'package:Okuna/services/media/models/media_file.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/services/share.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/services/validation.dart';
import 'package:Okuna/widgets/avatars/avatar.dart';
import 'package:Okuna/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Okuna/widgets/buttons/button.dart';
import 'package:Okuna/widgets/buttons/pill_button.dart';
import 'package:Okuna/widgets/contextual_search_boxes/contextual_search_box_state.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/link_preview.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/new_post_data_uploader.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/smart_text.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

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

class OBSavePostModalState extends OBContextualSearchBoxState<OBSavePostModal> {
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

  bool _isPostTextAllowedLength;
  bool _isPostTextContainingValidHashtags;

  bool _hasFocus;

  _MediaPreview _mediaPreview;

  bool _isProcessingMedia;

  List<Widget> _postItemsWidgets;

  bool _needsBootstrap;
  bool _isCreateCommunityPostInProgress;

  bool _isEditingPost;

  bool _saveInProgress;
  CancelableOperation _saveOperation;

  bool get _hasMedia => _mediaPreview != null;
  bool get _hasNonLinkMedia =>
      _hasMedia && _mediaPreview.type != _MediaType.link;

  @override
  void initState() {
    super.initState();
    _isEditingPost = widget.post != null;

    _focusNode = FocusNode();
    _hasFocus = false;
    _isProcessingMedia = false;
    _isPostTextAllowedLength = false;
    _isPostTextContainingValidHashtags = false;
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
        } else {
          _setPostImage(postMedia.contentObject as PostImage);
        }
      }
    } else {
      _textController = DraftTextEditingController.post(
          text: widget.text,
          communityId: widget.community != null ? widget.community.id : null,
          draftService: _draftService);
      _postItemsWidgets = [
        OBCreatePostText(controller: _textController, focusNode: _focusNode)
      ];
      if (widget.image != null) {
        _setPostImageFile(widget.image);
      }
      if (widget.video != null) {
        _setPostVideoFile(widget.video);
      }
    }

    setAutocompleteTextController(_textController);

    if (!_isEditingPost && widget.community != null)
      _postItemsWidgets.add(OBPostCommunityPreviewer(
        community: widget.community,
      ));

    _textController.addListener(_onPostTextChanged);
    _charactersCount = _textController.text.length;
    _isPostTextAllowedLength =
        _validationService.isPostTextAllowedLength(_textController.text);
    _isPostTextContainingValidHashtags = _validationService
        .isPostTextContainingValidHashtags(_textController.text);
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
            isAutocompleting || _hasNonLinkMedia || _isProcessingMedia
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
        (_isPostTextAllowedLength && _charactersCount > 0) || _hasNonLinkMedia;

    return OBThemedNavigationBar(
      leading: GestureDetector(
        child: OBIcon(OBIcons.close,
            semanticLabel: _localizationService.post__close_create_post_label),
        onTap: () {
          _removePostMedia();
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
          onPressed: _onWantsToCreateCommunityPost,
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

  Future<void> _onWantsToCreateCommunityPost() {
    if (!_isPostTextContainingValidHashtags) {
      _toastService.error(
          message: _localizationService.post__create_hashtags_invalid(
              ValidationService.POST_MAX_HASHTAGS,
              ValidationService.HASHTAG_MAX_LENGTH),
          context: context);
      return null;
    }
    return _createCommunityPost();
  }

  void _onWantsToGoNext() async {
    if (!_isPostTextContainingValidHashtags) {
      _toastService.error(
          message: _localizationService.post__create_hashtags_invalid(
              ValidationService.POST_MAX_HASHTAGS,
              ValidationService.HASHTAG_MAX_LENGTH),
          context: context);
      return;
    }

    OBNewPostData createPostData = await _navigationService.navigateToSharePost(
        context: context, createPostData: _makeNewPostData());

    if (createPostData != null) {
      // Remove modal
      if (_mediaPreview.type == _MediaType.video && _mediaPreview?.file != null)
        _mediaService.clearThumbnailForFile(_mediaPreview.file);
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

    if (!_hasNonLinkMedia && !_isEditingPost) {
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
        text: _localizationService.post__create_media,
        color: Pigment.fromString('#FCC14B'),
        icon: const OBIcon(OBIcons.photo),
        onPressed: () async {
          _unfocusTextField();
          try {
            await _mediaService.pickMedia(
                context: context,
                source: ImageSource.gallery,
                flattenGifs: false,
                onProgress: _onMediaProgress);
          } catch (error) {
            _onError(error);
          }
        },
      ),
      OBPillButton(
        text: _localizationService.post__create_camera,
        color: Pigment.fromString('#50b1f2'),
        icon: const OBIcon(OBIcons.cameraCartoon),
        onPressed: () async {
          _unfocusTextField();
          try {
            await _mediaService.pickMedia(
                context: context,
                source: ImageSource.camera,
                onProgress: _onMediaProgress);
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
      _isPostTextContainingValidHashtags =
          _validationService.isPostTextContainingValidHashtags(text);
    });
  }

  void _onFocusNodeChanged() {
    _hasFocus = _focusNode.hasFocus;
  }

  void _onMediaProgress(MediaProcessingState state, {dynamic data}) {
    if (!mounted) {
      return;
    }

    if (state == MediaProcessingState.processing) {
      /* TODO(komposten): Improve this part
          It would be preferable if the previous media was restored
          if this new media was cancelled before finishing processing.
       */
      _removePostMedia();
      _isProcessingMedia = true;
      // TODO(komposten): onRemove should cancel the whole operation.
      var postMediaWidget = OBPostMediaPreview(onRemove: _removePostMedia);
      var remover = _addPostItemWidget(postMediaWidget);

      _mediaPreview = _MediaPreview(
          type: _MediaType.pending, preview: postMediaWidget, remover: remover);
    } else if (state == MediaProcessingState.cancelled) {
      /* TODO(komposten): Ideally, calling pickMedia should create an operation
          which we can then cancel to end up here. That way starting a new media
          process can cause the previous one to cancel and this elif to remove data
          associated with it.
       */
    } else if (state == MediaProcessingState.error) {
      _toastService.error(message: data, context: context);
    } else if (state == MediaProcessingState.finished) {
      var pickedMedia = data as MediaFile;

      if (pickedMedia.type == FileType.image) {
        _isProcessingMedia = false;

        _setPostImageFile(pickedMedia.file);
      } else if (pickedMedia.type == FileType.video) {
        _isProcessingMedia = false;

        _setPostVideoFile(pickedMedia.file);
      } else {
        _isProcessingMedia = false;
        _removePostMedia();
        _toastService.error(
            message: 'An unsupported media type was picked!', context: context);
      }
    }
  }

  void _setPostImageFile(File image) {
    if (!mounted) {
      return;
    }

    _removePostMedia();

    setState(() {
      var postImageWidget = OBPostImagePreviewer(
        key: Key(image.path),
        postImageFile: image,
        onRemove: _removePostMedia,
        onWillEditImage: _unfocusTextField,
        onPostImageEdited: _setPostImageFile,
      );

      var remover = _addPostItemWidget(postImageWidget);
      _mediaPreview = _MediaPreview(
        type: _MediaType.image,
        preview: postImageWidget,
        file: image,
        remover: remover,
      );
    });
  }

  void _setPostVideoFile(File video) {
    if (!mounted) {
      return;
    }

    _removePostMedia();

    setState(() {
      var postVideoWidget = OBPostVideoPreview(
        key: Key(video.path),
        postVideoFile: video,
        onRemove: _removePostMedia,
      );

      var remover = _addPostItemWidget(postVideoWidget);
      _mediaPreview = _MediaPreview(
        type: _MediaType.video,
        preview: postVideoWidget,
        file: video,
        remover: remover,
      );
    });
  }

  void _setPostVideo(PostVideo postVideo) {
    // To be called on init only, therefore no setState

    var postVideoWidget = OBPostVideoPreview(
      postVideo: postVideo,
    );

    _addPostItemWidget(postVideoWidget);

    _mediaPreview = _MediaPreview(
        type: _MediaType.video, preview: postVideoWidget, video: postVideo);
  }

  void _setPostImage(PostImage postImage) {
    // To be called on init only, therefore no setState

    var postImageWidget = OBPostImagePreviewer(
      postImage: postImage,
    );

    _addPostItemWidget(postImageWidget);

    _mediaPreview = _MediaPreview(
        type: _MediaType.image, preview: postImageWidget, image: postImage);
  }

  Future<dynamic> _onShare({String text, File image, File video}) async {
    _removePostMedia();

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
      _setPostVideoFile(video);
    }

    return true;
  }

  Future<void> _createCommunityPost() async {
    OBNewPostData newPostData = _makeNewPostData();
    if (_mediaPreview.type == _MediaType.video && _mediaPreview?.file != null)
      _mediaService.clearThumbnailForFile(_mediaPreview.file);
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
    if (_hasNonLinkMedia) return;
    String text = _textController.text;

    String linkPreviewUrl = _linkPreviewService.checkForLinkPreviewUrl(text);

    if (linkPreviewUrl == null) {
      _removePostMedia();
    } else if (linkPreviewUrl != _mediaPreview?.link) {
      _setLinkPreviewUrl(linkPreviewUrl);
    }
  }

  void _setLinkPreviewUrl(String url) {
    _removePostMedia();

    setState(() {
      var linkPreview = OBLinkPreview(link: url);
      var remover = _addPostItemWidget(linkPreview);

      _mediaPreview = _MediaPreview(
        type: _MediaType.link,
        preview: linkPreview,
        link: url,
        remover: remover,
      );
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

  void _removePostMedia() {
    if (!_hasMedia) return;

    if (_mediaPreview.file != null) {
      if (_mediaPreview.type == _MediaType.video) {
        _mediaService.clearThumbnailForFile(_mediaPreview.file);
      }
      _mediaPreview.file.deleteSync();
    }
    _mediaPreview.remover?.call();

    if (mounted) {
      setState(() {
        _mediaPreview = null;
      });
    }
  }

  OBNewPostData _makeNewPostData() {
    List<File> media = [];
    if (_mediaPreview?.file != null) media.add(_mediaPreview.file);

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

class _MediaPreview {
  final _MediaType type;
  final Widget preview;
  final File file;
  final String link;
  final PostVideo video;
  final PostImage image;
  final void Function() remover;

  _MediaPreview(
      {@required this.type,
      @required this.preview,
      this.file,
      this.link,
      this.image,
      this.video,
      this.remover});
}

enum _MediaType { image, video, link, pending }
