import 'package:Openbook/provider.dart';
import 'package:Openbook/services/localization.dart';
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
  bool isSubmitted;

  LocalizationService localizationService;

  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    isSubmitted = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    localizationService = openbookProvider.localizationService;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildWhatYourName(context: context),
                    SizedBox(
                      height: 20.0,
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
              Expanded(child: _buildNextButton()),
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

  Widget _buildNextButton() {
    String buttonText = localizationService.trans('AUTH.LOGIN.LOGIN');

    return OBPrimaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Text(buttonText, style: TextStyle(fontSize: 18.0)),
      onPressed: (){

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
          Icon(
            Icons.arrow_back_ios
          ),
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

  Widget _buildWhatYourName({@required BuildContext context}) {
    String headerText =
        localizationService.trans('AUTH.LOGIN.TITLE');

    return Column(
      children: <Widget>[
        Text(
          '👋',
          style: TextStyle(fontSize: 45.0, color: Colors.black),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(headerText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildLoginForm() {
    // If we use StreamBuilder to build the TexField it has a weird
    // bug which places the cursor at the beginning of the label everytime
    // the stream changes. Therefore a flag is used to bootstrap initial value

    String usernameInputPlaceholder =
        localizationService.trans('AUTH.LOGIN.USERNAME_PLACEHOLDER');

    String passwordInputPlaceholder =
        localizationService.trans('AUTH.LOGIN.PASSWORD_PLACEHOLDER');

    return Column(
      children: <Widget>[
        Container(
          child: Row(children: <Widget>[
            new Expanded(
              child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        autocorrect: false,
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        decoration: new InputDecoration(
                          hintText: usernameInputPlaceholder,
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: _usernameController,
                      ),
                      TextField(
                        autocorrect: false,
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        decoration: new InputDecoration(
                          hintText: passwordInputPlaceholder,
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: _usernameController,
                      )
                    ],
                  )),
            ),
          ]),
        ),
      ],
    );
  }
}
