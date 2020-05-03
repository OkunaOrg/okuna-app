import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/user.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/theming/fading_highlighted_box.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:Okuna/widgets/tiles/actions/display_profile_community_posts_toggle_tile.dart';
import 'package:Okuna/widgets/tiles/actions/display_profile_followers_count_toggle_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBManageProfilePage extends StatefulWidget {
  final User user;
  final VoidCallback onUserProfileUpdated;
  final ValueChanged<Community> onExcludedCommunityRemoved;
  final ValueChanged<List<Community>> onExcludedCommunitiesAdded;

  const OBManageProfilePage(this.user,
      {Key key,
      this.onUserProfileUpdated,
      this.onExcludedCommunityRemoved,
      this.onExcludedCommunitiesAdded})
      : super(key: key);

  @override
  OBManageProfilePageState createState() {
    return OBManageProfilePageState();
  }
}

class OBManageProfilePageState extends State<OBManageProfilePage> {
  static const double inputIconsSize = 16;
  static EdgeInsetsGeometry inputContentPadding =
      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0);

  LocalizationService _localizationService;
  NavigationService _navigationService;

  bool _communityPostsVisible;
  bool _isFirstBuild;

  @override
  void initState() {
    super.initState();
    _isFirstBuild = true;

    _communityPostsVisible = widget.user.getProfileCommunityPostsVisible();

    WidgetsBinding.instance.addPostFrameCallback((_) => _isFirstBuild = false);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _localizationService = openbookProvider.localizationService;
    _navigationService = openbookProvider.navigationService;
    var modalService = openbookProvider.modalService;

    return Scaffold(
        appBar: _buildNavigationBar(),
        body: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const OBIcon(OBIcons.communities),
                    title: OBText(_localizationService
                        .user__manage_profile_details_title),
                    subtitle: OBText(
                      _localizationService
                          .user__manage_profile_details_title_desc,
                      size: OBTextSize.mediumSecondary,
                    ),
                    onTap: () {
                      modalService.openEditProfile(
                          context: context, user: widget.user);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OBDisplayProfileFollowersCountToggleTile(user: widget.user),
                  const SizedBox(
                    height: 20,
                  ),
                  OBDisplayProfileCommunityPostsToggleTile(
                    user: widget.user,
                    onChanged: _onCommunityPostsVisibleChanged,
                  ),
                  _buildExcludedCommunitiesTile(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        )));
  }

  void _onCommunityPostsVisibleChanged(bool newValue) {
    setState(() {
      _communityPostsVisible = newValue;
    });
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: _localizationService.user__manage_profile_title,
    );
  }

  Widget _buildExcludedCommunitiesTile() {
    if (!_communityPostsVisible) return const SizedBox();

    Widget tile = ListTile(
      leading: OBIcon(OBIcons.excludePostCommunity),
      title: new OBText(
        _localizationService.user__profile_posts_excluded_communities,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: OBText(
        _localizationService.user__profile_posts_excluded_communities_desc,
        size: OBTextSize.mediumSecondary,
      ),
      onTap: () async {
        _navigationService.navigateToProfilePostsExcludedCommunities(
            context: context,
            onExcludedCommunityRemoved: widget.onExcludedCommunityRemoved,
            onExcludedCommunitiesAdded: widget.onExcludedCommunitiesAdded);
      },
    );

    const padding = EdgeInsets.symmetric(vertical: 20);

    if (_isFirstBuild) {
      return Padding(
        child: tile,
        padding: padding,
      );
    }
    return OBFadingHighlightedBox(
      child: tile,
      padding: padding,
    );
  }
}
