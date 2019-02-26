import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCommunityActionsBottomSheet extends StatefulWidget {
  final Community community;
  final OnCommunityReported onCommunityReported;

  const OBCommunityActionsBottomSheet(
      {Key key, @required this.community, this.onCommunityReported})
      : super(key: key);

  @override
  OBCommunityActionsBottomSheetState createState() {
    return OBCommunityActionsBottomSheetState();
  }
}

class OBCommunityActionsBottomSheetState
    extends State<OBCommunityActionsBottomSheet> {
  UserService _userService;
  ToastService _toastService;
  ModalService _modalService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _modalService = openbookProvider.modalService;

    List<Widget> communityActions = [];

    User loggedInUser = _userService.getLoggedInUser();
    Community community = widget.community;

    bool isMemberOfCommunity = community.isMember(loggedInUser);
    bool isCommunityAdministrator = community.isAdministrator(loggedInUser);
    bool isCommunityModerator = community.isModerator(loggedInUser);
    bool communityHasInvitesEnabled = community.invitesEnabled;

    if (communityHasInvitesEnabled && isMemberOfCommunity) {
      communityActions.add(ListTile(
        leading: const OBIcon(OBIcons.communityInvites),
        title: const OBText(
          'Invite people to community',
        ),
        onTap: _onWantsToInvitePeople,
      ));
    }

    if (!isCommunityAdministrator && !isCommunityModerator) {
      communityActions.add(ListTile(
        leading: const OBIcon(OBIcons.reportCommunity),
        title: const OBText(
          'Report community',
        ),
        onTap: _onWantsToReportCommunity,
      ));
    }

    return OBPrimaryColorContainer(
      mainAxisSize: MainAxisSize.min,
      child: Column(
        children: communityActions,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  Future _onWantsToInvitePeople() async {
    // Dismiss current bottom sheet
    Navigator.pop(context);
    _modalService.openInviteToCommunity(
        context: context, community: widget.community);
  }

  void _onWantsToReportCommunity() async {
    _toastService.error(message: 'Not implemented yet', context: context);
    Navigator.pop(context);
  }
}

typedef OnCommunityReported(Community community);
