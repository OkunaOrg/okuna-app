import 'package:Openbook/provider.dart';
import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:Openbook/widgets/buttons/secondary-button.dart';
import 'package:Openbook/pages/auth/create_account/widgets/auth-text-field.dart';
import 'package:flutter/material.dart';

class AuthNameStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthNameStepPageState();
  }
}

class AuthNameStepPageState extends State<AuthNameStepPage> {
  bool isSubmitted;
  bool isBootstrapped;

  CreateAccountBloc createAccountBloc;
  LocalizationService localizationService;

  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    isBootstrapped = false;
    isSubmitted = false;
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
                    _buildWhatYourName(context: context),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildNameForm(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildNameError()
                  ],
                ))),
      ),
      backgroundColor: Color(0xFF9013FE),
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
    return StreamBuilder(
      stream: createAccountBloc.nameFeedback,
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
      stream: createAccountBloc.nameIsValid,
      initialData: false,
      builder: (context, snapshot) {
        bool nameIsValid = snapshot.data;

        Function onPressed;

        if (nameIsValid) {
          onPressed = () {
            Navigator.pushNamed(context, '/auth/username_step');
          };
        } else {
          onPressed = () {
            setState(() {
              createAccountBloc.name.add(_nameController.text);
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

  Widget _buildWhatYourName({@required BuildContext context}) {
    String whatNameText =
        localizationService.trans('AUTH.CREATE_ACC.WHAT_NAME');

    return Column(
      children: <Widget>[
        Text(
          '📛',
          style: TextStyle(fontSize: 45.0, color: Colors.white),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(whatNameText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildNameForm() {
    // If we use StreamBuilder to build the TexField it has a weird
    // bug which places the cursor at the beginning of the label everytime
    // the stream changes. Therefore a flag is used to bootstrap initial value

    if (!isBootstrapped && createAccountBloc.hasName()) {
      _nameController.text = createAccountBloc.getName();
      isBootstrapped = true;
    }

    String nameInputPlaceholder =
        localizationService.trans('AUTH.CREATE_ACC.NAME_PLACEHOLDER');

    return Column(
      children: <Widget>[
        Container(
          child: Row(children: <Widget>[
            new Expanded(
              child: Container(
                  color: Colors.transparent,
                  child: AuthTextField(
                    autocorrect: false,
                    onChanged: (String value) {
                      createAccountBloc.name.add(value);
                    },
                    hintText: nameInputPlaceholder,
                    controller: _nameController,
                  )),
            ),
          ]),
        ),
      ],
    );
  }
}
