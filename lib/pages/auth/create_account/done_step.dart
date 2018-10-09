import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:flutter/material.dart';

class AuthDonePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AuthDonePageState();
  }
}

class AuthDonePageState extends State<AuthDonePage> {
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
                colorFilter: new ColorFilter.mode(
                    Colors.white.withOpacity(0.1), BlendMode.dstATop),
                image: new AssetImage('assets/images/confetti-background.gif'),
                fit: BoxFit.cover)),
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: Center(child: SingleChildScrollView(child: _buildHooray())),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: _buildNextButton(context: context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHooray() {
    var title = localizationService.trans('AUTH.CREATE_ACC.DONE_TITLE');

    var description =
        localizationService.trans('AUTH.CREATE_ACC.DONE_DESCRIPTION');

    return Column(
      children: <Widget>[
        Text(
          '🎉‍',
          style: TextStyle(fontSize: 45.0, color: Colors.white),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              //color: Colors.white
            )),
        SizedBox(
          height: 20.0,
        ),
        Text(description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              //color: Colors.white
            ))
      ],
    );
  }

  Widget _buildNextButton({@required BuildContext context}) {
    String buttonText =
        localizationService.trans('AUTH.CREATE_ACC.DONE_CONTINUE');

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
}
