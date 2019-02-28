import 'package:Openbook/models/communities_list.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/communities/widgets/my_communities/widgets/my_communities_group.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/alerts/button_alert.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMyCommunities extends StatefulWidget {
  final ScrollController scrollController;

  const OBMyCommunities({Key key, this.scrollController}) : super(key: key);

  @override
  OBMyCommunitiesState createState() {
    return OBMyCommunitiesState();
  }
}

class OBMyCommunitiesState extends State<OBMyCommunities>
    with AutomaticKeepAliveClientMixin {
  OBMyCommunitiesGroupController _favoriteCommunitiesGroupController;
  OBMyCommunitiesGroupController _joinedCommunitiesGroupController;
  OBMyCommunitiesGroupController _moderatedCommunitiesGroupController;
  OBMyCommunitiesGroupController _administratedCommunitiesGroupController;
  NavigationService _navigationService;
  UserService _userService;
  bool _needsBootstrap;
  bool _refreshInProgress;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  @override
  void initState() {
    super.initState();
    _favoriteCommunitiesGroupController = OBMyCommunitiesGroupController();
    _joinedCommunitiesGroupController = OBMyCommunitiesGroupController();
    _moderatedCommunitiesGroupController = OBMyCommunitiesGroupController();
    _administratedCommunitiesGroupController = OBMyCommunitiesGroupController();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _refreshInProgress = false;
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _navigationService = openbookProvider.navigationService;
      _userService = openbookProvider.userService;
      _needsBootstrap = false;
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshAllGroups,
      child: ListView(
          // Need always scrollable for pull to refresh to work
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(0),
          children: <Widget>[
            OBMyCommunitiesGroup(
              controller: _favoriteCommunitiesGroupController,
              title: 'Favorites',
              groupName: 'favorite communities',
              groupItemName: 'favorite community',
              maxGroupListPreviewItems: 5,
              communityGroupListItemBuilder: _buildFavoriteCommunityListItem,
              communityGroupListRefresher: _refreshFavoriteCommunities,
              communityGroupListOnScrollLoader: _loadMoreFavoriteCommunities,
            ),
            OBMyCommunitiesGroup(
                controller: _administratedCommunitiesGroupController,
                title: 'Administrated',
                groupName: 'administrated communities',
                groupItemName: 'administrated community',
                maxGroupListPreviewItems: 5,
                communityGroupListItemBuilder:
                    _buildAdministratedCommunityListItem,
                communityGroupListRefresher: _refreshAdministratedCommunities,
                communityGroupListOnScrollLoader:
                    _loadMoreAdministratedCommunities),
            OBMyCommunitiesGroup(
              controller: _moderatedCommunitiesGroupController,
              title: 'Moderated',
              groupName: 'moderated communities',
              groupItemName: 'moderated community',
              maxGroupListPreviewItems: 5,
              communityGroupListItemBuilder: _buildModeratedCommunityListItem,
              communityGroupListRefresher: _refreshModeratedCommunities,
              communityGroupListOnScrollLoader: _loadMoreModeratedCommunities,
            ),
            OBMyCommunitiesGroup(
              controller: _joinedCommunitiesGroupController,
              title: 'All',
              groupName: 'all communities',
              groupItemName: 'community',
              maxGroupListPreviewItems: 5,
              communityGroupListItemBuilder: _buildJoinedCommunityListItem,
              communityGroupListRefresher: _refreshJoinedCommunities,
              communityGroupListOnScrollLoader: _loadMoreJoinedCommunities,
              noGroupItemsFallbackBuilder: _buildNoJoinedCommunitiesFallback,
            )
          ]),
    );
  }

  Future<List<Community>> _refreshJoinedCommunities() async {
    CommunitiesList joinedCommunitiesList =
        await _userService.getJoinedCommunities();
    return joinedCommunitiesList.communities;
  }

  Future<List<Community>> _loadMoreJoinedCommunities(
      List<Community> currentJoinedCommunities) async {
    int offset = currentJoinedCommunities.length;

    CommunitiesList moreJoinedCommunitiesList =
        await _userService.getJoinedCommunities(offset: offset);
    return moreJoinedCommunitiesList.communities;
  }

  Future<List<Community>> _refreshFavoriteCommunities() async {
    CommunitiesList favoriteCommunitiesList =
        await _userService.getFavoriteCommunities();
    return favoriteCommunitiesList.communities;
  }

  Future<List<Community>> _loadMoreFavoriteCommunities(
      List<Community> currentFavoriteCommunities) async {
    int offset = currentFavoriteCommunities.length;

    CommunitiesList moreFavoriteCommunitiesList =
        await _userService.getFavoriteCommunities(offset: offset);
    return moreFavoriteCommunitiesList.communities;
  }

  Future<List<Community>> _refreshAdministratedCommunities() async {
    CommunitiesList administratedCommunitiesList =
        await _userService.getAdministratedCommunities();
    return administratedCommunitiesList.communities;
  }

  Future<List<Community>> _loadMoreAdministratedCommunities(
      List<Community> currentAdministratedCommunities) async {
    int offset = currentAdministratedCommunities.length;

    CommunitiesList moreAdministratedCommunitiesList =
        await _userService.getAdministratedCommunities(offset: offset);
    return moreAdministratedCommunitiesList.communities;
  }

  Future<List<Community>> _refreshModeratedCommunities() async {
    CommunitiesList moderatedCommunitiesList =
        await _userService.getModeratedCommunities();
    return moderatedCommunitiesList.communities;
  }

  Future<List<Community>> _loadMoreModeratedCommunities(
      List<Community> currentModeratedCommunities) async {
    int offset = currentModeratedCommunities.length;

    CommunitiesList moreModeratedCommunitiesList =
        await _userService.getModeratedCommunities(offset: offset);
    return moreModeratedCommunitiesList.communities;
  }

  Widget _buildNoJoinedCommunitiesFallback(
      BuildContext context, OBMyCommunitiesGroupRetry retry) {
    return OBButtonAlert(
      text: 'Join communities to see this tab come to life!',
      onPressed: _refreshAllGroups,
      buttonText: 'Refresh',
      buttonIcon: OBIcons.refresh,
      isLoading: _refreshInProgress,
      assetImage: 'assets/images/stickers/got-it.png',
      //isLoading: _refreshInProgress,
    );
  }

  Widget _buildJoinedCommunityListItem(
      BuildContext context, Community community) {
    return StreamBuilder(
      stream: community.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        Community latestCommunity = snapshot.data;

        if (latestCommunity == null) return const SizedBox();

        User loggedInUser = _userService.getLoggedInUser();
        return latestCommunity.isMember(loggedInUser)
            ? _buildCommunityListItem(community)
            : const SizedBox();
      },
    );
  }

  Widget _buildModeratedCommunityListItem(
      BuildContext context, Community community) {
    return StreamBuilder(
      stream: community.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        Community latestCommunity = snapshot.data;

        if (latestCommunity == null) return const SizedBox();

        User loggedInUser = _userService.getLoggedInUser();
        return latestCommunity.isModerator(loggedInUser)
            ? _buildCommunityListItem(community)
            : const SizedBox();
      },
    );
  }

  Widget _buildAdministratedCommunityListItem(
      BuildContext context, Community community) {
    return StreamBuilder(
      stream: community.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        Community latestCommunity = snapshot.data;

        if (latestCommunity == null) return const SizedBox();

        User loggedInUser = _userService.getLoggedInUser();
        return latestCommunity.isAdministrator(loggedInUser)
            ? _buildCommunityListItem(community)
            : const SizedBox();
      },
    );
  }

  Widget _buildFavoriteCommunityListItem(
      BuildContext context, Community community) {
    return StreamBuilder(
      stream: community.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        Community latestCommunity = snapshot.data;

        if (latestCommunity == null) return const SizedBox();

        return latestCommunity.isFavorite
            ? _buildCommunityListItem(community)
            : const SizedBox();
      },
    );
  }

  Widget _buildCommunityListItem(Community community) {
    return OBCommunityTile(
      community,
      size: OBCommunityTileSize.small,
      onCommunityTilePressed: _onCommunityPressed,
    );
  }

  void _onCommunityPressed(Community community) {
    _navigationService.navigateToCommunity(
        context: context, community: community);
  }

  Future<void> _refreshAllGroups() async {
    _setRefreshInProgress(true);
    try {
      await Future.wait([
        _favoriteCommunitiesGroupController.refresh(),
        _administratedCommunitiesGroupController.refresh(),
        _moderatedCommunitiesGroupController.refresh(),
        _joinedCommunitiesGroupController.refresh(),
      ]);
    } finally {
      _setRefreshInProgress(false);
    }
  }

  void _setRefreshInProgress(bool refreshInProgress) {
    setState(() {
      _refreshInProgress = refreshInProgress;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
