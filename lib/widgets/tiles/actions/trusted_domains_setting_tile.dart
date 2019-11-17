import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/secondary_text.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBTrustedDomainsSettingTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBTrustedDomainsSettingTileState();
  }
}

class OBTrustedDomainsSettingTileState
    extends State<OBTrustedDomainsSettingTile> {
  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    LocalizationService localizationService = provider.localizationService;
    NavigationService navigationService = provider.navigationService;

    return ListTile(
      leading: OBIcon(OBIcons.link),
      title: OBText(
          localizationService.application_settings__trusted_domains_text),
      subtitle: OBSecondaryText(
          localizationService.application_settings__trusted_domains_desc),
      onTap: () {
        navigationService.navigateToTrustedDomainsSettings(context: context);
      },
    );
  }
}
