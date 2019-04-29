import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/secondary_button.dart';
import 'package:Openbook/widgets/buttons/success_button.dart';
import 'package:Openbook/widgets/fields/checkbox_field.dart';
import 'package:flutter/material.dart';

class OBAuthLegalAgeStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBAuthLegalAgeStepPageState();
  }
}

class OBAuthLegalAgeStepPageState extends State<OBAuthLegalAgeStepPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _isAgeConfirmed;
  CreateAccountBloc _createAccountBloc;
  LocalizationService _localizationService;

  @override
  void initState() {
    _isAgeConfirmed = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _localizationService = openbookProvider.localizationService;
    _createAccountBloc = openbookProvider.createAccountBloc;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildConfirmLegalAgeText(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildLegalAgeForm(),
                  ],
                ))),
      ),
      backgroundColor: Color(0xFFFF4A6B),
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

  Widget _buildConfirmLegalAgeText() {
    return Column(
      children: <Widget>[
        SizedBox(width: 10.0),
        Text(
          '🤔',
          style: TextStyle(fontSize: 45.0, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          'One last thing...',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLegalAgeForm() {
    return Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            OBCheckboxField(
              value: _isAgeConfirmed,
              title: '',
              onTap: () {
                setState(() {
                  _isAgeConfirmed = !_isAgeConfirmed;
                  _createAccountBloc.setLegalAgeConfirmation(_isAgeConfirmed);
                });
              },
              leading: Container(
                child: Text('Are you older than 16 years?',
                    style: TextStyle(fontSize: 16.0, color: Colors.white)),
              ),
            )
          ]),
    );
  }

  Widget _buildNextButton() {
    return OBSuccessButton(
      minWidth: double.infinity,
      size: OBButtonSize.large,
      child: Text('Register', style: TextStyle(fontSize: 18.0)),
      isDisabled: !_isAgeConfirmed,
      onPressed: () {
        Navigator.pushNamed(context, '/auth/submit_step');
      },
    );
  }

  Widget _buildPreviousButton({@required BuildContext context}) {
    String buttonText = _localizationService.trans('AUTH.CREATE_ACC.PREVIOUS');

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
}
