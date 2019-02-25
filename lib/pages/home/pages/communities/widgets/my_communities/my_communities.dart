import 'package:Openbook/models/communities_list.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/pages/home/pages/communities/widgets/my_communities/widgets/my_communities_group.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:flutter/cupertino.dart';

class OBMyCommunities extends StatelessWidget {
  final ScrollController scrollController;

  const OBMyCommunities({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    UserService userService = openbookProvider.userService;

    return SingleChildScrollView(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OBMyCommunitiesGroup(
              groupName: 'favorite communities',
              groupItemName: 'favorite community',
              maxGroupListPreviewItems: 5,
              communityGroupListRefresher: () =>
                  _refreshFavoriteCommunities(userService),
              communityGroupListOnScrollLoader: (List<Community>
                      currentCommunities) =>
                  _loadMoreFavoriteCommunities(currentCommunities, userService),
            ),
            OBMyCommunitiesGroup(
              groupName: 'administrated communities',
              groupItemName: 'administrated community',
              maxGroupListPreviewItems: 5,
              communityGroupListRefresher: () =>
                  _refreshAdministratedCommunities(userService),
              communityGroupListOnScrollLoader:
                  (List<Community> currentCommunities) =>
                      _loadMoreAdministratedCommunities(
                          currentCommunities, userService),
            ),
            OBMyCommunitiesGroup(
              groupName: 'moderated communities',
              groupItemName: 'moderated community',
              maxGroupListPreviewItems: 5,
              communityGroupListRefresher: () =>
                  _refreshModeratedCommunities(userService),
              communityGroupListOnScrollLoader:
                  (List<Community> currentCommunities) =>
                      _loadMoreModeratedCommunities(
                          currentCommunities, userService),
            ),
            OBMyCommunitiesGroup(
              groupName: 'joined communities',
              groupItemName: 'joined community',
              maxGroupListPreviewItems: 5,
              communityGroupListRefresher: () =>
                  _refreshJoinedCommunities(userService),
              communityGroupListOnScrollLoader: (List<Community>
                      currentCommunities) =>
                  _loadMoreJoinedCommunities(currentCommunities, userService),
            )
          ],
        ),
      ),
    );
  }

  Future<List<Community>> _refreshJoinedCommunities(
      UserService userService) async {
    CommunitiesList joinedCommunitiesList =
        await userService.getJoinedCommunities();
    return joinedCommunitiesList.communities;
  }

  Future<List<Community>> _loadMoreJoinedCommunities(
      List<Community> currentJoinedCommunities, UserService userService) async {
    int offset = currentJoinedCommunities.length;

    CommunitiesList moreJoinedCommunitiesList =
        await userService.getJoinedCommunities(offset: offset);
    return moreJoinedCommunitiesList.communities;
  }

  Future<List<Community>> _refreshFavoriteCommunities(
      UserService userService) async {
    CommunitiesList favoriteCommunitiesList =
        await userService.getFavoriteCommunities();
    return favoriteCommunitiesList.communities;
  }

  Future<List<Community>> _loadMoreFavoriteCommunities(
      List<Community> currentFavoriteCommunities,
      UserService userService) async {
    int offset = currentFavoriteCommunities.length;

    CommunitiesList moreFavoriteCommunitiesList =
        await userService.getFavoriteCommunities(offset: offset);
    return moreFavoriteCommunitiesList.communities;
  }

  Future<List<Community>> _refreshAdministratedCommunities(
      UserService userService) async {
    CommunitiesList administratedCommunitiesList =
        await userService.getAdministratedCommunities();
    return administratedCommunitiesList.communities;
  }

  Future<List<Community>> _loadMoreAdministratedCommunities(
      List<Community> currentAdministratedCommunities,
      UserService userService) async {
    int offset = currentAdministratedCommunities.length;

    CommunitiesList moreAdministratedCommunitiesList =
        await userService.getAdministratedCommunities(offset: offset);
    return moreAdministratedCommunitiesList.communities;
  }

  Future<List<Community>> _refreshModeratedCommunities(
      UserService userService) async {
    CommunitiesList moderatedCommunitiesList =
        await userService.getModeratedCommunities();
    return moderatedCommunitiesList.communities;
  }

  Future<List<Community>> _loadMoreModeratedCommunities(
      List<Community> currentModeratedCommunities,
      UserService userService) async {
    int offset = currentModeratedCommunities.length;

    CommunitiesList moreModeratedCommunitiesList =
        await userService.getModeratedCommunities(offset: offset);
    return moreModeratedCommunitiesList.communities;
  }
}
