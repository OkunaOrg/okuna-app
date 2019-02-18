import 'dart:io';

import 'package:Openbook/models/category.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/services/bottom_sheet.dart';
import 'package:Openbook/services/image_picker.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/avatars/letter_avatar.dart';
import 'package:Openbook/widgets/cover.dart';
import 'package:Openbook/widgets/fields/color_field.dart';
import 'package:Openbook/widgets/fields/community_type_field.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/fields/text_form_field.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBSaveCommunityModal extends StatefulWidget {
  final Community community;

  const OBSaveCommunityModal({this.community});

  @override
  OBSaveCommunityModalState createState() {
    return OBSaveCommunityModalState();
  }
}

class OBSaveCommunityModalState extends State<OBSaveCommunityModal> {
  UserService _userService;
  ToastService _toastService;
  ValidationService _validationService;
  BottomSheetService _bottomSheetService;
  ThemeValueParserService _themeValueParserService;

  bool _requestInProgress;
  bool _formWasSubmitted;
  bool _formValid;
  bool _isEditingExistingCommunity;
  String _takenName;

  GlobalKey<FormState> _formKey;

  TextEditingController _nameController;
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _userAdjectiveController;
  TextEditingController _usersAdjectiveController;
  TextEditingController _rulesController;
  String _color;
  CommunityType _type;
  String _avatarUrl;
  String _coverUrl;
  File _avatarFile;
  File _coverFile;

  List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _formValid = true;
    _requestInProgress = false;
    _formWasSubmitted = false;
    _nameController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _userAdjectiveController = TextEditingController();
    _usersAdjectiveController = TextEditingController();
    _rulesController = TextEditingController();
    _type = CommunityType.public;
    _categories = [];

    _formKey = GlobalKey<FormState>();
    _isEditingExistingCommunity = widget.community != null;

    if (_isEditingExistingCommunity) {
      _nameController.text = widget.community.name;
      _titleController.text = widget.community.title;
      _descriptionController.text = widget.community.description;
      _userAdjectiveController.text = widget.community.userAdjective;
      _usersAdjectiveController.text = widget.community.usersAdjective;
      _rulesController.text = widget.community.rules;
      _color = widget.community.color;
      _categories = widget.community.categories.categories;
      _type = widget.community.type;
      _avatarUrl = widget.community.avatar;
      _coverUrl = widget.community.cover;
    }

    _nameController.addListener(_updateFormValid);
    _titleController.addListener(_updateFormValid);
    _descriptionController.addListener(_updateFormValid);
    _userAdjectiveController.addListener(_updateFormValid);
    _usersAdjectiveController.addListener(_updateFormValid);
    _rulesController.addListener(_updateFormValid);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _validationService = openbookProvider.validationService;
    _bottomSheetService = openbookProvider.bottomSheetService;
    _themeValueParserService = openbookProvider.themeValueParserService;
    var themeService = openbookProvider.themeService;

    _color = _color ?? themeService.generateRandomHexColor();

