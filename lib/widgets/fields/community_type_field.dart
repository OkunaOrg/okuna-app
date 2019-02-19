import 'package:Openbook/models/community.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/bottom_sheet.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/divider.dart';
import 'package:Openbook/widgets/theming/primary_accent_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCommunityTypeField extends StatelessWidget {
  final CommunityType value;
  final ValueChanged<CommunityType> onChanged;
  final String title;
  final String hintText;

  const OBCommunityTypeField(
      {@required this.value,
      this.onChanged,
      @required this.title,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    BottomSheetService bottomSheetService =
        OpenbookProvider.of(context).bottomSheetService;

    Widget typeIcon;
    String typeName;

    switch (value) {
      case CommunityType.public:
        typeIcon = OBIcon(
          OBIcons.publicCommunity,
          themeColor: OBIconThemeColor.primaryAccent,
        );
        typeName = 'Public';
        break;
      case CommunityType.private:
        typeIcon = OBIcon(OBIcons.privateCommunity,
            themeColor: OBIconThemeColor.primaryAccent);
        typeName = 'Private';
        break;
    }

    return MergeSemantics(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  OBText(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),
              subtitle: hintText != null ? OBText(hintText) : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  OBPrimaryAccentText(
                    typeName,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  typeIcon,
                ],
              ),
              onTap: () {
                bottomSheetService.showCommunityTypePicker(
                    initialType: value, context: context, onChanged: onChanged);
              }),
          OBDivider()
        ],
      ),
    );
  }
}
