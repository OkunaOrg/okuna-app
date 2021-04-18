import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class OBAboutPage extends StatefulWidget {
  @override
  OBAboutPageState createState() {
    return OBAboutPageState();
  }
}

// TODO The get_version plugin does not work for iOS.

class OBAboutPageState extends State<OBAboutPage> {
  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void initStateAsync() async {
    var pi = await PackageInfo.fromPlatform();

    if (!mounted) return;
    setState(() {});
  }

  Widget build(BuildContext context) {
    LocalizationService _localizationService =
        OpenbookProvider.of(context).localizationService;

    return CupertinoPageScaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      navigationBar:
          OBThemedNavigationBar(title: _localizationService.drawer__about),
      child: OBPrimaryColorContainer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: OBIcon(OBIcons.nativeInfo),
              title: OBText('Okuna v1.0.1'),
            ),
          ],
        ),
      ),
    );
  }
}
