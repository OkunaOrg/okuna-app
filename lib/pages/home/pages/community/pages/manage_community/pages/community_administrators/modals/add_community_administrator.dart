import 'dart:async';

import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';
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

class OBAddCommunityAdministratorModal extends StatefulWidget {
  final Community community;

  const OBAddCommunityAdministratorModal({Key key, @required this.community})
      : super(key: key);

  @override
  State<OBAddCommunityAdministratorModal> createState() {
    return OBAddCommunityAdministratorModalState();
  }
}

class OBAddCommunityAdministratorModalState
    extends State<OBAddCommunityAdministratorModal> {
  UserService _userService;
  NavigationService _navigationService;

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
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Add administrator',
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<User>(
          listItemBuilder: _buildCommunityMemberListItem,
          searchResultListItemBuilder: _buildCommunityMemberListItem,
          listRefresher: _refreshCommunityMembers,
          listOnScrollLoader: _loadMoreCommunityMembers,
          listSearcher: _searchCommunityMembers,
          searchBarPlaceholder: 'Search members...',
        ),
      ),
    );
  }

  Widget _buildCommunityMemberListItem(BuildContext context, User user) {
    return OBUserTile(
      user,
      onUserTilePressed: _onWantsToAddNewAdministrator,
    );
  }

  Future<List<User>> _refreshCommunityMembers() async {
    UsersList communityMembers =
        await _userService.getMembersForCommunity(widget.community);
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
    ))
        .users;
    return moreCommunityMembers;
  }

  Future<List<User>> _searchCommunityMembers(String query) async {
    UsersList results = await _userService.searchCommunityMembers(
        query: query, community: widget.community);

    return results.users;
  }

  void _onWantsToAddNewAdministrator(User user) async {
    var addedCommunityAdministrator =
        await _navigationService.navigateToConfirmAddCommunityAdministrator(
            context: context, community: widget.community, user: user);

    if (addedCommunityAdministrator != null && addedCommunityAdministrator) {
      Navigator.of(context).pop(user);
    }
  }
}
