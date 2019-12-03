import 'package:Okuna/models/user.dart';
import 'package:Okuna/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/tiles/actions/block_user_tile.dart';
import 'package:Okuna/widgets/tiles/actions/report_user_tile.dart';
import 'package:flutter/material.dart';
import 'package:Okuna/services/bottom_sheet.dart';


class OBProfileInlineActionsMoreButton extends StatelessWidget {
  final User user;

  const OBProfileInlineActionsMoreButton(this.user);

  @override
  Widget build(BuildContext context) {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    LocalizationService localizationService = openbookProvider.localizationService;
    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        return IconButton(
          icon: const OBIcon(
            OBIcons.moreVertical,
            customSize: 30,
          ),
          onPressed: () {

          },
        );
      },
    );
  }
}
