import 'dart:async';

import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/widgets/http_list.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBBanCommunityUserModal extends StatefulWidget {
  final Community community;

  const OBBanCommunityUserModal({Key key, @required this.community})
      : super(key: key);

  @override
  State<OBBanCommunityUserModal> createState() {
    return OBBanCommunityUserModalState();
  }
}

class OBBanCommunityUserModalState
    extends State<OBBanCommunityUserModal> {
  UserService _userService;
  NavigationService _navigationService;
  LocalizationService _localizationService;

  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _userService = provider.userService;
      _navigationService = provider.navigationService;
      _localizationService = provider.localizationService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.community__ban_user_title,
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<User>(
          listItemBuilder: _buildCommunityMemberListItem,
          searchResultListItemBuilder: _buildCommunityMemberListItem,
          listRefresher: _refreshCommunityMembers,
          listOnScrollLoader: _loadMoreCommunityMembers,
          listSearcher: _searchCommunityMembers,
          resourceSingularName: _localizationService.community__member,
          resourcePluralName: _localizationService.community__member_plural,
        ),
      ),
    );
  }

  Widget _buildCommunityMemberListItem(BuildContext context, User user) {
    return OBUserTile(
      user,
      onUserTilePressed: _onWantsToAddNewBannedUser,
    );
  }

  Future<List<User>> _refreshCommunityMembers() async {
    UsersList communityMembers = await _userService
        .getMembersForCommunity(widget.community, exclude: [
      CommunityMembersExclusion.administrators,
      CommunityMembersExclusion.moderators
    ]);
    return communityMembers.users;
  }

  Future<List<User>> _loadMoreCommunityMembers(
      List<User> communityMembersList) async {
    var lastCommunityMember = communityMembersList.last;
    var lastCommunityMemberId = lastCommunityMember.id;
    var moreCommunityMembers = (await _userService.getMembersForCommunity(
            widget.community,
            maxId: lastCommunityMemberId,
            count: 20,
            exclude: [
          CommunityMembersExclusion.administrators,
          CommunityMembersExclusion.moderators
        ]))
        .users;
    return moreCommunityMembers;
  }

  Future<List<User>> _searchCommunityMembers(String query) async {
    UsersList results = await _userService.searchCommunityMembers(
        query: query,
        community: widget.community,
        exclude: [
          CommunityMembersExclusion.administrators,
          CommunityMembersExclusion.moderators
        ]);

    return results.users;
  }

  void _onWantsToAddNewBannedUser(User user) async {
    var addedCommunityBannedUser =
        await _navigationService.navigateToConfirmBanCommunityUser(
            context: context, community: widget.community, user: user);

    if (addedCommunityBannedUser != null && addedCommunityBannedUser) {
      Navigator.of(context).pop(user);
    }
  }
}
