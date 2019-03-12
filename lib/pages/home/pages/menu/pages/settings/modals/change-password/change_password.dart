import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/fields/text_form_field.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBChangePasswordModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBChangePasswordModalState();
  }
}

class OBChangePasswordModalState extends State<OBChangePasswordModal> {
  ValidationService _validationService;
  ToastService _toastService;
  UserService _userService;
  static const double INPUT_ICONS_SIZE = 16;
  static const EdgeInsetsGeometry INPUT_CONTENT_PADDING =
      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _requestInProgress = false;
  bool _formWasSubmitted = false;
  bool _isPasswordValid = true;
  bool _formValid = true;
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
    _formWasSubmitted = false;
    _isPasswordValid = true;
    _formValid = true;
    _currentPasswordController.addListener(_updateFormValid);
    _newPasswordController.addListener(_updateFormValid);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _validationService = openbookProvider.validationService;
    _toastService = openbookProvider.toastService;
    _userService = openbookProvider.userService;

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    OBTextFormField(
                      size: OBTextFormFieldSize.large,
                      autofocus: true,
                      obscureText: true,
                      controller: _currentPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        hintText: 'Enter your current password',
                      ),
                      validator: (String password) {
                        if (!_formWasSubmitted) return null;
                        if (_isPasswordValid != null && !_isPasswordValid) {
                          _setIsPasswordValid(true);
                          return 'Entered password was incorrect';
                        }
                        String validatePassword =
                            _validationService.validateUserPassword(password);
                        if (validatePassword != null) return validatePassword;
                      },
                    ),
                    OBTextFormField(
                      autofocus: false,
                      obscureText: true,
                      controller: _newPasswordController,
                      size: OBTextFormFieldSize.large,
                      decoration: InputDecoration(
                          labelText: 'New Password',
                          hintText: 'Enter your new password'),
                      validator: (String newPassword) {
                        if (!_formWasSubmitted) return null;
                        if (!_validationService
                            .isPasswordAllowedLength(newPassword)) {
                          return 'Please ensure password is between 10 and 100 characters long';
                        }
                      },
                    ),
                  ]),
            ),
          ),
        ));
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
      leading: GestureDetector(
        child: const OBIcon(OBIcons.close),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: 'Change password',
      trailing: OBButton(
        isDisabled: !_formValid,
        isLoading: _requestInProgress,
        size: OBButtonSize.small,
        onPressed: _submitForm,
        child: Text('Save'),
      ),
    );
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
      var currentPassword = _currentPasswordController.text;
      var newPassword = _newPasswordController.text;
      await _userService.updateUserPassword(currentPassword, newPassword);
      _toastService.success(
          message: 'All good! Your password has been updated',
          context: context);
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
      HttpieResponse response = error.response;
      if (response.isUnauthorized()) {
        // Meaning password didnt match
        _setIsPasswordValid(false);
        _validateForm();
      }
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _setIsPasswordValid(bool isPasswordValid) {
    setState(() {
      _isPasswordValid = isPasswordValid;
    });
  }

  void _setFormValid(bool formValid) {
    setState(() {
      _formValid = formValid;
    });
  }
}
