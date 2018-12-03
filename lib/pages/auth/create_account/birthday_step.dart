import 'package:Openbook/provider.dart';
import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/primary_button.dart';
import 'package:Openbook/widgets/buttons/secondary_button.dart';
import 'package:Openbook/pages/auth/create_account/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class OBAuthBirthdayStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBAuthBirthdayStepPageState();
  }
}

class OBAuthBirthdayStepPageState extends State<OBAuthBirthdayStepPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  CreateAccountBloc createAccountBloc;
  LocalizationService localizationService;

  TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);

    createAccountBloc = openbookProvider.createAccountBloc;
    localizationService = openbookProvider.localizationService;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildWhensYourBirthday(context: context),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildBirthdayForm(),
                    _buildEmailError()
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

  Widget _buildEmailError() {
    return StreamBuilder(
      stream: createAccountBloc.birthdayFeedback,
      initialData: null,
      builder: (context, snapshot) {
        var feedback = snapshot.data;
        if (feedback == null) {
          return Container();
        }

        return Container(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(feedback,
              style: TextStyle(color: Colors.white, fontSize: 18.0)),
        );
      },
    );
  }

  Widget _buildNextButton() {
    String buttonText = localizationService.trans('AUTH.CREATE_ACC.NEXT');

    return StreamBuilder(
        stream: createAccountBloc.birthdayIsValid,
        initialData: null,
        builder: (context, snapshot) {
          var data = snapshot.data;

          Function onPressed;

          if (data == null || data == false) {
            onPressed = () {
              // We want to trigger a validation error
              createAccountBloc.birthday.add(null);
            };
          } else {
            onPressed = () {
              Navigator.pushNamed(context, '/auth/name_step');
            };
          }

          return OBPrimaryButton(
            minWidth: double.infinity,
            size: OBButtonSize.large,
            child: Text(buttonText, style: TextStyle(fontSize: 18.0)),
            onPressed: onPressed,
          );
        });
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

  Widget _buildWhensYourBirthday({@required BuildContext context}) {
    String whenBirthdayText =
        localizationService.trans('AUTH.CREATE_ACC.WHEN_BIRTHDAY');

    return Column(
      children: <Widget>[
        Text(
          '🎂',
          style: TextStyle(fontSize: 45.0, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          whenBirthdayText,
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBirthdayForm() {
    String birthdayInputPlaceholder =
        localizationService.trans('AUTH.CREATE_ACC.BIRTHDAY_PLACEHOLDER');

    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(children: <Widget>[
                new Expanded(
                    child: GestureDetector(
                  onTap: () {
                    _chooseDate(context, null);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: IgnorePointer(
                        child: StreamBuilder(
                            stream: createAccountBloc.validatedBirthday,
                            initialData: null,
                            builder: (context, snapshot) {
                              textController = new TextEditingController(
                                  text: snapshot.data);

                              return OBAuthTextField(
                                enabled: false,
                                hintText: birthdayInputPlaceholder,
                                controller: textController,
                              );
                            })),
                  ),
                )),
              ]),
            ),
          ],
        ));
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    createAccountBloc.birthday.add(result);
  }
}
