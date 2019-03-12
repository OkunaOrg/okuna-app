import 'dart:async';

import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:Openbook/widgets/buttons/actions/invite_user_to_community.dart';
import 'package:Openbook/widgets/http_list.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBInviteToCommunityModal extends StatefulWidget {
  final Community community;

  const OBInviteToCommunityModal({Key key, @required this.community})
      : super(key: key);

  @override
  State<OBInviteToCommunityModal> createState() {
    return OBInviteToCommunityModalState();
  }
}

class OBInviteToCommunityModalState extends State<OBInviteToCommunityModal> {
  UserService _userService;

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
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Invite to community',
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<User>(
          listItemBuilder: _buildLinkedUserListItem,
          searchResultListItemBuilder: _buildLinkedUserListItem,
          listRefresher: _refreshLinkedUsers,
          listOnScrollLoader: _loadMoreLinkedUsers,
          listSearcher: _searchLinkedUsers,
          resourceSingularName: 'connection or follower',
          resourcePluralName: 'connections and followers',
        ),
      ),
    );
  }

  Widget _buildLinkedUserListItem(BuildContext context, User user) {
    return OBUserTile(
      user,
      key: Key(user.id.toString()),
      trailing: OBInviteUserToCommunityButton(
        user: user,
        community: widget.community,
      ),
      //trailing: OBButton,
    );
  }

  Future<List<User>> _refreshLinkedUsers() async {
    UsersList linkedUsers =
        await _userService.getLinkedUsers(withCommunity: widget.community);
    return linkedUsers.users;
  }

  Future<List<User>> _loadMoreLinkedUsers(List<User> linkedUsersList) async {
    var lastLinkedUser = linkedUsersList.last;
    var lastLinkedUserId = lastLinkedUser.id;
    var moreLinkedUsers = (await _userService.getLinkedUsers(
            maxId: lastLinkedUserId,
            count: 10,
            withCommunity: widget.community))
        .users;
    return moreLinkedUsers;
  }

  Future<List<User>> _searchLinkedUsers(String query) async {
    UsersList results = await _userService.searchLinkedUsers(
        query: query, withCommunity: widget.community);

    return results.users;
  }
}
