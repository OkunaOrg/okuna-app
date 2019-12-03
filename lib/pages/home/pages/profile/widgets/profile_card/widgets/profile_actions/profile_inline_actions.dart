import 'package:Okuna/models/user.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/modal_service.dart';
import 'package:Okuna/widgets/buttons/actions/block_button.dart';
import 'package:Okuna/widgets/buttons/button.dart';
import 'package:Okuna/widgets/buttons/actions/follow_button.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBProfileInlineActions extends StatelessWidget {
  final User user;
  final VoidCallback onUserProfileUpdated;

  const OBProfileInlineActions(this.user,
      {@required this.onUserProfileUpdated});

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;
    var modalService = openbookProvider.modalService;
    var bottomSheetService = openbookProvider.bottomSheetService;
    LocalizationService localizationService =
        openbookProvider.localizationService;

    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        bool isLoggedInUser = userService.isLoggedInUser(user);

        List<Widget> actions = [];

        if (isLoggedInUser) {
          actions.add(Padding(
            // The margin compensates for the height of the (missing) OBProfileActionMore
            // Fixes cut-off Edit profile button, and level out layout distances
            padding: EdgeInsets.only(top: 6.5, bottom: 6.5),
            child: _buildEditButton(modalService, localizationService, context),
          ));
        } else {
          bool isBlocked = user.isBlocked ?? false;
          if (isBlocked) {
            actions.add(OBBlockButton(user));
          } else {
            actions.add(
              OBFollowButton(user),
            );
          }

          actions.addAll([
            const SizedBox(
              width: 10,
            ),
            IconButton(
              icon: const OBIcon(
                OBIcons.moreVertical,
                customSize: 30,
              ),
              onPressed: () {
                bottomSheetService.showUserActions(
                    context: context,
                    user: user,
                );
              },
            )
          ]);
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: actions,
        );
      },
    );
  }

  _buildEditButton(ModalService modalService,
      LocalizationService localizationService, context) {
    return OBButton(
        child: Text(
          localizationService.user__edit_profile_title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          modalService.openEditUserProfile(
              user: user,
              context: context,
              onUserProfileUpdated: onUserProfileUpdated);
        });
  }
}
