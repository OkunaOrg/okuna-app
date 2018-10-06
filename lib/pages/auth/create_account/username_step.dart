import 'package:Openbook/blocs_provider.dart';
import 'package:Openbook/pages/auth/create_account/create_account_bloc.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:Openbook/widgets/buttons/secondary-button.dart';
import 'package:flutter/material.dart';

class AuthUsernameStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthNameStepPageState();
  }
}

class AuthNameStepPageState extends State<AuthUsernameStepPage> {
  bool isSubmitted = false;
  bool isBootstrapped = false;

  CreateAccountBloc createAccountBloc;

  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var localizationService = LocalizationService.of(context);
    var blocsProvider = OpenbookBlocsProvider.of(context);
    createAccountBloc = blocsProvider.createAccountBloc;

    String whatUsernameText =
        localizationService.trans('AUTH.CREATE_ACC.WHAT_USERNAME');
    String usernamePlaceholderText =
        localizationService.trans('AUTH.CREATE_ACC.USERNAME_PLACEHOLDER');
    String previousText = localizationService.trans('AUTH.CREATE_ACC.PREVIOUS');
    String nextText = localizationService.trans('AUTH.CREATE_ACC.NEXT');
    String usernameErrorText =
        localizationService.trans('AUTH.CREATE_ACC.USERNAME_ERROR');

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildWhatYourUsername(text: whatUsernameText, context: context),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildUsernameForm(nameInputPlaceholder: usernamePlaceholderText),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildUsernameError(text: usernameErrorText)
                  ],
                ))),
      ),
      backgroundColor: Color(0xFF3286FF),
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
                child:
                    _buildPreviousButton(context: context, text: previousText),
              ),
              Expanded(child: _buildNextButton(text: nextText)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameError({@required String text}) {
    return StreamBuilder(
      stream: createAccountBloc.usernameIsValid,
      initialData: true,
      builder: (context, snapshot) {
        var data = snapshot.data;
        if (data == true || !isSubmitted) {
          return Container();
        }

        return Container(
          padding: EdgeInsets.only(top: 20.0),
          child:
              Text(text, style: TextStyle(color: Colors.white, fontSize: 18.0)),
        );
      },
    );
  }

  Widget _buildNextButton({@required String text}) {
    return StreamBuilder(
      stream: createAccountBloc.usernameIsValid,
      initialData: false,
      builder: (context, snapshot) {
        bool nameIsValid = snapshot.data;

        Function onPressed;

        if (nameIsValid) {
          onPressed = () {
            Navigator.pushNamed(context, '/auth/email_step');
          };
        } else {
          onPressed = () {
            setState(() {
              isSubmitted = true;
            });
          };
        }

        return OBPrimaryButton(
          isFullWidth: true,
          isLarge: true,
          child: Text(text, style: TextStyle(fontSize: 18.0)),
          onPressed: onPressed,
        );
      },
    );
  }

  Widget _buildPreviousButton(
      {@required BuildContext context, @required String text}) {
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
            text,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          )
        ],
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildWhatYourUsername(
      {@required String text, @required BuildContext context}) {
    return Column(
      children: <Widget>[
        Text(
          '🤔',
          style: TextStyle(fontSize: 45.0, color: Colors.white),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildUsernameForm({@required String nameInputPlaceholder}) {
    // If we use StreamBuilder to build the TexField it has a weird
    // bug which places the cursor at the beginning of the label everytime
    // the stream changes. Therefore a flag is used to bootstrap initial value

    if(!isBootstrapped){
      _usernameController.text = createAccountBloc.userRegistrationData.username;
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
                    autocorrect: false,
                    onChanged: (String value) {
                      createAccountBloc.username.add(value);
                    },
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                    decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.alternate_email),
                      hintText: nameInputPlaceholder,
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _usernameController,
                  )),
            ),
          ]),
        ),
      ],
    );
  }
}
