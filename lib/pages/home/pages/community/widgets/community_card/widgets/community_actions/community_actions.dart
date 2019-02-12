import 'package:Openbook/models/community.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_actions/widgets/community_action_more/community_action_more.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/widgets/buttons/actions/join_community_button.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class OBCommunityActions extends StatelessWidget {
  final Community community;

  OBCommunityActions(this.community);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var modalService = openbookProvider.modalService;

    List<Widget> actions = [];

    bool isCommunityAdmin = false;

    if (isCommunityAdmin) {
      actions.add(_buildEditButton(modalService, context));
    } else {
      actions.addAll([
        OBJoinCommunityButton(community),
        const SizedBox(
          width: 10,
        ),
        OBCommunityActionMore(community)
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
          'Edit community',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          //modalService.openEditCommunityCommunity(community: community, context: context);
        });
  }
}
