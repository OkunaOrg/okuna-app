import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:Openbook/widgets/buttons/secondary-button.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class AuthBirthdayStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AuthBirthdayStepPageState();
  }
}

class AuthBirthdayStepPageState extends State<AuthBirthdayStepPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var localizationService = LocalizationService.of(context);

    String whenBirthdayText =
        localizationService.trans('AUTH.CREATE_ACC.WHEN_BIRTHDAY');

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child:
              _buildWhensYourBirthday(text: whenBirthdayText, context: context),
        ),
      ),
      backgroundColor: Colors.pink,
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

  Widget _buildNextButton() {
    return OBPrimaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Text('Next', style: TextStyle(fontSize: 18.0)),
      onPressed: () {},
    );
  }

  Widget _buildPreviousButton({@required BuildContext context}) {
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
            'Previous',
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
        SizedBox(
          height: 20.0,
        ),
        Form(
            key: _formKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(children: <Widget>[
                    new Expanded(
                        child: new TextFormField(
                      //validator: (val) => isValidBirthday(val) ? null : 'Not a valid date',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                      decoration: new InputDecoration(
                        hintText: 'Enter your date of birth',
                        border: UnderlineInputBorder(),
                        labelText: 'Birthday',
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white54)
                        //filled: true,
                        //fillColor: Colors.white,
                      ),
                      //controller: _controller,
                      //keyboardType: TextInputType.datetime,
                    )),
                    new IconButton(
                      icon: new Icon(Icons.arrow_drop_down),
                      tooltip: 'Choose date',
                      onPressed: (() {
                        //_chooseDate(context, _controller.text);
                      }),
                    )
                  ]),
                ),
              ],
            ))
      ],
    );
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    _controller.text = new DateFormat.yMd().format(result);
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  bool isValidBirthday(String birthday) {
    if (birthday.isEmpty) return true;
    var d = convertToDate(birthday);
    return d != null && d.isBefore(new DateTime.now());
  }
}
