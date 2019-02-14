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

class OBJoinedCommunities extends StatefulWidget {
  @override
  OBJoinedCommunitiesState createState() {
    return OBJoinedCommunitiesState();
  }
}

class OBJoinedCommunitiesState extends State<OBJoinedCommunities> {
  bool _needsBootstrap;
  UserService _userService;
  ToastService _toastService;
  NavigationService _navigationService;
  List<Community> _joinedCommunities;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _joinedCommunities = [];
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
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: OBText(
            'All',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        ListView.separated(
            separatorBuilder: _buildCommunitySeparator,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            shrinkWrap: true,
            itemCount: _joinedCommunities.length,
            itemBuilder: _buildCommunity)
      ],
    );
  }

  Widget _buildCommunity(BuildContext context, index) {
    return OBCommunityTile(
      _joinedCommunities[index],
      size: OBCommunityTileSize.small,
      onCommunityTilePressed: _onJoinedCommunityPressed,
    );
  }

  Widget _buildCommunitySeparator(BuildContext context, int index) {
    return const SizedBox(
      height: 10,
    );
  }

  void _bootstrap() {
    _refreshJoinedCommunities();
  }

  Future<void> _refreshJoinedCommunities() async {
    try {
      CommunitiesList joinedCommunitiesList =
          await _userService.getJoinedCommunities();
      _setJoinedCommunities(joinedCommunitiesList.communities);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (error) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    }
  }

  void _onJoinedCommunityPressed(Community community) {
    _navigationService.navigateToCommunity(
        community: community, context: context);
  }

  void _setJoinedCommunities(List<Community> communities) {
    setState(() {
      _joinedCommunities = communities;
    });
  }
}
