import 'package:Openbook/pages/home/pages/menu/widgets/settings/modals/change-password/change_password.dart';
import 'package:Openbook/pages/home/pages/menu/widgets/settings/modals/change_email/change_email.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var localizationService = openbookProvider.localizationService;

    return CupertinoPageScaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      navigationBar: _buildNavigationBar(),
      child: Container(
          color: Colors.white,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.email),
                title: Text(localizationService.trans('SETTINGS.CHANGE_EMAIL')),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute<bool>(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => Material(
                        child: OBChangeEmailModal(),
                      )));
                },
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text(localizationService.trans('SETTINGS.CHANGE_PASSWORD')),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute<bool>(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => Material(
                        child: OBChangePasswordModal(),
                      )));
                },
              ),
            ],
          ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: Colors.white,
      middle: Text('Settings'),
    );
  }

}