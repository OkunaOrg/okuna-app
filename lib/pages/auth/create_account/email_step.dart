import 'package:Openbook/provider.dart';
import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:Openbook/widgets/buttons/secondary-button.dart';
import 'package:flutter/material.dart';

class AuthEmailStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthEmailStepPageState();
  }
}

class AuthEmailStepPageState extends State<AuthEmailStepPage> {
  bool isSubmitted = false;
  bool isBootstrapped = false;

  CreateAccountBloc createAccountBloc;
  LocalizationService localizationService;

  TextEditingController _emailController = TextEditingController();

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
                    _buildWhatYourEmail(context: context),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildEmailForm(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildEmailError()
                  ],
                ))),
      ),
      backgroundColor: Color(0xFFFF3939),
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

  Widget _buildEmailError() {
    return StreamBuilder(
      stream: createAccountBloc.emailFeedback,
      initialData: null,
      builder: (context, snapshot) {
        String feedback = snapshot.data;
        if (feedback == null || !isSubmitted) {
          return Container();
        }

        return Container(
          child: Text(feedback,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18.0)),
        );
      },
    );
  }

  Widget _buildNextButton() {
    String buttonText = localizationService.trans('AUTH.CREATE_ACC.NEXT');

    return StreamBuilder(
      stream: createAccountBloc.emailIsValid,
      initialData: false,
      builder: (context, snapshot) {
        bool emailIsValid = snapshot.data;

        Function onPressed;

        if (emailIsValid) {
          onPressed = () {
            Navigator.pushNamed(context, '/auth/useremail_step');
          };
        } else {
          onPressed = () {
            setState(() {
              createAccountBloc.email.add(_emailController.text);
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

  Widget _buildWhatYourEmail({@required BuildContext context}) {
    String whatEmailText =
        localizationService.trans('AUTH.CREATE_ACC.WHAT_EMAIL');

    return Column(
      children: <Widget>[
        Text(
          '💌',
          style: TextStyle(fontSize: 45.0, color: Colors.white),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(whatEmailText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildEmailForm() {
    // If we use StreamBuilder to build the TexField it has a weird
    // bug which places the cursor at the beginning of the label everytime
    // the stream changes. Therefore a flag is used to bootstrap initial value

    if (!isBootstrapped) {
      _emailController.text =
          createAccountBloc.userRegistrationData.email;
      isBootstrapped = true;
    }

    String emailInputPlaceholder =
        localizationService.trans('AUTH.CREATE_ACC.EMAIL_PLACEHOLDER');

    return Column(
      children: <Widget>[
        Container(
          child: Row(children: <Widget>[
            new Expanded(
              child: Container(
                  color: Colors.transparent,
                  child: TextField(
                    autocorrect: false,
                    onChanged: (String value) {
                      createAccountBloc.email.add(value);
                    },
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                    decoration: new InputDecoration(
                      hintText: emailInputPlaceholder,
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _emailController,
                  )),
            ),
          ]),
        ),
      ],
    );
  }
}
