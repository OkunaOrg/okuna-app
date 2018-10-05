import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:Openbook/widgets/buttons/secondary-button.dart';
import 'package:flutter/material.dart';

class AuthSplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationService = LocalizationService.of(context);
    String gotAccountText = localizationService.trans('AUTH.GOT_ACCOUNT');
    String createAccountText = localizationService.trans('AUTH.CREATE_ACCOUNT');
    String loginText = localizationService.trans('AUTH.LOGIN');
    String orText = localizationService.trans('AUTH.OR');

    return Scaffold(
        body: Container(
            child: Center(
                child: SingleChildScrollView(
                    child: Row(
              children: <Widget>[
                Expanded(
                    child: Column(
                  children: <Widget>[
                    _buildLogo(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildHeadline(localizationService),
                    SizedBox(height: 40.0),
                    Container(
                      padding: EdgeInsets.all(18.0),
                      child: Column(
                        children: <Widget>[
                          _buildGotAccount(gotAccountText),
                          SizedBox(height: 20.0),
                          _buildLoginButton(loginText),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: _buildOr(orText),
                          ),
                          _buildCreateAccountButton(createAccountText)
                        ],
                      ),
                    ),
                  ],
                ))
              ],
            ))),
            decoration: _buildSplashScreenDecoration()));
  }

  Widget _buildHeadline(LocalizationService localizationService) {
    String headline = localizationService.trans('AUTH.HEADLINE');

    return Text(
      headline,
      style: TextStyle(fontSize: 18.0),
    );
  }

  BoxDecoration _buildSplashScreenDecoration() {
    return new BoxDecoration(
        image: new DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.1), BlendMode.dstATop),
            image: new AssetImage('assets/images/splash-background.jpg'),
            fit: BoxFit.cover));
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/openbook-logo.png',
      width: 200.0,
    );
  }

  Widget _buildGotAccount(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 18.0),
    );
  }

  Widget _buildOr(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 18.0),
    );
  }

  Widget _buildLoginButton(String text) {
    return OBPrimaryButton(
        isLarge: true,
        isFullWidth: true,
        child: Text(
          text,
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () {});
  }

  Widget _buildCreateAccountButton(String text) {
    return OBSecondaryButton(
        isLarge: true,
        isFullWidth: true,
        child: Text(
          text,
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () {});
  }
}
