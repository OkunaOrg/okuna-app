import 'package:Openbook/provider.dart';
import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/success_button.dart';
import 'package:Openbook/widgets/buttons/secondary_button.dart';
import 'package:Openbook/pages/auth/create_account/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';

class OBAuthEmailStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBAuthEmailStepPageState();
  }
}

class OBAuthEmailStepPageState extends State<OBAuthEmailStepPage> {
  bool isSubmitted;
  bool isBootstrapped;
  bool emailCheckInProgress;

  CreateAccountBloc createAccountBloc;
  LocalizationService localizationService;

  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    isBootstrapped = false;
    isSubmitted = false;
    emailCheckInProgress = false;
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
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildWhatYourEmail(context: context),
                    const SizedBox(
                      height: 20.0,
                    ),
                    _buildEmailForm(),
                    const SizedBox(
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
        child: Padding(
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
          return const SizedBox();
        }

        return SizedBox(
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
      isLoading: emailCheckInProgress,
      child: Text(buttonText, style: TextStyle(fontSize: 18.0)),
      onPressed: () {
        setState(() {
          emailCheckInProgress = true;
          isSubmitted = true;
          createAccountBloc
              .setEmail(_emailController.text)
              .then((bool emailWasSet) {
            _setEmailCheckInProgress(false);
            if (emailWasSet) {
              Navigator.pushNamed(context, '/auth/password_step');
            }
          }).catchError((error) {
            _setEmailCheckInProgress(false);
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

  Widget _buildWhatYourEmail({@required BuildContext context}) {
    String whatEmailText =
        localizationService.trans('AUTH.CREATE_ACC.WHAT_EMAIL');

    return Column(
      children: <Widget>[
        Text(
          '💌',
          style: TextStyle(fontSize: 45.0, color: Colors.white),
        ),
        const SizedBox(
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

    if (!isBootstrapped && createAccountBloc.hasEmail()) {
      _emailController.text = createAccountBloc.getEmail();
      isBootstrapped = true;
    }

    String emailInputPlaceholder =
        localizationService.trans('AUTH.CREATE_ACC.EMAIL_PLACEHOLDER');

    return Column(
      children: <Widget>[
        SizedBox(
          child: Row(children: <Widget>[
            new Expanded(
              child: Container(
                  color: Colors.transparent,
                  child: OBAuthTextField(
                    hintText: emailInputPlaceholder,
                    autocorrect: false,
                    onChanged: (String value) {
                      createAccountBloc.clearEmail();
                    },
                    controller: _emailController,
                  )),
            ),
          ]),
        ),
      ],
    );
  }

  void _setEmailCheckInProgress(bool newEmailCheckInProgress) {
    setState(() {
      emailCheckInProgress = newEmailCheckInProgress;
    });
  }
}
