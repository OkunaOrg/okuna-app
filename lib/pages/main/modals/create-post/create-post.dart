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
  VoidCallback onPostCreated;

  CreatePostModal({this.onPostCreated});

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

  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
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

    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        body: Container(
            child: Column(
          children: <Widget>[_buildNewPostContent(), _buildPostActions()],
        )));
  }

  Future<void> createPost() async {
    _setCreatePostInProgress(true);

    try {
      await _userService.createPost(
          text: _textController.text, image: _postImage);
      // Remove modal
      Navigator.pop(context);
      if (widget.onPostCreated != null) widget.onPostCreated();
    } on HttpieConnectionRefusedError {
      _toastService.error(
          scaffoldKey: _scaffoldKey, message: 'No internet connection');
      _setCreatePostInProgress(false);
    } catch (e) {
      _toastService.error(scaffoldKey: _scaffoldKey, message: 'Unknown error.');
      _setCreatePostInProgress(false);
      rethrow;
    }
  }

  Widget _buildAppBar() {
    bool newPostButtonIsEnabled =
        (_isPostTextAllowedLength && _charactersCount > 0) || _hasImage;

    return AppBar(
      title: Text('New post'),
      backgroundColor: Colors.white,
      elevation: 1.0,
      actions: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          // This is weird. If we do not add this, the button is not visible
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OBPrimaryButton(
                isDisabled: !newPostButtonIsEnabled,
                isLoading: _isCreatePostInProgress,
                isSmall: true,
                onPressed: createPost,
                child: Text('Share'),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildNewPostContent() {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(left: 20.0, top: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              OBLoggedInUserAvatar(
                size: OBUserAvatarSize.medium,
              ),
              SizedBox(
                height: 12.0,
              ),
              _buildRemainingCharacters(),
            ],
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

  Widget _buildRemainingCharacters() {
    return Text(
      (MAX_ALLOWED_CHARACTERS - _charactersCount).toString(),
      style: TextStyle(
          fontSize: 12.0,
          color: _isPostTextAllowedLength
              ? Colors.black26
              : Pigment.fromString('#F13A59'),
          fontWeight:
              _isPostTextAllowedLength ? FontWeight.normal : FontWeight.bold),
    );
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
          _unfocusTextField();
          File image = await _pickImage(ImageSource.gallery);
          if (image != null) _setPostImage(image);
        },
      ),
      OBPillButton(
        text: 'Camera',
        hexColor: '#00B7FF',
        icon: OBIcon(OBIcons.camera),
        onPressed: () async {
          _unfocusTextField();
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

      var postImageWidget = OBPostImagePreviewer(
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

    List<Widget> newPostItemsWidgets = List.from(_postItemsWidgets);
    newPostItemsWidgets.add(widgetSpacing);
    newPostItemsWidgets.add(postItemWidget);

    _setPostItemsWidgets(newPostItemsWidgets);

    return () {
      List<Widget> newPostItemsWidgets = List.from(_postItemsWidgets);
      newPostItemsWidgets.remove(postItemWidget);
      newPostItemsWidgets.remove(widgetSpacing);
      _setPostItemsWidgets(newPostItemsWidgets);
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

  void _setPostItemsWidgets(List<Widget> postItemsWidgets) {
    setState(() {
      _postItemsWidgets = postItemsWidgets;
    });
  }

  void _unfocusTextField() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
