import 'dart:async';

import 'package:Okuna/models/user.dart';
import 'package:Okuna/models/users_list.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/widgets/buttons/actions/user_subscribe_button.dart';
import 'package:Okuna/widgets/http_list.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/page_scaffold.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBUserSubscriptionsPage extends StatefulWidget {
  @override
  State<OBUserSubscriptionsPage> createState() {
    return OBUserSubscriptionsPageState();
  }
}

class OBUserSubscriptionsPageState extends State<OBUserSubscriptionsPage> {
  UserService _userService;
  NavigationService _navigationService;
  LocalizationService _localizationService;

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
      _navigationService = provider.navigationService;
      _localizationService = provider.localizationService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.user__user_subscriptions_text,
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<User>(
          controller: _httpListController,
          listItemBuilder: _buildUserSubscriptionsListItem,
          searchResultListItemBuilder: _buildUserSubscriptionsListItem,
          listRefresher: _refreshUserSubscriptions,
          listOnScrollLoader: _loadMoreSubscriptionsUsers,
          listSearcher: _searchUsers,
          resourceSingularName: _localizationService.user__user_subscriptions_resource_name,
          resourcePluralName: _localizationService.user__user_subscriptions_resource_name,
        ),
      ),
    );
  }

  Widget _buildUserSubscriptionsListItem(BuildContext context, User user) {
    return OBUserTile(user,
        onUserTilePressed: _onSubscribeListItemPressed,
        trailing: OBUserSubscribeButton(
          user,
          size: OBButtonSize.medium,
          unsubscribeButtonType: OBButtonType.highlight,
        ));
  }

  void _onSubscribeListItemPressed(User subscribedUser) {
    _navigationService.navigateToUserProfile(user: subscribedUser, context: context);
  }

  Future<List<User>> _refreshUserSubscriptions() async {
    UsersList users = await _userService.getUserSubscriptions();
    return users.users;
  }

  Future<List<User>> _loadMoreSubscriptionsUsers(List<User> userList) async {
    var lastUser = userList.last;
    var lastUserId = lastUser.id;
    var moreUsers = (await _userService.getUserSubscriptions(
      maxId: lastUserId,
      count: 20,
    )).users;

    return moreUsers;
  }

  Future<List<User>> _searchUsers(String query) async {
    UsersList results = await _userService.searchUserSubscriptions(query: query);

    return results.users;
  }
}
