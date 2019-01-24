import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/widgets/confirm_connection_with_user_tile.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/widgets/connect_to_user_tile.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/widgets/disconnect_from_user_tile.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/widgets/add_account_to_list_tile.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/widgets/remove_account_from_lists_tile.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/widgets/update_connection_with_user_tile.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/material.dart';

class OBProfileActionMore extends StatelessWidget {
  final User user;

  const OBProfileActionMore(this.user);

  @override
  Widget build(BuildContext context) {
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
                  title: 'Cancel connection request'));
              moreTiles.add(OBUpdateConnectionWithUserTile(user,
                  onWillShowModalBottomSheet: _dismissModalBottomSheet));
            } else if (user.isPendingConnectionConfirmation) {
              moreTiles.add(OBConfirmConnectionWithUserTile(
                user,
                onWillShowModalBottomSheet: _dismissModalBottomSheet,
              ));
              moreTiles.add(OBDisconnectFromUserTile(user,
                  onDisconnectedFromUser: _dismissModalBottomSheet,
                  title: 'Deny connection request'));
            } else if (user.isFullyConnected) {
              moreTiles.add(OBUpdateConnectionWithUserTile(user,
                  onWillShowModalBottomSheet: _dismissModalBottomSheet));
              moreTiles.add(OBDisconnectFromUserTile(user,
                  onDisconnectedFromUser: _dismissModalBottomSheet));
            } else {
              moreTiles.add(OBConnectToUserTile(
                user,
                onWillShowModalBottomSheet: _dismissModalBottomSheet,
              ));
            }

            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return OBPrimaryColorContainer(
                    mainAxisSize: MainAxisSize.min,
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
