import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_action_more/profile_action_more.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/actions/follow_button.dart';
import 'package:flutter/material.dart';

class OBProfileActions extends StatelessWidget {
  final User user;

  OBProfileActions(this.user);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;
    var modalService = openbookProvider.modalService;

    bool isLoggedInUser = userService.isLoggedInUser(user);

    List<Widget> actions = [];

    if (isLoggedInUser) {
      actions.add(
        Padding(
          // The margin compensates for the height of the (missing) OBProfileActionMore
          // Fixes cut-off Edit profile button, and level out layout distances
          padding: EdgeInsets.only(top: 6.5, bottom: 6.5),
          child: _buildEditButton(modalService, context),
        )
      );
    } else {
      actions.addAll([
        OBFollowButton(user),
        const SizedBox(
          width: 10,
        ),
        OBProfileActionMore(user)
      ]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions,
    );
  }

  _buildEditButton(ModalService modalService, context) {
    return OBButton(
        child: Text(
          'Edit profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          modalService.openEditUserProfile(user: user, context: context);
        });
  }
}
