import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/modals/save_follows_list/pages/pick_follows_list_emoji.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/primary_button.dart';
import 'package:Openbook/widgets/fields/emoji_field.dart';
import 'package:Openbook/widgets/fields/text_field.dart';
import 'package:Openbook/widgets/follows_list_icon.dart';
import 'package:Openbook/widgets/routes/slide_right_route.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSaveFollowsListModal extends StatefulWidget {
  final FollowsList followsList;
  final bool autofocusNameTextField;

  OBSaveFollowsListModal(
      {this.followsList, this.autofocusNameTextField = false});

  @override
  OBSaveFollowsListModalState createState() {
    return OBSaveFollowsListModalState();
  }
}

class OBSaveFollowsListModalState extends State<OBSaveFollowsListModal> {
  static const double INPUT_EMOJIS_SIZE = 16;

  UserService _userService;
  ToastService _toastService;
  ValidationService _validationService;

  bool _requestInProgress;
  bool _formWasSubmitted;
  bool _formValid;
  bool _hasExistingList;
  String _takenFollowsListName;
  List<User> _users;

  GlobalKey<FormState> _formKey;

  TextEditingController _nameController;
  Emoji _emoji;

  @override
  void initState() {
    super.initState();
    _formValid = true;
    _requestInProgress = false;
    _formWasSubmitted = false;
    _nameController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _hasExistingList = widget.followsList != null;
    _users = _hasExistingList && widget.followsList.hasUsers()
        ? widget.followsList.users.users.toList()
        : [];

    if (_hasExistingList) {
      _nameController.text = widget.followsList.name;
      _emoji = widget.followsList.emoji;
    }

    _nameController.addListener(_updateFormValid);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _validationService = openbookProvider.validationService;

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
                  OBTextField(
                      autofocus: widget.autofocusNameTextField,
                      controller: _nameController,
                      labelText: 'Name',
                      hintText: 'e.g. Travel, Photography',
                      validator: (String followsListName) {
                        if (!_formWasSubmitted) return null;

                        if (_takenFollowsListName != null &&
                            _takenFollowsListName == followsListName) {
                          return 'List name "$_takenFollowsListName" is taken';
                        }

                        return _validationService
                            .validateFollowsListName(followsListName);
                      }),
                  OBEmojiField(
                      emoji: _emoji,
                      onEmojiFieldTapped: (Emoji emoji) =>
                          _onWantsToPickEmoji(),
                      labelText: 'Emoji',
                      errorText: _formWasSubmitted && _emoji == null
                          ? 'Emoji is required'
                          : null),
                  Column(
                      children: _users.map((User user) {
                    return OBUserTile(
                      user,
                      showFollowing: false,
                      onUserTileDeleted: (User user) {
                        setState(() {
                          _users.remove(user);
                        });
                      },
                    );
                  }).toList())
                ],
              )),
        ));
  }

  Widget _buildNavigationBar() {
    return OBNavigationBar(
        leading: GestureDetector(
          child: Icon(Icons.close, color: Colors.black87),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: _hasExistingList ? 'Edit list' : 'Create list',
        trailing: OBPrimaryButton(
          isDisabled: !_formValid,
          isLoading: _requestInProgress,
          size: OBButtonSize.small,
          onPressed: _submitForm,
          child: Text('Save'),
        ));
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }

  bool _updateFormValid() {
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
      var followsListName = _nameController.text;
      bool followsListNameTaken =
          await _isFollowsListNameTaken(followsListName);

      if (followsListNameTaken) {
        _setTakenFollowsListName(followsListName);
        _validateForm();
        return;
      }

      FollowsList followsList = await (_hasExistingList
          ? _userService.updateFollowsList(widget.followsList,
              name: _nameController.text != widget.followsList.name
                  ? _nameController.text
                  : null,
              users: _users,
              emoji: _emoji)
          : _userService.createFollowsList(
              name: _nameController.text, emoji: _emoji));

      Navigator.of(context).pop(followsList);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    } finally {
      _setRequestInProgress(false);
    }
  }

  Future<bool> _isFollowsListNameTaken(String followsListName) async {
    if (_hasExistingList && widget.followsList.name == _nameController.text) {
      return false;
    }
    return _validationService.isFollowsListNameTaken(followsListName);
  }

  void _onWantsToPickEmoji() async {
    Emoji pickedEmoji = await Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSlidePickFollowsListEmojiPage'),
            widget: OBPickFollowsListEmojiPage()));

    if (pickedEmoji != null) _onPickedEmoji(pickedEmoji);
  }

  void _onPickedEmoji(Emoji pickedEmoji) {
    _setEmoji(pickedEmoji);
  }

  void _setEmoji(Emoji emoji) {
    setState(() {
      _emoji = emoji;
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

  void _setTakenFollowsListName(String takenFollowsListName) {
    setState(() {
      _takenFollowsListName = takenFollowsListName;
    });
  }
}
