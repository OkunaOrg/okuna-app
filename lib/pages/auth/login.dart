import 'package:Openbook/provider.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:Openbook/widgets/buttons/secondary-button.dart';
import 'package:flutter/material.dart';

class AuthLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthLoginPageState();
  }
}

class AuthLoginPageState extends State<AuthLoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitted;
  bool _passwordIsVisible;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  LocalizationService localizationService;

  ValidationService validationService;

  @override
  void initState() {
    _isSubmitted = false;
    _passwordIsVisible = false;
    super.initState();

    _usernameController.addListener(_validateForm);

    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.removeListener(_validateForm);
    _passwordController.removeListener(_validateForm);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    localizationService = openbookProvider.localizationService;
    validationService = openbookProvider.validationService;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildHeading(context: context),
                    SizedBox(
                      height: 30.0,
                    ),
                    _buildLoginForm(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildNameError()
                  ],
                ))),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: _buildPreviousButton(context: context),
              ),
              Expanded(child: _buildContinueButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameError() {
    return Container(
      child: Text(
        'this is error text',
        style: TextStyle(color: Colors.white, fontSize: 18.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContinueButton() {
    String buttonText = localizationService.trans('AUTH.LOGIN.LOGIN');

    return OBPrimaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Text(buttonText, style: TextStyle(fontSize: 18.0)),
      onPressed: () {
        _isSubmitted = true;
        if (_validateForm()) {
          // Proceed to login
          String username = _usernameController.text;
          String password = _passwordController.text;
          print(username);
          print(password);
        }
      },
    );
  }

  Widget _buildPreviousButton({@required BuildContext context}) {
    String buttonText = localizationService.trans('AUTH.LOGIN.PREVIOUS');

    return OBSecondaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Row(
        children: <Widget>[
          Icon(Icons.arrow_back_ios),
          SizedBox(
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
    String titleText = localizationService.trans('AUTH.LOGIN.TITLE');
    String subtitleText = localizationService.trans('AUTH.LOGIN.SUBTITLE');

    return Column(
      children: <Widget>[
        Text(
          '👋',
          style: TextStyle(fontSize: 45.0, color: Colors.black),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(titleText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10.0,
        ),
        Text(subtitleText,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0)),
      ],
    );
  }

  Widget _buildLoginForm() {
    // If we use StreamBuilder to build the TexField it has a weird
    // bug which places the cursor at the beginning of the label everytime
    // the stream changes. Therefore a flag is used to bootstrap initial value

    String usernameInputLabel =
        localizationService.trans('AUTH.LOGIN.USERNAME_LABEL');

    String passwordInputLabel =
        localizationService.trans('AUTH.LOGIN.PASSWORD_LABEL');

    EdgeInsetsGeometry inputContentPadding =
        EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0);

    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(children: <Widget>[
                new Expanded(
                  child: Container(
                      color: Colors.transparent,
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
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordIsVisible,
                            validator: _validatePassword,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                child: Icon(_passwordIsVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onTap: () {
                                  _togglePasswordVisibility();
                                },
                              ),
                              contentPadding: inputContentPadding,
                              labelText: passwordInputLabel,
                              border: OutlineInputBorder(),
                            ),
                            autocorrect: false,
                          )
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

    if (value.length == 0) {
      return localizationService.trans('AUTH.LOGIN.USERNAME_EMPTY_ERROR');
    }

    if (!validationService.isUsernameAllowedLength(value)) {
      return localizationService.trans('AUTH.LOGIN.USERNAME_LENGTH_ERROR');
    }

    if (!validationService.isUsernameAllowedCharacters(value)) {
      return localizationService.trans('AUTH.LOGIN.USERNAME_CHARACTERS_ERROR');
    }
  }

  String _validatePassword(String value) {
    if (!_isSubmitted) return null;

    if (value.length == 0) {
      return localizationService.trans('AUTH.LOGIN.PASSWORD_EMPTY_ERROR');
    }

    if (!validationService.isPasswordAllowedLength(value)) {
      return localizationService.trans('AUTH.LOGIN.PASSWORD_LENGTH_ERROR');
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordIsVisible = !_passwordIsVisible;
    });
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }
}
