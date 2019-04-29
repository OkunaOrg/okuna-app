import 'package:Openbook/provider.dart';
import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/success_button.dart';
import 'package:Openbook/widgets/buttons/secondary_button.dart';
import 'package:Openbook/pages/auth/create_account/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';

class OBAuthPasswordStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBAuthPasswordStepPageState();
  }
}

class OBAuthPasswordStepPageState extends State<OBAuthPasswordStepPage> {
  bool passwordIsVisible;
  CreateAccountBloc createAccountBloc;
  LocalizationService localizationService;
  ValidationService validationService;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    passwordIsVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    localizationService = openbookProvider.localizationService;
    validationService = openbookProvider.validationService;
    createAccountBloc = openbookProvider.createAccountBloc;

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
      minWidth: double.infinity,
      size: OBButtonSize.large,
      child: Text(buttonText, style: TextStyle(fontSize: 18.0)),
      onPressed: onPressedNextStep,
    );
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }

  void onPressedNextStep() {
    bool isPasswordValid = _validateForm();
    if (isPasswordValid) {
      setState(() {
        createAccountBloc.setPassword(_passwordController.text);
        Navigator.pushNamed(context, '/auth/guidelines_step');
      });
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
                obscureText: !passwordIsVisible,
                validator: (String password) {
                  String validatePassword =
                      validationService.validateUserPassword(password);
                  if (validatePassword != null) return validatePassword;
                },
                suffixIcon: GestureDetector(
                  child: Icon(passwordIsVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onTap: () {
                    _togglePasswordVisibility();
                  },
                ),
                controller: _passwordController,
              )),
        ),
      ]),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      passwordIsVisible = !passwordIsVisible;
    });
  }
}
