import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:Openbook/widgets/buttons/secondary-button.dart';
import 'package:flutter/material.dart';

class AuthSplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthSplashPageState();
  }
}

class AuthSplashPageState extends State<AuthSplashPage> {
  LocalizationService localizationService;
  CreateAccountBloc createAccountBloc;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    localizationService = openbookProvider.localizationService;
    createAccountBloc = openbookProvider.createAccountBloc;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: new AssetImage('assets/images/splash-background.png'),
                fit: BoxFit.cover)),
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Center(child: SingleChildScrollView(child: _buildLogo())),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: Colors.white,
      elevation: 0.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: _buildCreateAccountButton(context: context)),
            Expanded(
              child: _buildLoginButton(context: context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {

    String headlineText = localizationService.trans('AUTH.HEADLINE');


    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/openbook-o-logo.png', height: 35.0, width: 35.0,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              width: 2.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(100.0)
              ),
            ),
            Text('Open',
                style: TextStyle(
                  fontSize: 38.0,
                  fontWeight: FontWeight.bold,
                  //color: Colors.white
                )),
            Text('book',
                style: TextStyle(
                  fontSize: 38.0,
                  //color: Colors.white
                )),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(headlineText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              //color: Colors.white
            ))
      ],
    );
  }

  Widget _buildLoginButton({@required BuildContext context}) {
    String buttonText = localizationService.trans('AUTH.LOGIN');

    return OBPrimaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            buttonText,
            style: TextStyle(fontSize: 18.0),
          )
        ],
      ),
      onPressed: () {
        print('Entering the realm of Openbook!');
      },
    );
  }

  Widget _buildCreateAccountButton({@required BuildContext context}) {
    String buttonText = localizationService.trans('AUTH.CREATE_ACCOUNT');

    return OBSecondaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.0),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/auth/get-started');
      },
    );
  }
}
