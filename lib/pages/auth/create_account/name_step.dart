import 'package:Openbook/blocs_provider.dart';
import 'package:Openbook/pages/auth/create_account/create_account_bloc.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:Openbook/widgets/buttons/secondary-button.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AuthNameStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthNameStepPageState();
  }
}

class AuthNameStepPageState extends State<AuthNameStepPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  CreateAccountBloc createAccountBloc;

  @override
  Widget build(BuildContext context) {
    var localizationService = LocalizationService.of(context);
    var blocsProvider = OpenbookBlocsProvider.of(context);
    createAccountBloc = blocsProvider.createAccountBloc;

    String whatNameText =
        localizationService.trans('AUTH.CREATE_ACC.WHAT_NAME');
    String namePlaceholderText =
        localizationService.trans('AUTH.CREATE_ACC.NAME_PLACEHOLDER');
    String previousText = localizationService.trans('AUTH.CREATE_ACC.PREVIOUS');
    String nextText = localizationService.trans('AUTH.CREATE_ACC.NEXT');

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildWhatYourName(
                        text: whatNameText, context: context),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildNameForm(
                        nameInputPlaceholder: namePlaceholderText)
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

  Widget _buildWhatYourName(
      {@required String text, @required BuildContext context}) {
    return Column(
      children: <Widget>[
        Text(
          '📛',
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

  Widget _buildNameForm({@required String nameInputPlaceholder}) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(children: <Widget>[
                new Expanded(
                    child: GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    color: Colors.transparent,
                    child: IgnorePointer(
                        child: StreamBuilder(
                            stream: createAccountBloc.validatedName,
                            initialData: null,
                            builder: (context, snapshot) {
                              var textController = new TextEditingController(
                                  text: snapshot.data);

                              return TextFormField(
                                textAlign: TextAlign.center,
                                enabled: false,
                                decoration: new InputDecoration(
                                  hintText: nameInputPlaceholder,
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
}
