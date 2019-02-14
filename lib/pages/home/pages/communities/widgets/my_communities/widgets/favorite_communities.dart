import 'package:Openbook/models/communities_list.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/theming/primary_accent_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBFavoriteCommunities extends StatefulWidget {
  @override
  OBFavoriteCommunitiesState createState() {
    return OBFavoriteCommunitiesState();
  }
}

class OBFavoriteCommunitiesState extends State<OBFavoriteCommunities> {
  bool _needsBootstrap;
  UserService _userService;
  ToastService _toastService;
  NavigationService _navigationService;
  List<Community> _favoriteCommunities;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _favoriteCommunities = [];
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _navigationService = openbookProvider.navigationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: OBText(
            'Favorites',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        ListView.separated(
            separatorBuilder: _buildCommunitySeparator,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            shrinkWrap: true,
            itemCount: _favoriteCommunities.length,
            itemBuilder: _buildCommunity)
      ],
    );
  }

  Widget _buildCommunity(BuildContext context, index) {
    return OBCommunityTile(
      _favoriteCommunities[index],
      size: OBCommunityTileSize.small,
      onCommunityTilePressed: _onFavoriteCommunityPressed,
    );
  }

  Widget _buildCommunitySeparator(BuildContext context, int index) {
    return const SizedBox(
      height: 10,
    );
  }

  void _bootstrap() {
    _refreshFavoriteCommunities();
  }

  Future<void> _refreshFavoriteCommunities() async {
    try {
      CommunitiesList favoriteCommunitiesList =
          await _userService.getFavoriteCommunities();
      _setFavoriteCommunities(favoriteCommunitiesList.communities);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (error) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    }
  }

  void _onFavoriteCommunityPressed(Community community) {
    _navigationService.navigateToCommunity(
        community: community, context: context);
  }

  void _setFavoriteCommunities(List<Community> communities) {
    setState(() {
      _favoriteCommunities = communities;
    });
  }
}
