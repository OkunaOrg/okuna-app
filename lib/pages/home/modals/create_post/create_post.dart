import 'dart:io';
import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_preview_link_data.dart';
import 'package:Okuna/models/user.dart';
import 'package:Okuna/pages/home/modals/create_post/pages/share_post/share_post.dart';
import 'package:Okuna/pages/home/modals/create_post/widgets/create_post_text.dart';
import 'package:Okuna/pages/home/modals/create_post/widgets/post_community_previewer.dart';
import 'package:Okuna/pages/home/modals/create_post/widgets/post_image_previewer.dart';
import 'package:Okuna/pages/home/modals/create_post/widgets/post_video_previewer.dart';
import 'package:Okuna/pages/home/modals/create_post/widgets/remaining_post_characters.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/image_picker.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/services/text_account_autocompletion.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/services/validation.dart';
import 'package:Okuna/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Okuna/widgets/avatars/avatar.dart';
import 'package:Okuna/widgets/buttons/button.dart';
import 'package:Okuna/widgets/buttons/pill_button.dart';
import 'package:Okuna/widgets/contextual_account_search_box.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/post/widgets/post-body/widgets/post_link_preview.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';
import 'package:Okuna/widgets/theming/smart_text.dart';
import 'package:async/async.dart';

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
  String _previewUrl;
  PostPreviewLinkData _previewLinkQueryData;

  bool _isPostTextAllowedLength;
  bool _hasFocus;
  bool _hasImage;
  bool _hasVideo;
  File _postImage;
  File _postVideo;

  VoidCallback _postImageWidgetRemover;
  VoidCallback _postVideoWidgetRemover;

  List<Widget> _postItemsWidgets;

  bool _needsBootstrap;
  bool _isCreateCommunityPostInProgress;
  bool _previewRequestInProgress;

  TextAccountAutocompletionService _textAccountAutocompletionService;
  OBContextualAccountSearchBoxController _contextualAccountSearchBoxController;
  bool _isSearchingAccount;
  CancelableOperation _fetchPreviewDataOperation;

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
    _previewUrl = '';
    _previewRequestInProgress = false;
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
    _contextualAccountSearchBoxController =
        OBContextualAccountSearchBoxController();
    _isSearchingAccount = false;
    _needsBootstrap = true;
  }

  @override
  void dispose() {
    super.dispose();
    _textController.removeListener(_onPostTextChanged);
    _focusNode.removeListener(_onFocusNodeChanged);
    if (_fetchPreviewDataOperation != null) {
      _fetchPreviewDataOperation.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _validationService = openbookProvider.validationService;
      _navigationService = openbookProvider.navigationService;
      _imagePickerService = openbookProvider.imagePickerService;
      _userService = openbookProvider.userService;
      _localizationService = openbookProvider.localizationService;
      _toastService = openbookProvider.toastService;
      _textAccountAutocompletionService =
          openbookProvider.textAccountAutocompletionService;
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            Expanded(
                flex: _isSearchingAccount ? 3 : 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: _buildNewPostContent(),
                )),
            _isSearchingAccount
                ? Expanded(
                    flex: 7,
                    child: _buildAccountSearchBox(),
                  )
                : const SizedBox(),
            _isSearchingAccount
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

  Widget _getPreviewWidget() {
    if (_previewLinkQueryData != null && !_hasImage && !_hasVideo) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(10.0)),
            child:  SizedBox(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: OBPostLinkPreview(
                      previewLinkQueryData: _previewLinkQueryData,
                      previewLink: _previewUrl
                  )),
            ),
      );
    } else if (_previewRequestInProgress) {
      return const Center(
        child: const CircularProgressIndicator(),
      );
    } else {
      return SizedBox();
    }
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
    return Row(
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
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _getPostItemsWidgetsWithPreview())),
          ),
        )
      ],
    );
  }

  List<Widget> _getPostItemsWidgetsWithPreview() {
    List<Widget> existingPostItemsWidgets = List.from(_postItemsWidgets);
    existingPostItemsWidgets.add(_getPreviewWidget());
    return existingPostItemsWidgets;
  }

  Widget _buildAccountSearchBox() {
    return OBContextualAccountSearchBox(
      controller: _contextualAccountSearchBoxController,
      onPostParticipantPressed: _onAccountSearchBoxUserPressed,
      initialSearchQuery:
          _contextualAccountSearchBoxController.getLastSearchQuery(),
    );
  }

  Widget _buildPostActions() {
    List<Widget> postActions = [];

    if (!_hasImage && !_hasVideo) {
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
          File pickedPhoto =
              await _imagePickerService.pickImage(imageType: OBImageType.post);
          if (pickedPhoto != null) _setPostImage(pickedPhoto);
        },
      ),
    ];
  }

  void _onPostTextChanged() {
    String text = _textController.text;
    _checkAutocomplete();
    _checkForPreviewUrl();
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

  void _checkForPreviewUrl() async {
    String text = _textController.text;
    List matches = [];
    String previewUrl;
    matches.addAll(linkRegex.allMatches(text).map((match){
      return match.group(0);
    }));

    if (matches.length > 0) {
      previewUrl = matches[0];
      if (previewUrl != _previewUrl) {
        _setPreviewUrl(previewUrl);
        await _fetchPreviewData(previewUrl);
      }
    } else {
      _setPreviewLinkQueryData(null);
    }
  }

  Future _fetchPreviewData(String url) async {
    if (_previewRequestInProgress && _fetchPreviewDataOperation != null) {
      _fetchPreviewDataOperation.cancel();
    }
    _setPreviewRequestInProgress(true);
    try {
      _fetchPreviewDataOperation = CancelableOperation.fromFuture(
          _userService.getPreviewDataForUrl(url: url));

      Map<String, dynamic> previewData = await _fetchPreviewDataOperation.value;
      _setPreviewLinkQueryData(previewData);
    } catch (error) {
      _onPreviewError(error);
    } finally {
      _fetchPreviewDataOperation = null;
      _setPreviewRequestInProgress(false);
    }
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
      debugLog('Finished searching account');
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

  void _setPreviewUrl(String url) {
    setState(() {
      _previewUrl = url;
    });
  }

  void _setPreviewRequestInProgress(bool previewRequestInProgress) {
    setState(() {
      _previewRequestInProgress = previewRequestInProgress;
    });
  }

  void _setPreviewLinkQueryData(Map<String, dynamic> queryData) {
    PostPreviewLinkData previewLinkQueryData;
    if (queryData != null) {
      previewLinkQueryData = PostPreviewLinkData();
      if (queryData.containsKey('title')) previewLinkQueryData.title = queryData['title'];
      if (queryData.containsKey('description')) previewLinkQueryData.description = queryData['description'];
      if (queryData.containsKey('image_url')) previewLinkQueryData.imageUrl = queryData['image_url'];
      if (queryData.containsKey('favicon_url')) previewLinkQueryData.faviconUrl = queryData['favicon_url'];
      if (queryData.containsKey('domain_url')) previewLinkQueryData.domainUrl = queryData['domain_url'];
    } else {
      previewLinkQueryData = null;
    }

    setState(() {
      _previewLinkQueryData = previewLinkQueryData;
    });
  }

  void _setIsSearchingAccount(bool isSearchingAccount) {
    setState(() {
      _isSearchingAccount = isSearchingAccount;
    });
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
      _toastService.error(
          message: _localizationService.trans('error__unknown_error'),
          context: context);
      throw error;
    }
  }

  void _onPreviewError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
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

  void debugLog(String log) {
    debugPrint('CreatePostModal:$log');
  }
}
