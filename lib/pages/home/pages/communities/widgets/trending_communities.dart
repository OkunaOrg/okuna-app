import 'package:Openbook/models/category.dart';
import 'package:Openbook/models/communities_list.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBTrendingCommunities extends StatefulWidget {
  final Category category;

  const OBTrendingCommunities({Key key, this.category}) : super(key: key);

  @override
  OBTrendingCommunitiesState createState() {
    return OBTrendingCommunitiesState();
  }
}

class OBTrendingCommunitiesState extends State<OBTrendingCommunities> {
  bool _needsBootstrap;
  UserService _userService;
  ToastService _toastService;
  NavigationService _navigationService;
  List<Community> _trendingCommunities;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _trendingCommunities = [];
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

    bool hasCategory = widget.category != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: OBText(
            hasCategory
                ? 'Trending in ' + widget.category.title
                : 'Trending in all categories',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        ListView.separated(
            separatorBuilder: _buildCommunitySeparator,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            shrinkWrap: true,
            itemCount: _trendingCommunities.length,
            itemBuilder: _buildCommunity)
      ],
    );
  }

  Widget _buildCommunity(BuildContext context, index) {
    return OBCommunityTile(
      _trendingCommunities[index],
      onCommunityTilePressed: _onTrendingCommunityPressed,
    );
  }

  Widget _buildCommunitySeparator(BuildContext context, int index) {
    return const SizedBox(
      height: 10,
    );
  }

  void _bootstrap() {
    _refreshTrendingCommunities();
  }

  Future<void> _refreshTrendingCommunities() async {
    try {
      CommunitiesList trendingCommunitiesList =
          await _userService.getTrendingCommunities(category: widget.category);
      _setTrendingCommunities(trendingCommunitiesList.communities);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (error) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    }
  }

  void _onTrendingCommunityPressed(Community community) {
    _navigationService.navigateToCommunity(
        community: community, context: context);
  }

  void _setTrendingCommunities(List<Community> communities) {
    setState(() {
      _trendingCommunities = communities;
    });
  }
}
