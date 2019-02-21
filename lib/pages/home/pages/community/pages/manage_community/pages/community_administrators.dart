import 'dart:async';

import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:Openbook/widgets/http_list.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/icon_button.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCommunityAdministratorsPage extends StatefulWidget {
  final Community community;

  const OBCommunityAdministratorsPage({Key key, @required this.community})
      : super(key: key);

  @override
  State<OBCommunityAdministratorsPage> createState() {
    return OBCommunityAdministratorsPageState();
  }
}

class OBCommunityAdministratorsPageState
    extends State<OBCommunityAdministratorsPage> {
  UserService _userService;

  OBHttpListController _httpListController;
  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _httpListController = OBHttpListController();
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
        title: 'Administrators',
        trailing: OBIconButton(
          OBIcons.add,
          themeColor: OBIconThemeColor.primaryAccent,
          onPressed: _onWantsToAddNewAdministrator,
        ),
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<User>(
          controller: _httpListController,
          itemBuilder: _buildCommunityAdministratorListItem,
          listRefresher: _refreshCommunityAdministrators,
          listOnScrollLoader: _loadMoreCommunityAdministrators,
          listSearcher: _searchCommunityAdministrators,
        ),
      ),
    );
  }

  Widget _buildCommunityAdministratorListItem(BuildContext context, User user) {
    return OBUserTile(
      user,
    );
  }

  Future<List<User>> _refreshCommunityAdministrators() async {
    UsersList communityAdministrators =
        await _userService.getAdministratorsForCommunity(widget.community);
    return communityAdministrators.users;
  }

  Future<List<User>> _loadMoreCommunityAdministrators(
      List<User> communityAdministratorsList) async {
    var lastCommunityAdministrator = communityAdministratorsList.last;
    var lastCommunityAdministratorId = lastCommunityAdministrator.id;
    var moreCommunityAdministrators =
        (await _userService.getAdministratorsForCommunity(
      widget.community,
      maxId: lastCommunityAdministratorId,
      count: 20,
    ))
            .users;
    return moreCommunityAdministrators;
  }

  Future<List<User>> _searchCommunityAdministrators(String query) async {
    UsersList results = await _userService.searchCommunityAdministrators(
        query: query, community: widget.community);

    return results.users;
  }

  void _onWantsToAddNewAdministrator() {
    /*  User createdCommunityAdministrator = await modalService
                          .openCreateCommunityAdministrator(context: context);
                      if (createdCommunityAdministrator != null) {
                        _onCommunityAdministratorCreated(
                            createdCommunityAdministrator);
                      }*/
  }
}

typedef Future<User> OnWantsToCreateCommunityAdministrator();
typedef Future<User> OnWantsToEditCommunityAdministrator(
    User communityAdministrator);
typedef void OnWantsToSeeCommunityAdministrator(User communityAdministrator);
