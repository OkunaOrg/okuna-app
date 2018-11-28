import 'dart:io';

import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_cover.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:Openbook/widgets/buttons/primary_button.dart';
import 'package:Openbook/widgets/cover.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class OBEditUserProfileModal extends StatefulWidget {
  final User user;

  OBEditUserProfileModal(this.user);

  @override
  OBEditUserProfileModalState createState() {
    return OBEditUserProfileModalState();
  }
}

class OBEditUserProfileModalState extends State<OBEditUserProfileModal> {
  static const double INPUT_ICONS_SIZE = 16;
  static EdgeInsetsGeometry INPUT_CONTENT_PADDING =
      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0);

  UserService _userService;
  ToastService _toastService;

  bool _requestInProgress;
  final _formKey = GlobalKey<FormState>();
  bool _followersCountVisible;

  TextEditingController _usernameController;
  TextEditingController _nameController;
  TextEditingController _urlController;
  TextEditingController _locationController;
  TextEditingController _bioController;

  String _avatarUrl;
  String _coverUrl;
  File _avatarFile;
  File _coverFile;

  @override
  void initState() {
    _requestInProgress = false;

    _followersCountVisible = widget.user.getProfileFollowersCountVisible();
    _usernameController = TextEditingController(text: widget.user.username);
    _nameController = TextEditingController(text: widget.user.getProfileName());
    _urlController = TextEditingController(text: widget.user.getProfileUrl());
    _locationController =
        TextEditingController(text: widget.user.getProfileLocation());
    _bioController = TextEditingController(text: widget.user.getProfileBio());
    _avatarUrl = widget.user.getProfileAvatar();
    _coverUrl = widget.user.getProfileCover();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildNavigationBar(),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      _buildUserProfileCover(),
                      Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: (OBCover.HEIGHT / 2) -
                                  (OBUserAvatar.AVATAR_SIZE_LARGE / 2),
                            ),
                            _buildUserAvatar()
                          ],
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      contentPadding: INPUT_CONTENT_PADDING,
                      border: InputBorder.none,
                      labelText: 'Username',
                      prefixIcon: Icon(
                        Icons.alternate_email,
                        size: INPUT_ICONS_SIZE,
                      ),
                    ),
                  ),
                  Divider(),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      contentPadding: INPUT_CONTENT_PADDING,
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person, size: INPUT_ICONS_SIZE),
                      labelText: 'Name',
                    ),
                  ),
                  Divider(),
                  TextFormField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      contentPadding: INPUT_CONTENT_PADDING,
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.link,
                        size: INPUT_ICONS_SIZE,
                      ),
                      labelText: 'Url',
                    ),
                  ),
                  Divider(),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      contentPadding: INPUT_CONTENT_PADDING,
                      border: InputBorder.none,
                      labelText: 'Location',
                      prefixIcon: Icon(
                        Icons.location_on,
                        size: INPUT_ICONS_SIZE,
                      ),
                    ),
                  ),
                  Divider(),
                  TextFormField(
                    controller: _bioController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    decoration: InputDecoration(
                        contentPadding: INPUT_CONTENT_PADDING,
                        labelText: 'Bio',
                        prefixIcon: Icon(
                          Icons.bookmark,
                          size: INPUT_ICONS_SIZE,
                        ),
                        border: InputBorder.none),
                  ),
                  Divider(),
                  MergeSemantics(
                    child: ListTile(
                      leading: Icon(Icons.supervisor_account),
                      title: Text('Followers count'),
                      trailing: CupertinoSwitch(
                        value: _followersCountVisible,
                        onChanged: (bool value) {
                          setState(() {
                            _followersCountVisible = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _followersCountVisible = !_followersCountVisible;
                        });
                      },
                    ),
                  ),
                  Divider(),
                ],
              )),
        ));
  }

  Widget _buildNavigationBar() {
    bool newPostButtonIsEnabled = true;

    return CupertinoNavigationBar(
      backgroundColor: Colors.white,
      leading: GestureDetector(
        child: Icon(Icons.close, color: Colors.black87),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      middle: Text('Edit profile'),
      trailing: OBPrimaryButton(
        isDisabled: !newPostButtonIsEnabled,
        isLoading: _requestInProgress,
        isSmall: true,
        onPressed: _saveUser,
        child: Text('Save'),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Stack(
      children: <Widget>[
        OBUserAvatar(
          avatarUrl: _avatarUrl,
          avatarFile: _avatarFile,
          size: OBUserAvatarSize.large,
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 30, maxHeight: 30),
            child: FloatingActionButton(
              heroTag: Key('EditAvatar'),
              backgroundColor: Colors.white,
              child: Icon(
                Icons.edit,
                size: 15,
              ),
              onPressed: () {
                _showImageBottomSheet(
                    imageType: OBEditUserProfileModalImageType.avatar);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserProfileCover() {
    return Stack(
      children: <Widget>[
        OBCover(
          coverUrl: _coverUrl,
          coverFile: _coverFile,
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 40, maxHeight: 40),
            child: FloatingActionButton(
              heroTag: Key('editCover'),
              backgroundColor: Colors.white,
              child: Icon(
                Icons.edit,
                size: 20,
              ),
              onPressed: () {
                _showImageBottomSheet(
                    imageType: OBEditUserProfileModalImageType.cover);
              },
            ),
          ),
        )
      ],
    );
  }

  void _showImageBottomSheet(
      {@required OBEditUserProfileModalImageType imageType}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          List<Widget> listTiles = [
            new ListTile(
              leading: new Icon(Icons.camera_alt),
              title: new Text('Camera'),
              onTap: () async {
                var image = await _getUserImage(
                    source: ImageSource.camera, imageType: imageType);
                _onUserImageSelected(image: image, imageType: imageType);
                Navigator.pop(context);
                //if (image != null) createAccountBloc.avatar.add(image);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.photo_library),
              title: new Text('Gallery'),
              onTap: () async {
                var image = await _getUserImage(
                    source: ImageSource.gallery, imageType: imageType);
                _onUserImageSelected(image: image, imageType: imageType);
                Navigator.pop(context);
              },
            )
          ];

          switch (imageType) {
            case OBEditUserProfileModalImageType.cover:
              if (_coverUrl != null || _coverFile != null) {
                listTiles.add(ListTile(
                  leading: new Icon(Icons.delete),
                  title: new Text('Delete'),
                  onTap: () async {
                    _clearCover();
                    Navigator.pop(context);
                  },
                ));
              }
              break;
            case OBEditUserProfileModalImageType.avatar:
              if (_avatarUrl != null || _avatarFile != null) {
                listTiles.add(ListTile(
                  leading: new Icon(Icons.delete),
                  title: new Text('Delete'),
                  onTap: () async {
                    _clearAvatar();
                    Navigator.pop(context);
                  },
                ));
              }
              break;
          }

          return Column(mainAxisSize: MainAxisSize.min, children: listTiles);
        });
  }

  void _onUserImageSelected(
      {File image, OBEditUserProfileModalImageType imageType}) {
    if (image != null) {
      switch (imageType) {
        case OBEditUserProfileModalImageType.avatar:
          _setAvatarFile(image);
          break;
        case OBEditUserProfileModalImageType.cover:
          _setCoverFile(image);
          break;
      }
    }
  }

  Future<File> _getUserImage(
      {@required ImageSource source,
      @required OBEditUserProfileModalImageType imageType}) async {
    var image = await ImagePicker.pickImage(source: source);

    if (image == null) {
      return null;
    }

    double ratioX;
    double ratioY;

    switch (imageType) {
      case OBEditUserProfileModalImageType.cover:
        ratioX = 16.0;
        ratioY = 9.0;
        break;
      case OBEditUserProfileModalImageType.avatar:
        ratioX = 1.0;
        ratioY = 1.0;
        break;
    }

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      ratioX: ratioX,
      ratioY: ratioY,
    );

    return croppedFile;
  }

  void _saveUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.updateUser(
        avatar: _avatarFile ?? '',
        cover: _coverFile ?? '',
        name: _nameController.text,
        username: _usernameController.text,
        url: _urlController.text,
        birthDate: '',
        followersCountVisible: _followersCountVisible,
        bio: _bioController.text,
        location: _locationController.text,
      );
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _clearCover() {
    _setCoverUrl(null);
    _setCoverFile(null);
  }

  void _clearAvatar() {
    _setAvatarUrl(null);
    _setAvatarFile(null);
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _setAvatarUrl(String avatarUrl) {
    setState(() {
      _avatarUrl = avatarUrl;
    });
  }

  void _setCoverUrl(String coverUrl) {
    setState(() {
      _coverUrl = coverUrl;
    });
  }

  void _setAvatarFile(File avatarFile) {
    setState(() {
      _avatarFile = avatarFile;
    });
  }

  void _setCoverFile(File coverFile) {
    setState(() {
      _coverFile = coverFile;
    });
  }
}

enum OBEditUserProfileModalImageType { avatar, cover }