    return CupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        _buildCover(),
                        Positioned(
                          left: 20,
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: (OBCover.normalSizeHeight) -
                                    (OBAvatar.AVATAR_SIZE_LARGE / 2),
                              ),
                              _buildAvatar()
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
                                textCapitalization:
                                    TextCapitalization.sentences,
                                size: OBTextFormFieldSize.medium,
                                controller: _titleController,
                                decoration: InputDecoration(
                                  labelText: 'Title',
                                  hintText: 'e.g. Travel, Photography, Gaming.',
                                  prefixIcon: const OBIcon(OBIcons.communities),
                                ),
                                validator: (String communityTitle) {
                                  return _validationService
                                      .validateCommunityTitle(communityTitle);
                                }),
                            OBTextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                size: OBTextFormFieldSize.medium,
                                controller: _nameController,
                                decoration: InputDecoration(
                                    prefixIcon: const OBIcon(OBIcons.shortText),
                                    labelText: 'Name',
                                    prefixText: '/c/',
                                    hintText:
                                        ' e.g. travel, photography, gaming.'),
                                validator: (String communityName) {
                                  if (_takenName != null &&
                                      _takenName == communityName) {
                                    return 'Community name "$_takenName" is taken';
                                  }

                                  return _validationService
                                      .validateCommunityName(communityName);
                                }),
                            OBTextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                size: OBTextFormFieldSize.medium,
                                controller: _descriptionController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                    prefixIcon: const OBIcon(
                                        OBIcons.communityDescription),
                                    labelText: 'Description',
                                    hintText: 'What is your community about?'),
                                validator: (String communityDescription) {
                                  return _validationService
                                      .validateCommunityDescription(
                                          communityDescription);
                                }),
                            OBTextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              size: OBTextFormFieldSize.medium,
                              controller: _rulesController,
                              decoration: InputDecoration(
                                  prefixIcon:
                                      const OBIcon(OBIcons.communityRules),
                                  labelText: 'Rules',
                                  hintText:
                                      'Is there something you would like your users to know?'),
                              validator: (String communityRules) {
                                return _validationService
                                    .validateCommunityRules(communityRules);
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                            ),
                            OBTextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                size: OBTextFormFieldSize.medium,
                                controller: _userAdjectiveController,
                                decoration: InputDecoration(
                                    prefixIcon:
                                        const OBIcon(OBIcons.communityMember),
                                    labelText: 'Member adjective',
                                    hintText:
                                        'e.g. traveler, photographer, gamer.'),
                                validator: (String communityUserAdjective) {
                                  return _validationService
                                      .validateCommunityUserAdjective(
                                          communityUserAdjective);
                                }),
                            OBTextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                size: OBTextFormFieldSize.medium,
                                controller: _usersAdjectiveController,
                                decoration: InputDecoration(
                                    prefixIcon:
                                        const OBIcon(OBIcons.communityMembers),
                                    labelText: 'Members adjective',
                                    hintText:
                                        'e.g. travelers, photographers, gamers.'),
                                validator: (String communityUsersAdjective) {
                                  return _validationService
                                      .validateCommunityUserAdjective(
                                          communityUsersAdjective);
                                }),
                            OBColorField(
                              initialColor: _color,
                              onNewColor: _onNewColor,
                              labelText: 'Color',
                              hintText: '(Tap to change)',
                            ),
                            OBCommunityTypeField(
                              value: _type,
                              title: 'Type',
                              hintText: '(Tap to change)',
                              onChanged: (CommunityType type) {
                                setState(() {
                                  _type = type;
                                });
                              },
                            ),
                          ],
                        )),
                  ],
                )),
          ),
        ));
  }

  Widget _buildNavigationBar() {
    Color color = _themeValueParserService.parseColor(_color);
    bool isDarkColor = _themeValueParserService.isDarkColor(color);
    Color actionsColor = isDarkColor ? Colors.white : Colors.black;

    // TODO Make this nav bar an OBColoredNavBar header which is then used by the OBCommunityNavBar

    return CupertinoNavigationBar(
        border: null,
        leading: GestureDetector(
          child: OBIcon(
            OBIcons.close,
            color: actionsColor,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actionsForegroundColor: actionsColor,
        middle: Text(
          _isEditingExistingCommunity ? 'Edit community' : 'Create community',
          style: TextStyle(color: actionsColor),
        ),
        transitionBetweenRoutes: false,
        backgroundColor: color,
        trailing: _requestInProgress
            ? OBProgressIndicator(color: actionsColor)
            : OBButton(
                isDisabled: !_formValid,
                isLoading: _requestInProgress,
                size: OBButtonSize.small,
                onPressed: _submitForm,
                child: Text(_isEditingExistingCommunity ? 'Save' : 'Create'),
              ));
  }

  Widget _buildAvatar() {
    bool hasAvatarFile = _avatarFile != null;
    bool hasAvatarUrl = _avatarUrl != null;

    Function _onPressed = hasAvatarFile ? _clearAvatarFile : _pickNewAvatar;

    Widget icon = Icon(
      hasAvatarFile ? Icons.clear : Icons.edit,
      size: 15,
    );

    Widget avatar;

    if (hasAvatarFile || hasAvatarUrl) {
      avatar = OBAvatar(
        borderWidth: 3,
        avatarUrl: _avatarUrl,
        avatarFile: _avatarFile,
        size: OBAvatarSize.large,
      );
    } else {
      avatar = OBLetterAvatar(
          size: OBAvatarSize.large,
          color: Pigment.fromString(_color),
          letter: _nameController.text.isEmpty ? 'C' : _nameController.text[0]);
    }

    return GestureDetector(
        onTap: _onPressed,
        child: Stack(
          children: <Widget>[
            avatar,
            Positioned(
              bottom: 10,
              right: 10,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 30, maxHeight: 30),
                child: FloatingActionButton(
                  heroTag: Key('editCommunityAvatar'),
                  backgroundColor: Colors.white,
                  child: icon,
                  onPressed: _onPressed,
                ),
              ),
            ),
          ],
        ));
  }

  void _pickNewAvatar() async {
    File newAvatar = await _bottomSheetService.showPhotoPicker(
        context: context, imageType: OBImageType.avatar);
    if (newAvatar != null) _setAvatarFile(newAvatar);
  }

  Widget _buildCover() {
    bool hasCoverFile = _coverFile != null;

    Function _onPressed = hasCoverFile ? _clearCoverFile : _pickNewCover;

    Widget icon = Icon(
      hasCoverFile ? Icons.clear : Icons.edit,
      size: 15,
    );

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
                heroTag: Key('editCommunityCover'),
                backgroundColor: Colors.white,
                child: icon,
                onPressed: _onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickNewCover() async {
    File newCover = await _bottomSheetService.showPhotoPicker(
        context: context, imageType: OBImageType.cover);
    if (newCover != null) _setCoverFile(newCover);
  }

  void _clearAvatarFile() {
    _setAvatarFile(null);
  }

  void _setAvatarFile(File avatarFile) {
    setState(() {
      _avatarFile = avatarFile;
    });
  }

  void _clearCoverFile() {
    _setCoverFile(null);
  }

  void _setCoverFile(File coverFile) {
    setState(() {
      _coverFile = coverFile;
    });
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }

  bool _updateFormValid() {
    if (!_formWasSubmitted) return true;
    var formValid = _validateForm();
    _setFormValid(formValid);
    return formValid;
  }

  void _submitForm() async {
    _formWasSubmitted = true;

    var formIsValid = _updateFormValid();

    if (!formIsValid) return;

    _setRequestInProgress(true);
    try {
      var communityName = _nameController.text;
      bool communityNameTaken = await _isNameTaken(communityName);

      if (communityNameTaken) {
        _setTakenName(communityName);
        _validateForm();
        return;
      }

      Community community = await (_isEditingExistingCommunity
          ? _userService.updateCommunity(widget.community,
              name: _nameController.text != widget.community.name
                  ? _nameController.text
                  : null,
              title: _titleController.text,
              description: _descriptionController.text,
              rules: _rulesController.text,
              userAdjective: _userAdjectiveController.text,
              usersAdjective: _usersAdjectiveController.text,
              categories: _categories,
              color: _color)
          : _userService.createCommunity(
              type: _type,
              name: _nameController.text,
              title: _titleController.text,
              description: _descriptionController.text,
              rules: _rulesController.text,
              userAdjective: _userAdjectiveController.text,
              usersAdjective: _usersAdjectiveController.text,
              categories: _categories,
              color: _color));

      Navigator.of(context).pop(community);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    } finally {
      _setRequestInProgress(false);
    }
  }

  Future<bool> _isNameTaken(String communityName) async {
    if (_isEditingExistingCommunity &&
        widget.community.name == _nameController.text) {
      return false;
    }
    return _validationService.isCommunityNameTaken(communityName);
  }

  void _onNewColor(String newColor) {
    _setColor(newColor);
  }

  void _setColor(String color) {
    setState(() {
      _color = color;
    });
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _setFormValid(bool formValid) {
    setState(() {
      _formValid = formValid;
    });
  }

  void _setTakenName(String takenCommunityName) {
    setState(() {
      _takenName = takenCommunityName;
    });
  }
}
