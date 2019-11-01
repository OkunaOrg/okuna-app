import 'package:Okuna/models/communities_list.dart';
import 'package:Okuna/models/community.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:Okuna/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSuggestedCommunities extends StatefulWidget {

  const OBSuggestedCommunities();

  @override
  OBSuggestedCommunitiesState createState() {
    return OBSuggestedCommunitiesState();
  }
}

class OBSuggestedCommunitiesState extends State<OBSuggestedCommunities>
    with AutomaticKeepAliveClientMixin {
  bool _needsBootstrap;
  UserService _userService;
  ToastService _toastService;
  NavigationService _navigationService;
  LocalizationService _localizationService;
  List<Community> _suggestedCommunities;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _suggestedCommunities = [];
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _navigationService = openbookProvider.navigationService;
      _localizationService = openbookProvider.localizationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        children: <Widget>[
          _suggestedCommunities.isEmpty && !_requestInProgress
              ? const CircularProgressIndicator()
              : _buildSuggestedCommunities()
        ],
      );
  }

  Widget _buildSuggestedCommunities() {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
//        OBText(_localizationService.community__suggested_title,
//          textAlign: TextAlign.center,
//          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//        ),
//        const SizedBox(height: 10.0),
        OBText(_localizationService.community__suggested_desc,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.black,),
        ),
        const SizedBox(height: 10.0),
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: _buildCommunitySeparator,
            padding: const EdgeInsets.only(bottom: 20),
            shrinkWrap: true,
            itemCount: _suggestedCommunities.length,
            itemBuilder: _buildCommunity)
      ],
    );
  }

  Widget _buildCommunity(BuildContext context, index) {
    Community community = _suggestedCommunities[index];
    return OBCommunityTile(
      community,
      key: Key(community.name),
    //  onCommunityTilePressed: _onTrendingCommunityPressed,
    );
  }

  Widget _buildCommunitySeparator(BuildContext context, int index) {
    return const SizedBox(
      height: 10,
    );
  }

  void _bootstrap() {
    _fetchSuggestedCommunities();
  }

  Future<void> _fetchSuggestedCommunities() async {
    debugPrint('Fetching suggested communities');
    _setRequestInProgress(true);
    try {
      CommunitiesList suggestedCommunitiesList =
      await _userService.getSuggestedCommunities();
      _setSuggestedCommunities(suggestedCommunitiesList.communities);
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
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

//  void _onTrendingCommunityPressed(Community community) {
//    _navigationService.navigateToCommunity(
//        community: community, context: context);
//  }

  void _setSuggestedCommunities(List<Community> communities) {
    setState(() {
      _suggestedCommunities = communities;
    });
  }

  void _setRequestInProgress(bool refreshInProgress) {
    setState(() {
      _requestInProgress = refreshInProgress;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
