import 'package:Openbook/models/community.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_actions/widgets/community_action_more/community_action_more.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/widgets/buttons/actions/join_community_button.dart';
import 'package:Openbook/widgets/buttons/community_button.dart';
import 'package:flutter/material.dart';

class OBCommunityActions extends StatelessWidget {
  final Community community;

  OBCommunityActions(this.community);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    NavigationService navigationService = openbookProvider.navigationService;

    bool isCommunityAdmin = community?.isAdmin ?? false;

    List<Widget> actions = [];

    if (isCommunityAdmin) {
      actions.add(_buildManageButton(navigationService, context));
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

  _buildManageButton(NavigationService navigationService, context) {
    return OBCommunityButton(
        community: community,
        isLoading: false,
        text: 'Manage',
        onPressed: () {
          navigationService.navigateToManageCommunity(
              community: community, context: context);
        });
  }
}
