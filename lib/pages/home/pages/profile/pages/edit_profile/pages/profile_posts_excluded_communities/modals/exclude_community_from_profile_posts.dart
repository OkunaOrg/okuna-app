import 'dart:async';

import 'package:Okuna/models/communities_list.dart';
import 'package:Okuna/models/community.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/widgets/http_list.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/page_scaffold.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBExcludeCommunitiesFromProfilePostsModal extends StatefulWidget {
  @override
  State<OBExcludeCommunitiesFromProfilePostsModal> createState() {
    return OBProfilePostsExcludedCommunitiesState();
  }
}

class OBProfilePostsExcludedCommunitiesState
    extends State<OBExcludeCommunitiesFromProfilePostsModal> {
  UserService _userService;
  NavigationService _navigationService;
  LocalizationService _localizationService;
  ToastService _toastService;

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
      _toastService = provider.toastService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.user__profile_posts_exclude_communities,
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<Community>(
          isSelectable: true,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          controller: _httpListController,
          listItemBuilder: _buildCommunityListItem,
          searchResultListItemBuilder: _buildCommunityListItem,
          selectedListItemBuilder: _buildCommunityListItem,
          listRefresher: _refreshJoinedCommunities,
          listOnScrollLoader: _loadMoreJoinedCommunities,
          listSearcher: _searchCommunities,
          resourceSingularName: _localizationService.community__community,
          resourcePluralName: _localizationService.community__communities,
        ),
      ),
    );
  }

  Widget _buildCommunityListItem(BuildContext context, Community community) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: OBCommunityTile(
        community,
        size: OBCommunityTileSize.small,
      ),
    );
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  Future<List<Community>> _refreshJoinedCommunities() async {
    CommunitiesList joinedCommunities =
        await _userService.getJoinedCommunities();
    return joinedCommunities.communities;
  }

  Future<List<Community>> _loadMoreJoinedCommunities(
      List<Community> joinedCommunitiesList) async {
    var lastJoinedCommunity = joinedCommunitiesList.last;
    var lastJoinedCommunityId = lastJoinedCommunity.id;
    var moreJoinedCommunities = (await _userService.getJoinedCommunities(
      offset: lastJoinedCommunityId,
    ))
        .communities;

    return moreJoinedCommunities;
  }

  Future<List<Community>> _searchCommunities(String query) async {
    CommunitiesList results = await _userService.getCommunitiesWithQuery(query);

    return results.communities;
  }
}
