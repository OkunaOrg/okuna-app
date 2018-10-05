import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:Openbook/widgets/buttons/secondary-button.dart';
import 'package:flutter/material.dart';

class AuthGetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationService = LocalizationService.of(context);
    String letsGetStartedText =
        localizationService.trans('AUTH.CREATE_ACC.LETS_GET_STARTED');
    String previousText =
        localizationService.trans('AUTH.CREATE_ACC.PREVIOUS');
    String nextText =
        localizationService.trans('AUTH.CREATE_ACC.NEXT');

    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
              child: _buildLetsGetStarted(text: letsGetStartedText))),
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
              Expanded(child: _buildNextButton(context: context, text: nextText)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLetsGetStarted({@required String text}) {
    return Column(
      children: <Widget>[
        Text(
          '🚀',
          style: TextStyle(fontSize: 45.0),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(text,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget _buildNextButton({@required BuildContext context, @required String text}) {
    return OBPrimaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Text(text, style: TextStyle(fontSize: 18.0)),
      onPressed: () {
        Navigator.pushNamed(context, '/auth/birthday_step');
      },
    );
  }

  Widget _buildPreviousButton({@required BuildContext context, @required String text}) {
    return OBSecondaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Row(
        children: <Widget>[
          Icon(Icons.arrow_back_ios),
          SizedBox(
            width: 10.0,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 18.0),
          )
        ],
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
