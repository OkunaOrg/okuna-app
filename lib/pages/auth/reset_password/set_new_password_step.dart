import 'package:Openbook/provider.dart';
import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/success_button.dart';
import 'package:Openbook/widgets/buttons/secondary_button.dart';
import 'package:Openbook/pages/auth/create_account/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';

class OBAuthSetNewPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBAuthSetNewPasswordPageState();
  }
}

class OBAuthSetNewPasswordPageState extends State<OBAuthSetNewPasswordPage> {
  bool _passwordIsVisible;
  CreateAccountBloc createAccountBloc;
  LocalizationService localizationService;
  ValidationService validationService;
  UserService userService;
  ToastService toastService;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _requestInProgress;

  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _passwordIsVisible = false;
    _requestInProgress = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    localizationService = openbookProvider.localizationService;
    validationService = openbookProvider.validationService;
    createAccountBloc = openbookProvider.createAccountBloc;
    userService = openbookProvider.userService;
    toastService = openbookProvider.toastService;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildWhatYourPassword(context: context),
                    const SizedBox(
                      height: 20.0,
                    ),
                    _buildPasswordForm(),
                  ],
                ))),
      ),
      backgroundColor: Color(0xFF383838),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: _buildPreviousButton(context: context),
              ),
              Expanded(child: _buildNextButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    String buttonText = localizationService.trans('AUTH.CREATE_ACC.NEXT');

    return OBSuccessButton(
      isLoading: _requestInProgress,
      minWidth: double.infinity,
      size: OBButtonSize.large,
      child: Text(buttonText, style: TextStyle(fontSize: 18.0)),
      onPressed: onPressedNextStep,
    );
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }

  void onPressedNextStep() async {
    bool isPasswordValid = _validateForm();
    if (isPasswordValid) {
      await _verifyResetPassword(context);
    }
  }

  Future<void> _verifyResetPassword(BuildContext context) async {
    _setRequestInProgress(true);
    String newPassword = _passwordController.text;
    String passwordResetToken = createAccountBloc.getPasswordResetToken();
    try {
      await userService.verifyPasswordReset(newPassword: newPassword, passwordResetToken: passwordResetToken);
      createAccountBloc.clearAll();
      Navigator.pushNamed(context, '/auth/password_reset_success_step');
    } catch (error) {
      if (error is HttpieRequestError) {
        String errorMessage = await error.toHumanReadableMessage();
        _showErrorMessage(errorMessage);
      }
      if (error is HttpieConnectionRefusedError) {
        _showErrorMessage(localizationService.trans('AUTH.LOGIN.CONNECTION_ERROR'));
      }
    } finally {
      _setRequestInProgress(false);
    }
  }

  Widget _buildPreviousButton({@required BuildContext context}) {
    String buttonText = localizationService.trans('AUTH.CREATE_ACC.PREVIOUS');

    return OBSecondaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            buttonText,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          )
        ],
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildWhatYourPassword({@required BuildContext context}) {
    String whatPasswordText =
    localizationService.trans('AUTH.CREATE_ACC.WHAT_PASSWORD');

    return Column(
      children: <Widget>[
        Text(
          '🔒',
          style: TextStyle(fontSize: 45.0, color: Colors.white),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(whatPasswordText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        SizedBox(
          height: 10.0,
        ),
        Text('(10-100 characters)',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildPasswordForm() {

    return Form(
      key: _formKey,
      child: Row(children: <Widget>[
        new Expanded(
          child: Container(
              color: Colors.transparent,
              child: OBAuthTextField(
                autocorrect: false,
                obscureText: !_passwordIsVisible,
                validator: (String password) {
                  String validatePassword = validationService.validateUserPassword(password);
                  if (validatePassword != null) return validatePassword;
                },
                suffixIcon: GestureDetector(
                  child: Icon(_passwordIsVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onTap: () {
                    _togglePasswordVisibility();
                  },
                ),
                controller: _passwordController,
              )
          ),
        ),
      ]),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordIsVisible = !_passwordIsVisible;
    });
  }

  void _showErrorMessage(String message) {
    toastService.error(message: message, context: context);
  }


  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
