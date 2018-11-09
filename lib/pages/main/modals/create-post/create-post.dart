import 'dart:io';

import 'package:Openbook/pages/main/modals/create-post/widgets/post-image-previewer.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/avatars/logged-in-user-avatar.dart';
import 'package:Openbook/widgets/avatars/user-avatar.dart';
import 'package:Openbook/widgets/buttons/pill-button.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pigment/pigment.dart';

class CreatePostModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreatePostModalState();
  }
}

class CreatePostModalState extends State<CreatePostModal> {
  static const double actionIconHeight = 20.0;
  static const double actionSpacing = 10.0;
  static const int MAX_ALLOWED_CHARACTERS =
      ValidationService.MAX_ALLOWED_POST_TEXT_CHARACTERS;

  UserService _userService;
  ValidationService _validationService;
  ToastService _toastService;

  TextEditingController _textController;
  int _charactersCount;

  bool _isPostTextAllowedLength;
  bool _hasImage;
  bool _hasAudience;
  bool _hasBurner;

  File _postImage;

  VoidCallback _postImageWidgetRemover;

  List<Widget> _postItemsWidgets;

  bool _isCreatePostInProgress;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(_onPostTextChanged);
    _charactersCount = 0;
    _isPostTextAllowedLength = false;
    _hasImage = false;
    _hasAudience = false;
    _hasBurner = false;
    _isCreatePostInProgress = false;
    _postItemsWidgets = [_buildPostTextField()];
  }

  @override
  void dispose() {
    super.dispose();
    _textController.removeListener(_onPostTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _validationService = openbookProvider.validationService;
    _toastService = openbookProvider.toastService;

    return Material(
      child: CupertinoPageScaffold(
          navigationBar: _buildNavigationBar(),
          child: SafeArea(
              child: Container(
                  child: Column(
            children: <Widget>[
              _buildNewPostContent(),
              _buildPostInfoBar(),
              _buildPostActions()
            ],
          )))),
    );
  }

  Future<void> createPost() async {
    _setCreatePostInProgress(true);

    try {
      await _userService.createPost(
          text: _textController.text, image: _postImage);
      // Remove modal
      Navigator.pop(context);
      // Show toast
      _toastService.success(
          message: '🎉 Your post has been created!', context: context);
    } on HttpieConnectionRefusedError {
      _toastService.error(
          title: 'Can\'t reach Openbook.',
          message:
              'Please make sure you are connected to the internet and try again.',
          context: context);
    } catch (e) {
      _toastService.error(
          message: 'Uh.. something is not right.', context: context);
      _setCreatePostInProgress(false);
      throw e;
    }
    _setCreatePostInProgress(false);
  }

  Widget _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: Colors.white,
      leading: GestureDetector(
        child: Icon(Icons.close, color: Colors.black87),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      middle: Text('New post'),
      trailing: OBPrimaryButton(
        isDisabled: !_isPostTextAllowedLength || _charactersCount == 0,
        isLoading: _isCreatePostInProgress,
        isSmall: true,
        onPressed: createPost,
        child: Text('Share'),
      ),
    );
  }

  Widget _buildNewPostContent() {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(left: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LoggedInUserAvatar(
            size: UserAvatarSize.medium,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Container(
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

  Widget _buildPostTextField() {
    return TextField(
      controller: _textController,
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      style: TextStyle(color: Colors.black87, fontSize: 18.0),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'What\'s going on?',
      ),
      autocorrect: true,
    );
  }

  Widget _buildPostInfoBar() {
    return Container(
        padding:
            EdgeInsets.only(right: 20.0, bottom: 5.0, top: 5.0, left: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              '$_charactersCount/$MAX_ALLOWED_CHARACTERS',
              style: TextStyle(
                  color: _isPostTextAllowedLength
                      ? Colors.black26
                      : Pigment.fromString('#F13A59'),
                  fontWeight: _isPostTextAllowedLength
                      ? FontWeight.normal
                      : FontWeight.bold),
            )
          ],
        ));
  }

  Widget _buildPostActions() {
    List<Widget> postActions = [];

    if (!_hasImage) {
      postActions.addAll(_getImagePostActions());
    }

    if (!_hasAudience) {
      postActions.add(_buildAudiencePostAction());
    }

    if (!_hasBurner) {
      postActions.add(_buildBurnerPostAction());
    }

    // Add spacing
    List<Widget> spacedPostActions = [];

    int actionsCount = postActions.length;

    for (int i = 0; i < actionsCount; i++) {
      var postAction = postActions[i];
      spacedPostActions.add(_buildPostActionHorizontalSpacing());
      spacedPostActions.add(postAction);

      if (i == actionsCount - 1) {
        spacedPostActions.add(_buildPostActionHorizontalSpacing());
      }
    }

    return Container(
      height: 51.0,
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      color: Color.fromARGB(3, 0, 0, 0),
      child: ListView(
          scrollDirection: Axis.horizontal, children: spacedPostActions),
    );
  }

  List<Widget> _getImagePostActions() {
    return [
      OBPillButton(
        text: 'Media',
        hexColor: '#FCC14B',
        icon: OBIcon(OBIcons.media),
        onPressed: () async {
          File image = await _pickImage(ImageSource.gallery);
          if (image != null) _setPostImage(image);
        },
      ),
      OBPillButton(
        text: 'Camera',
        hexColor: '#00B7FF',
        icon: OBIcon(OBIcons.camera),
        onPressed: () async {
          File image = await _pickImage(ImageSource.camera);
          if (image != null) _setPostImage(image);
        },
      ),
      OBPillButton(
        text: 'GIF',
        hexColor: '#0F0F0F',
        icon: OBIcon(OBIcons.gif),
        onPressed: () {},
      ),
    ];
  }

  Widget _buildBurnerPostAction() {
    return OBPillButton(
      text: 'Burner',
      hexColor: '#F13A59',
      icon: OBIcon(OBIcons.burner),
      onPressed: () {},
    );
  }

  Widget _buildAudiencePostAction() {
    return OBPillButton(
      text: 'Audience',
      hexColor: '#80E37A',
      icon: OBIcon(OBIcons.audience),
      onPressed: () {},
    );
  }

  Widget _buildPostActionHorizontalSpacing() {
    return SizedBox(
      width: actionSpacing,
    );
  }

  void _onPostTextChanged() {
    String text = _textController.text;
    setState(() {
      _charactersCount = text.length;
      _isPostTextAllowedLength =
          _validationService.isPostTextAllowedLength(text);
    });
  }

  void _setPostImage(File image) {
    setState(() {
      this._postImage = image;
      _hasImage = true;

      var postImageWidget = PostImagePreviewer(
        _postImage,
        onRemove: () {
          _removePostImage();
        },
      );

      _postImageWidgetRemover = _addPostItemWidget(postImageWidget);
    });
  }

  void _removePostImage() {
    setState(() {
      if (this._postImage != null) this._postImage.delete();
      _hasImage = false;
      _postImageWidgetRemover();
    });
  }

  VoidCallback _addPostItemWidget(Widget postItemWidget) {
    var widgetSpacing = SizedBox(
      height: 20.0,
    );
    _postItemsWidgets.add(widgetSpacing);
    _postItemsWidgets.add(postItemWidget);
    return () {
      List<Widget> newPostItemsWidgets = List.from(_postItemsWidgets);
      newPostItemsWidgets.remove(postItemWidget);
      newPostItemsWidgets.remove(widgetSpacing);
      setState(() {
        _postItemsWidgets = newPostItemsWidgets;
      });
    };
  }

  Future<File> _pickImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    if (image == null) {
      return null;
    }

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 500,
      maxHeight: 500,
    );

    return croppedFile;
  }

  void _setCreatePostInProgress(bool createPostInProgress) {
    setState(() {
      _isCreatePostInProgress = createPostInProgress;
    });
  }
}
