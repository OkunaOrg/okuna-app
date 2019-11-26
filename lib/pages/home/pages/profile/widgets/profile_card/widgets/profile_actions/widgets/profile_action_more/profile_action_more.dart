import 'package:Okuna/models/user.dart';
import 'package:Okuna/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Okuna/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/widgets/confirm_connection_with_user_tile.dart';
import 'package:Okuna/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/widgets/connect_to_user_tile.dart';
import 'package:Okuna/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/widgets/disconnect_from_user_tile.dart';
import 'package:Okuna/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/widgets/add_account_to_list_tile.dart';
import 'package:Okuna/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/widgets/remove_account_from_lists_tile.dart';
import 'package:Okuna/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/widgets/update_connection_with_user_tile.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/tiles/actions/block_user_tile.dart';
import 'package:Okuna/widgets/tiles/actions/report_user_tile.dart';
import 'package:flutter/material.dart';
import 'package:Okuna/services/bottom_sheet.dart';


class OBProfileActionMore extends StatelessWidget {
  final User user;

  const OBProfileActionMore(this.user);

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
            List<Widget> moreTiles = [];

            var _dismissModalBottomSheet = () {
              Navigator.pop(context);
            };

            // TODO Messy, refactor.

            moreTiles.add(OBAddAccountToList(
              user,
              onWillShowModalBottomSheet: _dismissModalBottomSheet,
            ));

            if (user.hasFollowLists()) {
              moreTiles.add(OBRemoveAccountFromLists(
                user,
                onRemovedAccountFromLists: _dismissModalBottomSheet,
              ));
            }

            if (user.isConnected &&
                !user.isFullyConnected &&
                !user.isPendingConnectionConfirmation) {
              moreTiles.add(OBDisconnectFromUserTile(user,
                  onDisconnectedFromUser: _dismissModalBottomSheet,
                  title: localizationService.user__profile_action_cancel_connection));
              moreTiles.add(OBUpdateConnectionWithUserTile(user,
                  onWillShowModalBottomSheet: _dismissModalBottomSheet));
            } else if (user.isPendingConnectionConfirmation) {
              moreTiles.add(OBConfirmConnectionWithUserTile(
                user,
                onWillShowModalBottomSheet: _dismissModalBottomSheet,
              ));
              moreTiles.add(OBDisconnectFromUserTile(user,
                  onDisconnectedFromUser: _dismissModalBottomSheet,
                  title: localizationService.user__profile_action_deny_connection));
            } else if (user.isFullyConnected) {
              moreTiles.add(OBUpdateConnectionWithUserTile(user,
                  onWillShowModalBottomSheet: _dismissModalBottomSheet));
              moreTiles.add(OBDisconnectFromUserTile(user,
                  onDisconnectedFromUser: _dismissModalBottomSheet));
            } else {
              moreTiles.add(OBConnectToUserTile(
                user,
                context,
                onWillShowModalBottomSheet: _dismissModalBottomSheet,
              ));
            }

            User loggedInUser = openbookProvider.userService.getLoggedInUser();

            if (loggedInUser.canBlockOrUnblockUser(user)) {
              moreTiles.add(OBBlockUserTile(
                user: user,
                onBlockedUser: () {
                  // Bottom sheet
                  Navigator.pop(context);
                  openbookProvider.toastService
                      .success(message: localizationService.user__profile_action_user_blocked, context: context);
                },
                onUnblockedUser: () {
                  // Bottom sheet
                  Navigator.pop(context);
                  openbookProvider.toastService
                      .success(message: localizationService.user__profile_action_user_unblocked, context: context);
                },
              ));
            }

            moreTiles.add(OBReportUserTile(
              user: user,
              onWantsToReportUser: () {
                Navigator.of(context).pop();
              },
            ));

            showModalBottomSheetApp(
                context: context,
                builder: (BuildContext context) {
                  return OBRoundedBottomSheet(
                    child: Column(
                        mainAxisSize: MainAxisSize.min, children: moreTiles),
                  );
                });
          },
        );
      },
    );
  }
}
