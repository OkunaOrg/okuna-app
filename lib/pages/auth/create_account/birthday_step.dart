import 'package:Openbook/blocs_provider.dart';
import 'package:Openbook/pages/auth/create_account/create_account_bloc.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:Openbook/widgets/buttons/secondary-button.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AuthBirthdayStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthBirthdayStepPageState();
  }
}

class AuthBirthdayStepPageState extends State<AuthBirthdayStepPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  CreateAccountBloc createAccountBloc;

  @override
  Widget build(BuildContext context) {
    var localizationService = LocalizationService.of(context);
    var blocsProvider = OpenbookBlocsProvider.of(context);
    createAccountBloc = blocsProvider.createAccountBloc;

    String whenBirthdayText =
        localizationService.trans('AUTH.CREATE_ACC.WHEN_BIRTHDAY');
    String birthdayPlaceholderText =
        localizationService.trans('AUTH.CREATE_ACC.BIRTHDAY_PLACEHOLDER');
    String previousText = localizationService.trans('AUTH.CREATE_ACC.PREVIOUS');
    String nextText = localizationService.trans('AUTH.CREATE_ACC.NEXT');

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildWhensYourBirthday(
                        text: whenBirthdayText, context: context),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildBirthdayForm(
                        birthdayInputPlaceholder: birthdayPlaceholderText)
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
                child: _buildPreviousButton(context: context, text: previousText),
              ),
              Expanded(child: _buildNextButton(text: nextText)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton({@required String text}) {
    return OBPrimaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Text(text, style: TextStyle(fontSize: 18.0)),
      onPressed: () {},
    );
  }

  Widget _buildPreviousButton({@required BuildContext context, @required String text}) {
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

  Widget _buildWhensYourBirthday(
      {@required String text, @required BuildContext context}) {
    return Column(
      children: <Widget>[
        Text(
          '🎂',
          style: TextStyle(fontSize: 45.0),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(text,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildBirthdayForm({@required String birthdayInputPlaceholder}) {
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
                            stream: createAccountBloc.birthdayText,
                            initialData: null,
                            builder: (context, snapshot) {
                              var textController = new TextEditingController(
                                  text: snapshot.data);

                              return TextFormField(
                                textAlign: TextAlign.center,
                                enabled: false,
                                decoration: new InputDecoration(
                                  hintText: birthdayInputPlaceholder,
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
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
