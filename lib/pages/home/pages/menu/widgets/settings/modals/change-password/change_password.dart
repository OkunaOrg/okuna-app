import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/primary_button.dart';
import 'package:Openbook/widgets/fields/text_field.dart';
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
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentPasswordController.addListener(_validateForm);
    _newPasswordController.addListener(_validateForm);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _validationService = openbookProvider.validationService;
    _toastService = openbookProvider.toastService;
    _userService = openbookProvider.userService;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildNavigationBar(),
        body: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                OBTextField(
                  autofocus: true,
                  labelText: 'Current Password',
                  controller: _currentPasswordController,
                  validator: (String password) {
                    if (!_formWasSubmitted) return null;
                    if (_isPasswordValid != null && !_isPasswordValid) {
                      _setIsPasswordValid(true);
                      return 'Entered password was incorrect';
                    }
                    if (!_validationService.isPasswordAllowedLength(password)) {
                      return 'Passwords should be between 10 and 100 characters long';
                    }
                  },
                  hintText: 'Enter your current password',
                ),
                OBTextField(
                  autofocus: false,
                  labelText: 'New Password',
                  controller: _newPasswordController,
                  validator: (String newPassword) {
                    if (!_formWasSubmitted) return null;
                    if (!_validationService.isPasswordAllowedLength(newPassword)) {
                      return 'Please ensure password is between 10 and 100 characters long';
                    }
                  },
                  hintText: 'Enter your new password',
                ),
              ]
          ),
        )
    );
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
      middle: Text('Change password'),
      trailing: OBPrimaryButton(
        isDisabled: !newPostButtonIsEnabled,
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

  void _submitForm() async {
    _formWasSubmitted = true;
    _setRequestInProgress(true);
    try {
      var currentPassword = _currentPasswordController.text;
      var newPassword = _newPasswordController.text;
      if (!_validateForm()) return;
      bool isPasswordUpdateSuccessful = await _userService.updateUserPassword(currentPassword, newPassword);
      if (!isPasswordUpdateSuccessful) {
        _setIsPasswordValid(isPasswordUpdateSuccessful);
        _validateForm();
        return;
      }
      _toastService.success(message: 'All good! Your password has been updated', context: context);
      Navigator.of(context).pop();
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    } finally {
      _setRequestInProgress(false);
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

}