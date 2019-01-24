import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/fields/color_field.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/fields/text_form_field.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSaveConnectionsCircleModal extends StatefulWidget {
  final Circle connectionsCircle;
  final bool autofocusNameTextField;

  OBSaveConnectionsCircleModal(
      {this.connectionsCircle, this.autofocusNameTextField = false});

  @override
  OBSaveConnectionsCircleModalState createState() {
    return OBSaveConnectionsCircleModalState();
  }
}

class OBSaveConnectionsCircleModalState
    extends State<OBSaveConnectionsCircleModal> {
  static const double INPUT_COLORS_SIZE = 16;

  UserService _userService;
  ToastService _toastService;
  ValidationService _validationService;

  bool _requestInProgress;
  bool _formWasSubmitted;
  bool _formValid;
  bool _hasExistingCircle;
  String _takenConnectionsCircleName;
  List<User> _users;

  GlobalKey<FormState> _formKey;

  TextEditingController _nameController;
  String _color;

  @override
  void initState() {
    super.initState();
    _formValid = true;
    _requestInProgress = false;
    _formWasSubmitted = false;
    _nameController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _hasExistingCircle = widget.connectionsCircle != null;
    _users = _hasExistingCircle && widget.connectionsCircle.hasUsers()
        ? widget.connectionsCircle.users.users.toList()
        : [];

    if (_hasExistingCircle) {
      _nameController.text = widget.connectionsCircle.name;
      _color = widget.connectionsCircle.color;
    }

    _nameController.addListener(_updateFormValid);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _validationService = openbookProvider.validationService;
    var themeService = openbookProvider.themeService;

    _color = _color ?? themeService.generateRandomHexColor();

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: <Widget>[
                            OBTextFormField(
                              textCapitalization: TextCapitalization.sentences,
                                size: OBTextFormFieldSize.large,
                                autofocus: widget.autofocusNameTextField,
                                controller: _nameController,
                                decoration: InputDecoration(
                                    labelText: 'Name',
                                    hintText: 'e.g. Friends, Family, Work.'),
                                validator: (String connectionsCircleName) {
                                  if (!_formWasSubmitted) return null;

                                  if (_takenConnectionsCircleName != null &&
                                      _takenConnectionsCircleName ==
                                          connectionsCircleName) {
                                    return 'Circle name "$_takenConnectionsCircleName" is taken';
                                  }

                                  return _validationService
                                      .validateConnectionsCircleName(
                                          connectionsCircleName);
                                }),
                            OBColorField(
                              initialColor: _color,
                              onNewColor: _onNewColor,
                              labelText: 'Color',
                              hintText: '(Tap to change)',
                            ),
                          ],
                        )),
                    _users.length > 0
                        ? Padding(
                            padding: EdgeInsets.only(
                                left: 20, top: 20, bottom: 20.0),
                            child: const OBText(
                              'Users',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              size: OBTextSize.large,
                            ),
                          )
                        : const SizedBox(),
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
          ),
        ));
  }

  Widget _buildNavigationBar() {
    return OBNavigationBar(
        leading: GestureDetector(
          child: OBIcon(OBIcons.close),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: _hasExistingCircle ? 'Edit circle' : 'Create circle',
        trailing: OBButton(
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
      var connectionsCircleName = _nameController.text;
      bool connectionsCircleNameTaken =
          await _isConnectionsCircleNameTaken(connectionsCircleName);

      if (connectionsCircleNameTaken) {
        _setTakenConnectionsCircleName(connectionsCircleName);
        _validateForm();
        return;
      }

      Circle connectionsCircle = await (_hasExistingCircle
          ? _userService.updateConnectionsCircle(widget.connectionsCircle,
              name: _nameController.text != widget.connectionsCircle.name
                  ? _nameController.text
                  : null,
              users: _users,
              color: _color)
          : _userService.createConnectionsCircle(
              name: _nameController.text, color: _color));

      Navigator.of(context).pop(connectionsCircle);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    } finally {
      _setRequestInProgress(false);
    }
  }

  Future<bool> _isConnectionsCircleNameTaken(
      String connectionsCircleName) async {
    if (_hasExistingCircle &&
        widget.connectionsCircle.name == _nameController.text) {
      return false;
    }
    return _validationService
        .isConnectionsCircleNameTaken(connectionsCircleName);
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

  void _setTakenConnectionsCircleName(String takenConnectionsCircleName) {
    setState(() {
      _takenConnectionsCircleName = takenConnectionsCircleName;
    });
  }
}
