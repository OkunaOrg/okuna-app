import 'package:Openbook/provider.dart';
import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:Openbook/widgets/buttons/secondary-button.dart';
import 'package:flutter/material.dart';

class AuthPasswordStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthPasswordStepPageState();
  }
}

class AuthPasswordStepPageState extends State<AuthPasswordStepPage> {
  bool isSubmitted;
  bool passwordIsVisible;
  bool isBootstrapped;

  CreateAccountBloc createAccountBloc;
  LocalizationService localizationService;

  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    isBootstrapped = false;
    isSubmitted = false;
    passwordIsVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    localizationService = openbookProvider.localizationService;
    createAccountBloc = openbookProvider.createAccountBloc;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildWhatYourPassword(context: context),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildPasswordForm(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildPasswordError()
                  ],
                ))),
      ),
      backgroundColor: Color(0xFF383838),
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
              Expanded(child: _buildNextButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordError() {
    return StreamBuilder(
      stream: createAccountBloc.passwordFeedback,
      initialData: null,
      builder: (context, snapshot) {
        String feedback = snapshot.data;
        if (feedback == null || !isSubmitted) {
          return Container();
        }

        return Container(
          child: Text(
            feedback,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildNextButton() {
    String buttonText = localizationService.trans('AUTH.CREATE_ACC.NEXT');

    return StreamBuilder(
      stream: createAccountBloc.passwordIsValid,
      initialData: false,
      builder: (context, snapshot) {
        bool passwordIsValid = snapshot.data;

        Function onPressed;

        if (passwordIsValid) {
          onPressed = () {
            Navigator.pushNamed(context, '/auth/done_step');
          };
        } else {
          onPressed = () {
            setState(() {
              createAccountBloc.password.add(_passwordController.text);
              isSubmitted = true;
            });
          };
        }

        return OBPrimaryButton(
          isFullWidth: true,
          isLarge: true,
          child: Text(buttonText, style: TextStyle(fontSize: 18.0)),
          onPressed: onPressed,
        );
      },
    );
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
          SizedBox(
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
        SizedBox(
          height: 20.0,
        ),
        Text(whatPasswordText,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildPasswordForm() {
    // If we use StreamBuilder to build the TexField it has a weird
    // bug which places the cursor at the beginning of the label everytime
    // the stream changes. Therefore a flag is used to bootstrap initial value

    if (!isBootstrapped && createAccountBloc.hasPassword()) {
      _passwordController.text = createAccountBloc.getPassword();
      isBootstrapped = true;
    }

    return Column(
      children: <Widget>[
        Container(
          child: Row(children: <Widget>[
            new Expanded(
              child: Container(
                  color: Colors.transparent,
                  child: TextField(
                    obscureText: !passwordIsVisible,
                    autocorrect: false,
                    onChanged: (String value) {
                      createAccountBloc.password.add(value);
                    },
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                    decoration: new InputDecoration(
                      suffixIcon: GestureDetector(
                        child: Icon(passwordIsVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onTap: () {
                          _togglePasswordVisibility();
                        },
                      ),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _passwordController,
                  )),
            ),
          ]),
        ),
      ],
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      passwordIsVisible = !passwordIsVisible;
    });
  }
}
