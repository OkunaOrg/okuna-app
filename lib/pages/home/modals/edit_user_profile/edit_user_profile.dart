import 'dart:io';

import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/image_picker.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/cover.dart';
import 'package:Openbook/widgets/fields/text_form_field.dart';
import 'package:Openbook/widgets/fields/toggle_field.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBEditUserProfileModal extends StatefulWidget {
  final User user;

  OBEditUserProfileModal(this.user);

  @override
  OBEditUserProfileModalState createState() {
    return OBEditUserProfileModalState();
  }
}

class OBEditUserProfileModalState extends State<OBEditUserProfileModal> {
  static const double inputIconsSize = 16;
  static EdgeInsetsGeometry inputContentPadding =
      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0);

  UserService _userService;
  ToastService _toastService;
  ImagePickerService _imagePickerService;
  ValidationService _validationService;

  bool _requestInProgress;
  bool _formWasSubmitted;
  String _takenUsername;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _usernameController;
  TextEditingController _nameController;
  TextEditingController _urlController;
  TextEditingController _locationController;
  TextEditingController _bioController;
  String _avatarUrl;
  String _coverUrl;
  File _avatarFile;
  File _coverFile;
  bool _followersCountVisible;

  @override
  void initState() {
    super.initState();

    _requestInProgress = false;
    _formWasSubmitted = false;

    _followersCountVisible = widget.user.getProfileFollowersCountVisible();
    _usernameController = TextEditingController(text: widget.user.username);
    _nameController = TextEditingController(text: widget.user.getProfileName());
    _urlController = TextEditingController(text: widget.user.getProfileUrl());
    _locationController =
        TextEditingController(text: widget.user.getProfileLocation());
    _bioController = TextEditingController(text: widget.user.getProfileBio());
    _avatarUrl = widget.user.getProfileAvatar();
    _coverUrl = widget.user.getProfileCover();

    _usernameController.addListener(_validateForm);
    _nameController.addListener(_validateForm);
    _urlController.addListener(_validateForm);
    _locationController.addListener(_validateForm);
    _bioController.addListener(_validateForm);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _imagePickerService = openbookProvider.imagePickerService;
    _validationService = openbookProvider.validationService;

    return Scaffold(
        appBar: _buildNavigationBar(),
        body: OBPrimaryColorContainer(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        _buildUserProfileCover(),
                        Positioned(
                          left: 20,
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: (OBCover.normalSizeHeight) -
                                    (OBAvatar.AVATAR_SIZE_LARGE / 2),
                              ),
                              _buildUserAvatar()
                            ],
                          ),
                        ),
                        const SizedBox(
                            height: OBCover.normalSizeHeight +
                                OBAvatar.AVATAR_SIZE_LARGE / 2)
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: <Widget>[
                          OBTextFormField(
                            controller: _usernameController,
                            validator: (String username) {
                              if (!_formWasSubmitted) return null;
                              if (_takenUsername != null &&
                                  _takenUsername == username)
                                return 'Username @$_takenUsername is taken';
                              return _validationService
                                  .validateUserUsername(username);
                            },
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: const OBIcon(OBIcons.email),
                            ),
                          ),
                          OBTextFormField(
                            controller: _nameController,
                            validator: (String profileName) {
                              if (!_formWasSubmitted) return null;
                              return _validationService
                                  .validateUserProfileName(profileName);
                            },
                            decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: const OBIcon(OBIcons.name),
                            ),
                          ),
                          OBTextFormField(
                            controller: _urlController,
                            validator: (String profileUrl) {
                              if (!_formWasSubmitted) return null;
                              return _validationService
                                  .validateUserProfileUrl(profileUrl);
                            },
                            decoration: InputDecoration(
                              prefixIcon: const OBIcon(OBIcons.link),
                              labelText: 'Url',
                            ),
                          ),
                          OBTextFormField(
                            controller: _locationController,
                            validator: (String profileLocation) {
                              if (!_formWasSubmitted) return null;
                              return _validationService
                                  .validateUserProfileLocation(profileLocation);
                            },
                            decoration: InputDecoration(
                              labelText: 'Location',
                              prefixIcon: const OBIcon(OBIcons.location),
                            ),
                          ),
                          OBTextFormField(
                            controller: _bioController,
                            validator: (String profileBio) {
                              if (!_formWasSubmitted) return null;
                              return _validationService
                                  .validateUserProfileBio(profileBio);
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Bio',
                              prefixIcon: const OBIcon(OBIcons.bio),
                            ),
                            textInputAction: TextInputAction.newline,
                          ),
                          OBToggleField(
                            value: _followersCountVisible,
                            title: 'Followers count',
                            leading: const OBIcon(OBIcons.followers),
                            onChanged: (bool value) {
                              setState(() {
                                _followersCountVisible = value;
                              });
                            },
                            onTap: () {
                              setState(() {
                                _followersCountVisible =
                                    !_followersCountVisible;
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ));
  }

  Widget _buildNavigationBar() {
    bool newPostButtonIsEnabled = true;

    return OBThemedNavigationBar(
      leading: GestureDetector(
        child: const OBIcon(OBIcons.close),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: 'Edit profile',
      trailing: OBButton(
        isDisabled: !newPostButtonIsEnabled,
        isLoading: _requestInProgress,
        size: OBButtonSize.small,
        onPressed: _submitForm,
        child: Text('Save'),
      ),
    );
  }

  Widget _buildUserAvatar() {
    var _onPressed = () {
      _showImageBottomSheet(imageType: OBImageType.avatar);
    };

    return GestureDetector(
        onTap: _onPressed,
        child: Stack(
          children: <Widget>[
            OBAvatar(
              borderWidth: 3,
              avatarUrl: _avatarUrl,
              avatarFile: _avatarFile,
              size: OBAvatarSize.large,
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
                  onPressed: _onPressed,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildUserProfileCover() {
    var _onPressed = () {
      _showImageBottomSheet(imageType: OBImageType.cover);
    };

    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
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
                onPressed: _onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageBottomSheet({@required OBImageType imageType}) {
    ToastService toastService = OpenbookProvider.of(context).toastService;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          List<Widget> listTiles = [
            new ListTile(
              leading: new Icon(Icons.photo_library),
              title: new Text('Pick image'),
              onTap: () async {
                try {
                  var image =
                      await _imagePickerService.pickImage(imageType: imageType);

                  _onUserImageSelected(image: image, imageType: imageType);
                } on ImageTooLargeException catch (e) {
                  int limit = e.getLimitInMB();
                  toastService.error(
                      message: 'Image too large (limit: $limit MB)',
                      context: context);
                }
                Navigator.pop(context);
              },
            )
          ];

          switch (imageType) {
            case OBImageType.cover:
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
            case OBImageType.avatar:
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
            default:
              throw 'Unhandled imageType';
          }

          return Column(mainAxisSize: MainAxisSize.min, children: listTiles);
        });
  }

  void _onUserImageSelected({File image, OBImageType imageType}) {
    if (image != null) {
      switch (imageType) {
        case OBImageType.avatar:
          _setAvatarFile(image);
          break;
        case OBImageType.cover:
          _setCoverFile(image);
          break;
        default:
          throw 'Unhandled imageType';
      }
    }
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }

  void _submitForm() async {
    _formWasSubmitted = true;
    _setRequestInProgress(true);
    try {
      var username = _usernameController.text;
      bool usernameTaken = await _isUsernameTaken(username);
      if (usernameTaken) {
        _setTakenUsername(username);
        _validateForm();
        return;
      }

      await _userService.updateUser(
        avatar: _avatarFile ?? _avatarUrl ?? '',
        cover: _coverFile ?? _coverUrl ?? '',
        name: _nameController.text,
        username: _usernameController.text,
        url: _urlController.text,
        followersCountVisible: _followersCountVisible,
        bio: _bioController.text,
        location: _locationController.text,
      );
      Navigator.of(context).pop();
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
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

  Future<bool> _isUsernameTaken(String username) async {
    if (username == widget.user.username) return false;
    return _validationService.isUsernameTaken(username);
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

  void _setTakenUsername(String takenUsername) {
    setState(() {
      _takenUsername = takenUsername;
    });
  }
}
