import 'package:Openbook/services/localization.dart';
import 'package:flutter/material.dart';

class AuthSplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
                child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildLogo(),
                  SizedBox(
                    height: 10.0,
                  ),
                  //_buildHeadline(context)
                ],
              ),
            )),
            decoration: _buildSplashScreenDecoration()));
  }

  Widget _buildHeadline(BuildContext context) {
    String headline = LocalizationService.of(context).trans('headline');

    return Text(headline);
  }

  BoxDecoration _buildSplashScreenDecoration() {
    return new BoxDecoration(
        image: new DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: new AssetImage('assets/images/splash-background.jpg'),
            fit: BoxFit.cover));
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/openbook-logo.png',
      width: 200.0,
    );
  }
}
