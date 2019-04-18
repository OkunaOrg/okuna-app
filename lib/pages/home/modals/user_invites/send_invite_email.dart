import 'package:Openbook/models/user_invite.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/fields/text_form_field.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSendUserInviteEmailModal extends StatefulWidget {
  final UserInvite userInvite;
  final bool autofocusEmailTextField;

  OBSendUserInviteEmailModal(
      {this.userInvite, this.autofocusEmailTextField = false});

  @override
  OBSendUserInviteEmailModalState createState() {
    return OBSendUserInviteEmailModalState();
  }
}

class OBSendUserInviteEmailModalState
    extends State<OBSendUserInviteEmailModal> {

  UserService _userService;
  ToastService _toastService;
  ValidationService _validationService;

  bool _requestInProgress;
  bool _formWasSubmitted;
  bool _formValid;

  GlobalKey<FormState> _formKey;

  TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _formValid = true;
    _requestInProgress = false;
    _formWasSubmitted = false;
    _emailController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    if (widget.userInvite.email != null) {
      _emailController.text = widget.userInvite.email;
    }

    _emailController.addListener(_updateFormValid);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _validationService = openbookProvider.validationService;

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
                                textCapitalization:
                                TextCapitalization.sentences,
                                size: OBTextFormFieldSize.large,
                                autofocus: widget.autofocusEmailTextField,
                                controller: _emailController,
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'e.g. janedoe@email.com'),
                                validator: (String email) {
                                  if (!_formWasSubmitted) return null;
                                  return _validationService.validateUserEmail(email);
                                }),
                          ],
                        )),
                  ],
                )),
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
        title: 'Email invite',
        trailing: OBButton(
          isDisabled: !_formValid,
          isLoading: _requestInProgress,
          size: OBButtonSize.small,
          onPressed: _submitForm,
          child: Text('Send'),
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
      await _userService.sendUserInviteEmail(widget.userInvite, _emailController.text);
      _showUserInviteSent();
      Navigator.of(context).pop();
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _showUserInviteSent() {
    _toastService.success(message: 'Invite email sent', context: context);
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

}
