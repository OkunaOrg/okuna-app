import 'package:Openbook/provider.dart';
import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/success_button.dart';
import 'package:Openbook/widgets/buttons/secondary_button.dart';
import 'package:Openbook/pages/auth/create_account/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';

class OBAuthUsernameStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBAuthUsernameStepPageState();
  }
}

class OBAuthUsernameStepPageState extends State<OBAuthUsernameStepPage> {
  bool isSubmitted;
  bool isBootstrapped;
  bool usernameCheckInProgress;

  CreateAccountBloc createAccountBloc;
  LocalizationService localizationService;

  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    isBootstrapped = false;
    isSubmitted = false;
    usernameCheckInProgress = false;
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
                    _buildWhatYourUsername(context: context),
                    const SizedBox(
                      height: 20.0,
                    ),
                    _buildUsernameForm(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    _buildUsernameError()
                  ],
                ))),
      ),
      backgroundColor: Color(0xFF439AFB),
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

  Widget _buildUsernameError() {
    return StreamBuilder(
      stream: createAccountBloc.usernameFeedback,
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

    return OBSuccessButton(
      minWidth: double.infinity,
      size: OBButtonSize.large,
      isLoading: usernameCheckInProgress,
      child: Text(buttonText, style: TextStyle(fontSize: 18.0)),
      onPressed: () {
        setState(() {
          usernameCheckInProgress = true;
          isSubmitted = true;
          createAccountBloc
              .setUsername(_usernameController.text)
              .then((bool usernameWasSet) {
            _setUsernameCheckInProgress(false);
            if (usernameWasSet) {
              Navigator.pushNamed(context, '/auth/email_step');
            }
          }).catchError((error) {
            _setUsernameCheckInProgress(false);
          });
        });
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

  Widget _buildWhatYourUsername({@required BuildContext context}) {
    String whatUsernameText =
        localizationService.trans('AUTH.CREATE_ACC.WHAT_USERNAME');

    return Column(
      children: <Widget>[
        Text(
          '🧙',
          style: TextStyle(fontSize: 45.0, color: Colors.white),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(whatUsernameText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildUsernameForm() {
    // If we use StreamBuilder to build the TexField it has a weird
    // bug which places the cursor at the beginning of the label everytime
    // the stream changes. Therefore a flag is used to bootstrap initial value

    if (!isBootstrapped && createAccountBloc.hasUsername()) {
      _usernameController.text = createAccountBloc.getUsername();
      isBootstrapped = true;
    }

    String usernameInputPlaceholder =
        localizationService.trans('AUTH.CREATE_ACC.USERNAME_PLACEHOLDER');

    return Column(
      children: <Widget>[
        Container(
          child: Row(children: <Widget>[
            new Expanded(
              child: Container(
                  color: Colors.transparent,
                  child: OBAuthTextField(
                    autocorrect: false,
                    onChanged: (String value) {
                      createAccountBloc.clearUsername();
                    },
                    prefixIcon: Icon(Icons.alternate_email),
                    hintText: usernameInputPlaceholder,
                    controller: _usernameController,
                  )),
            ),
          ]),
        ),
      ],
    );
  }

  void _setUsernameCheckInProgress(bool newUsernameCheckInProgress) {
    setState(() {
      usernameCheckInProgress = newUsernameCheckInProgress;
    });
  }
}
