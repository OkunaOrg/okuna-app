import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';

import '../../../provider.dart';
import 'blocs/create_account.dart';

class OBAuthRegisterTokenInvalidPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    CreateAccountBloc createAccountBloc = openbookProvider.createAccountBloc;
    LocalizationService localizationService = openbookProvider
        .localizationService;

    String oopsText = localizationService.auth__create_acc__invalid_token_title;
    String previousText = localizationService.auth__create_acc__previous;

    return StreamBuilder(
        stream: createAccountBloc.tokenValidationErrorFeedback,
        initialData: null,
        builder: (BuildContext builder, snapshot) {

          String errorText = snapshot.data ?? '';

          return Scaffold(
            backgroundColor: Color(0xFF151726),
            body: DecoratedBox(
              decoration: _buildDecoration(),
              child: Center(
                  child: SingleChildScrollView(
                      child: _buildErrorBlock(
                          titleText: oopsText, errorText: errorText))),
            ),
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
                      child:
                      _buildPreviousButton(
                          context: context, text: previousText),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildErrorBlock({@required String errorText, @required String titleText}) {
    return Column(
      children: <Widget>[
        Text(
          '😬',
          style: TextStyle(fontSize: 45.0, color: Colors.white),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(titleText,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        SizedBox(
          height: 20.0,
        ),
        Text(errorText,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white))
      ],
    );
  }

  BoxDecoration _buildDecoration() {
    return new BoxDecoration(
        image: new DecorationImage(
            image: new AssetImage('assets/images/pixel-universe.jpg'),
            fit: BoxFit.cover));
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
          const SizedBox(
            width: 10.0,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          )
        ],
      ),
      onPressed: () {
        Navigator.of(context).
        pushNamedAndRemoveUntil('/auth', (Route<dynamic> route) => false);
      },
    );
  }
}
