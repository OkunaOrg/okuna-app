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

class OBChangeEmailModal extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return OBChangeEmailModalState();
  }

}

class OBChangeEmailModalState extends State<OBChangeEmailModal> {
  ValidationService _validationService;
  ToastService _toastService;
  UserService _userService;
  static const double INPUT_ICONS_SIZE = 16;
  static const EdgeInsetsGeometry INPUT_CONTENT_PADDING =
  EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _requestInProgress = false;
  bool _formWasSubmitted = false;
  bool _changedEmailTaken = false;
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
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
                    labelText: 'Email',
                    controller: _emailController,
                    validator: (String email) {
                      if (!_formWasSubmitted) return null;
                      if (_changedEmailTaken != null && _changedEmailTaken)
                        return 'Email is already registered';
                      if (_validationService.isQualifiedEmail(email)) {
                        return 'Please enter a valid email';
                      }
                    },
                    hintText: 'Enter your new email',
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
      middle: Text('Edit profile'),
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
      var email = _emailController.text;
      var originalEmail = _userService.getLoggedInUser().getEmail();
      User user = await _userService.updateUserEmail(email);
      if (user.getEmail() != email || originalEmail == user.getEmail()) {
        _setChangedEmailTaken(true);
        _validateForm();
        return;
      }
      _toastService.success(message: 'We\'ve sent a confirmation link to your new email address, click it to verify your new email', context: context);
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

  void _setChangedEmailTaken(bool isEmailTaken) {
    setState(() {
      _changedEmailTaken = isEmailTaken;
    });
  }
  
}