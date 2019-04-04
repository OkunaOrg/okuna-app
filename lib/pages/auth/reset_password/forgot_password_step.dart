import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/success_button.dart';
import 'package:Openbook/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';

class OBAuthForgotPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBAuthForgotPasswordPageState();
  }
}

class OBAuthForgotPasswordPageState extends State<OBAuthForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitted;
  String _errorFeedback;
  bool _requestInProgress;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  LocalizationService _localizationService;
  ValidationService _validationService;
  UserService _userService;

  @override
  void initState() {
    super.initState();

    _requestInProgress = false;
    _isSubmitted = false;

    _usernameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.removeListener(_validateForm);
    _emailController.removeListener(_validateForm);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _localizationService = openbookProvider.localizationService;
    _validationService = openbookProvider.validationService;
    _userService = openbookProvider.userService;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildHeading(context: context),
                    const SizedBox(
                      height: 30.0,
                    ),
                    _buildRequestResetPasswordForm(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    _buildErrorFeedback()
                  ],
                ))),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: _buildPreviousButton(context: context),
              ),
              Expanded(child: _buildContinueButton(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorFeedback() {
    if (_errorFeedback == null) return const SizedBox();

    return SizedBox(
      child: Text(
        _errorFeedback,
        style: TextStyle(fontSize: 16.0, color: Colors.deepOrange),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    String buttonText = _localizationService.trans('AUTH.LOGIN.LOGIN');

    return OBSuccessButton(
      isLoading: _requestInProgress,
      minWidth: double.infinity,
      size: OBButtonSize.large,
      child: Text(buttonText, style: TextStyle(fontSize: 18.0)),
      onPressed: () async {
        _isSubmitted = true;
        if (_validateForm()) {
          await _requestPasswordReset(context);
        }
      },
    );
  }

  Future<void> _requestPasswordReset(BuildContext context) async {
    _setRequestInProgress(true);
    String username = _validateUsername(_usernameController.text) == null ?  _usernameController.text : '';
    String email;
    if (username == '') {
      email = _validateEmail(_emailController.text) == null ?  _emailController.text : '';
    }
    try {
      await _userService.requestPasswordReset(username: username, email: email);
      Navigator.pushNamed(context, '/auth/verify_reset_password_link_step');
    } catch (error) {
      if (error is HttpieRequestError) {
        String errorMessage = await error.toHumanReadableMessage();
        _setErrorFeedback(errorMessage);
      }
      if (error is HttpieConnectionRefusedError) {
        _setErrorFeedback(
            _localizationService.trans('AUTH.LOGIN.CONNECTION_ERROR'));
      }
    } finally {
      _setRequestInProgress(false);
    }
  }

  Widget _buildPreviousButton({@required BuildContext context}) {
    String buttonText = _localizationService.trans('AUTH.LOGIN.PREVIOUS');

    return OBSecondaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Row(
        children: <Widget>[
          Icon(Icons.arrow_back_ios),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            buttonText,
            style: TextStyle(fontSize: 18.0),
          )
        ],
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildHeading({@required BuildContext context}) {
    String titleText = _localizationService.trans('AUTH.LOGIN.FORGOT_PASSWORD');
    String subtitleText = _localizationService.trans('AUTH.LOGIN.FORGOT_PASSWORD_SUBTITLE');

    return Column(
      children: <Widget>[
        Text(
          '😬',
          style: TextStyle(fontSize: 45.0, color: Colors.black),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(titleText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 10.0,
        ),
        Text(subtitleText,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0)),
      ],
    );
  }

  Widget _buildRequestResetPasswordForm() {
    // If we use StreamBuilder to build the TexField it has a weird
    // bug which places the cursor at the beginning of the label everytime
    // the stream changes. Therefore a flag is used to bootstrap initial value

    String usernameInputLabel =
    _localizationService.trans('AUTH.LOGIN.USERNAME_LABEL');

    String emailInputLabel =
    _localizationService.trans('AUTH.LOGIN.EMAIL_LABEL');

    String orText =
    _localizationService.trans('AUTH.LOGIN.OR_TEXT');

    EdgeInsetsGeometry inputContentPadding =
    EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0);

    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              child: Row(children: <Widget>[
                new Expanded(
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _usernameController,
                            validator: _validateUsername,
                            decoration: InputDecoration(
                              contentPadding: inputContentPadding,
                              labelText: usernameInputLabel,
                              border: OutlineInputBorder(),
                            ),
                            autocorrect: false,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            height: 20.0,
                            child: Text(orText),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: _emailController,
                            validator: _validateEmail,
                            decoration: InputDecoration(
                              contentPadding: inputContentPadding,
                              labelText: emailInputLabel,
                              border: OutlineInputBorder(),
                            ),
                            autocorrect: false,
                          ),
                        ],
                      )),
                ),
              ]),
            ),
          ],
        ));
  }

  String _validateUsername(String value) {
    if (!_isSubmitted) return null;
    if (_emailController.text.length > 0 && value == '') {
      return null;
    }
    return _validationService.validateUserUsername(value);
  }

  String _validateEmail(String value) {
    if (!_isSubmitted) return null;
    if (_usernameController.text.length > 0) {
      return null;
    }
    return _validationService.validateUserEmail(value);
  }

  bool _validateForm() {
    if (_errorFeedback != null) {
      _setErrorFeedback(null);
    }
    return _formKey.currentState.validate();
  }

  void _setErrorFeedback(String feedback) {
    setState(() {
      _errorFeedback = feedback;
    });
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
