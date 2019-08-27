import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/theming/divider.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/secondary_text.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:Okuna/widgets/tiles/actions/clear_application_cache_tile.dart';
import 'package:Okuna/widgets/tiles/actions/clear_application_preferences_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBApplicationSettingsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    LocalizationService _localizationService = provider.localizationService;
    NavigationService _navigationService = provider.navigationService;

    return CupertinoPageScaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      navigationBar: OBThemedNavigationBar(
          title: _localizationService.drawer__application_settings),
      child: OBPrimaryColorContainer(
        child: ListView(
          physics: const ClampingScrollPhysics(),
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: const OBIcon(OBIcons.link),
              title: OBText(_localizationService
                  .drawer__application_settings_trusted_domains_text),
              subtitle: OBSecondaryText(_localizationService
                  .drawer__application_settings_trusted_domains_desc),
              onTap: () {
                _navigationService.navigateToTrustedDomainsSettings(
                    context: context);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: OBDivider(),
            ),
            OBClearApplicationCacheTile(),
            OBClearApplicationPreferencesTile(),
          ],
        ),
      ),
    );
  }
}
