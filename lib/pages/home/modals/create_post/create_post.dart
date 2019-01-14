import 'dart:io';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/modals/create_post/pages/share_post/share_post.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/create_post_text.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/post_image_previewer.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/post_video_previewer.dart';
import 'package:Openbook/pages/home/modals/create_post/widgets/remaining_post_characters.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/bottom_sheet.dart';
import 'package:Openbook/services/image_picker.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:Openbook/widgets/buttons/pill_button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pigment/pigment.dart';

class CreatePostModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreatePostModalState();
  }
}

class CreatePostModalState extends State<CreatePostModal> {
  ValidationService _validationService;
  NavigationService _navigationService;
  BottomSheetService _bottomSheetService;

  TextEditingController _textController;
  int _charactersCount;

  bool _isPostTextAllowedLength;
  bool _hasImage;
  bool _hasVideo;
  File _postImage;
  File _postVideo;

  VoidCallback _postImageWidgetRemover;
  VoidCallback _postVideoWidgetRemover;

  List<Widget> _postItemsWidgets;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(_onPostTextChanged);
    _charactersCount = 0;
    _isPostTextAllowedLength = false;
    _hasImage = false;
    _hasVideo = false;
    _postItemsWidgets = [OBCreatePostText(controller: _textController)];
  }

  @override
  void dispose() {
    super.dispose();
    _textController.removeListener(_onPostTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _validationService = openbookProvider.validationService;
    _navigationService = openbookProvider.navigationService;
    _bottomSheetService = openbookProvider.bottomSheetService;

    return CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[_buildNewPostContent(), _buildPostActions()],
        )));
  }

  Widget _buildNavigationBar() {
    bool nextButtonIsEnabled =
        (_isPostTextAllowedLength && _charactersCount > 0) ||
            _hasImage ||
            _hasVideo;

    Widget nextButtonText = Text('Next');
    Widget nextButton;

    if (nextButtonIsEnabled) {
      nextButton = GestureDetector(
        onTap: _onWantsToSubmitPost,
        child: nextButtonText,
      );
    } else {
      nextButton = Opacity(
        opacity: 0.5,
        child: nextButtonText,
      );
    }

    return OBNavigationBar(
      leading: GestureDetector(
        child: OBIcon(OBIcons.close),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: 'New post',
      trailing: GestureDetector(
        onTap: _onWantsToSubmitPost,
        child: nextButton,
      ),
    );
  }

  void _onWantsToSubmitPost() async {
    Post sharedPost = await _navigationService.navigateToSharePost(
        context: context,
        createPostData:
            SharePostData(text: _textController.text, image: _postImage));

    if (sharedPost != null) {
      // Remove modal
      Navigator.pop(context, sharedPost);
    }
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
              OBRemainingPostCharacters(
                maxCharacters: ValidationService.POST_MAX_LENGTH,
                currentCharacters: _charactersCount,
              ),
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

  Widget _buildPostActions() {
    List<Widget> postActions = [];

    if (!_hasImage) {
      postActions.addAll(_getImagePostActions());
    }

    return Container(
      height: 51.0,
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      color: Color.fromARGB(5, 0, 0, 0),
      child: ListView.separated(
        itemCount: postActions.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, index) {
          var postAction = postActions[index];

          return index == 0
              ? Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    postAction
                  ],
                )
              : postAction;
        },
        separatorBuilder: (BuildContext context, index) {
          return SizedBox(
            width: 10,
          );
        },
      ),
    );
  }

  List<Widget> _getImagePostActions() {
    return [
      OBPillButton(
        text: 'Photo',
        color: Pigment.fromString('#FCC14B'),
        icon: OBIcon(OBIcons.photo),
        onPressed: () async {
          _unfocusTextField();
          File pickedPhoto =
              await _bottomSheetService.showPhotoPicker(context: context);
          if (pickedPhoto != null) _setPostImage(pickedPhoto);
        },
      ),
      OBPillButton(
        text: 'Video',
        color: Pigment.fromString('#00B7FF'),
        icon: OBIcon(OBIcons.video),
        onPressed: () async {
          _unfocusTextField();
          File pickedVideo =
              await _bottomSheetService.showVideoPicker(context: context);
          if (pickedVideo != null) _setPostVideo(pickedVideo);
        },
      )
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
    return image;
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
