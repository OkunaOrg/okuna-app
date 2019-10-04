import 'package:Okuna/provider.dart';
import 'package:Okuna/services/bottom_sheet.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/user_preferences.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/primary_accent_text.dart';
import 'package:Okuna/widgets/theming/secondary_text.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBAskToOpenUrlSettingTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBAskToOpenUrlSettingTileState();
  }
}

class OBAskToOpenUrlSettingTileState extends State<OBAskToOpenUrlSettingTile> {
  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    LocalizationService localizationService = provider.localizationService;
    UserPreferencesService preferencesService = provider.userPreferencesService;
    BottomSheetService bottomSheetService = provider.bottomSheetService;

    Map<bool, String> confirmUrlLocalizationMap =
        preferencesService.getConfirmUrlSettingLocalizationMap();

    return FutureBuilder(
        future: preferencesService.getAskToConfirmOpenUrl(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == null) return const SizedBox();

          return StreamBuilder(
              stream: preferencesService.confirmUrlSettingChange,
              initialData: snapshot.data,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                var currentSetting = snapshot.data;

                return ListTile(
                    leading: OBIcon(OBIcons.url),
                    title: OBText(localizationService
                        .application_settings__ask_for_urls_setting),
                    subtitle: OBSecondaryText(
                      localizationService.application_settings__tap_to_change,
                      size: OBTextSize.small,
                    ),
                    trailing: OBPrimaryAccentText(
                      confirmUrlLocalizationMap[currentSetting],
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      bottomSheetService.showConfirmUrlSettingPicker(
                          initialValue: currentSetting,
                          context: context,
                          onChanged: preferencesService.setAskToConfirmOpenUrl);
                    });
              });
        });
  }
}
