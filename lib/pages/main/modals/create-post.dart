import 'dart:io';

import 'package:Openbook/helpers/hex-color.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/avatars/logged-in-user-avatar.dart';
import 'package:Openbook/widgets/avatars/user-avatar.dart';
import 'package:Openbook/widgets/buttons/pill-button.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

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

  TextEditingController textController;
  int charactersCount;

  bool isPostTextAllowedLength;
  bool hasImage;
  bool hasAudience;
  bool hasBurner;

  File image;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textController.addListener(_onPostTextChanged);
    charactersCount = 0;
    isPostTextAllowedLength = false;
    hasImage = false;
    hasAudience = false;
    hasBurner = false;
  }

  @override
  void dispose() {
    super.dispose();
    textController.removeListener(_onPostTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _validationService = openbookProvider.validationService;

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
        isDisabled: !isPostTextAllowedLength,
        isSmall: true,
        onPressed: () {},
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
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
                child: TextField(
                  controller: textController,
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
                ),
              ),
            ),
          )
        ],
      ),
    ));
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
              '$charactersCount/$MAX_ALLOWED_CHARACTERS',
              style: TextStyle(
                  color: isPostTextAllowedLength
                      ? Colors.black26
                      : HexColor('#F13A59'),
                  fontWeight: isPostTextAllowedLength
                      ? FontWeight.normal
                      : FontWeight.bold),
            )
          ],
        ));
  }

  Widget _buildPostActions() {
    List<Widget> postActions = [];

    if (!hasImage) {
      postActions.addAll(_getImagePostActions());
    }

    if (!hasAudience) {
      postActions.add(_buildAudiencePostAction());
    }

    if (!hasBurner) {
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
        icon: Image.asset(
          'assets/images/icons/media-icon.png',
          height: actionIconHeight,
        ),
        onPressed: () async {
          File image = await _pickImage(ImageSource.gallery);
          if (image != null) _setImage(image);
        },
      ),
      OBPillButton(
        text: 'Camera',
        hexColor: '#00B7FF',
        icon: Image.asset(
          'assets/images/icons/camera-icon.png',
          height: actionIconHeight,
        ),
        onPressed: () async {
          File image = await _pickImage(ImageSource.camera);
          if (image != null) _setImage(image);
        },
      ),
      OBPillButton(
        text: 'GIF',
        hexColor: '#0F0F0F',
        icon: Image.asset(
          'assets/images/icons/gif-icon.png',
          height: actionIconHeight,
        ),
        onPressed: () {},
      ),
    ];
  }

  Widget _buildBurnerPostAction() {
    return OBPillButton(
      text: 'Burner',
      hexColor: '#F13A59',
      icon: Image.asset(
        'assets/images/icons/burner-icon.png',
        height: actionIconHeight,
      ),
      onPressed: () {},
    );
  }

  Widget _buildAudiencePostAction() {
    return OBPillButton(
      text: 'Audience',
      hexColor: '#80E37A',
      icon: Image.asset(
        'assets/images/icons/audience-icon.png',
        height: actionIconHeight,
      ),
      onPressed: () {},
    );
  }

  Widget _buildPostActionHorizontalSpacing() {
    return SizedBox(
      width: actionSpacing,
    );
  }

  void _onPostTextChanged() {
    String text = textController.text;
    setState(() {
      charactersCount = text.length;
      isPostTextAllowedLength =
          _validationService.isPostTextAllowedLength(text);
    });
  }

  void _setImage(File image) {
    setState(() {
      this.image = image;
      hasImage = true;
    });
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
}
