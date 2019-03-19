import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/success_button.dart';
import 'package:flutter/material.dart';

class OBAuthPasswordResetSuccessPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OBAuthPasswordResetSuccessPageState();
  }
}

class OBAuthPasswordResetSuccessPageState extends State<OBAuthPasswordResetSuccessPage> {
  LocalizationService localizationService;
  CreateAccountBloc createAccountBloc;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    localizationService = openbookProvider.localizationService;
    createAccountBloc = openbookProvider.createAccountBloc;

    return Scaffold(
      body: Container(
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

    String username = createAccountBloc.getUsername();

    return Column(
      children: <Widget>[
        Text(
          '👍‍',
          style: TextStyle(fontSize: 45.0, color: Colors.white),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text('All set!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              //color: Colors.white
            )),
        const SizedBox(
          height: 20.0,
        ),
        Text('Your password has been updated successfully',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
      ]
    );
  }

  Widget _buildNextButton({@required BuildContext context}) {
    String buttonText =
    localizationService.trans('AUTH.CREATE_ACC.DONE_CONTINUE');

    return OBSuccessButton(
      minWidth: double.infinity,
      size: OBButtonSize.large,
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
        Navigator.popUntil(context, ModalRoute.withName('/auth/login'));
      },
    );
  }
}
