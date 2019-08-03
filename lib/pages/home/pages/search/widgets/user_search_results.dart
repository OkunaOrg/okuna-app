import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/theme.dart';
import 'package:Okuna/models/user.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/theme.dart';
import 'package:Okuna/services/theme_value_parser.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/progress_indicator.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:Okuna/widgets/tiles/community_tile.dart';
import 'package:Okuna/widgets/tiles/user_tile.dart';
import 'package:flutter/material.dart';

class OBUserSearchResults extends StatefulWidget {
  final List<User> userResults;
  final List<Community> communityResults;
  final String searchQuery;
  final ValueChanged<User> onUserPressed;
  final ValueChanged<Community> onCommunityPressed;
  final ValueChanged<OBUserSearchResultsTab> onTabSelectionChanged;
  final VoidCallback onScroll;
  final OBUserSearchResultsTab selectedTab;
  final bool userSearchInProgress;
  final bool communitySearchInProgress;

  const OBUserSearchResults(
      {Key key,
      @required this.userResults,
      this.selectedTab = OBUserSearchResultsTab.users,
      @required this.communityResults,
      this.userSearchInProgress = false,
      this.communitySearchInProgress = false,
      @required this.searchQuery,
      @required this.onUserPressed,
      @required this.onScroll,
      @required this.onCommunityPressed,
      @required this.onTabSelectionChanged})
      : super(key: key);

  @override
  OBUserSearchResultsState createState() {
    return OBUserSearchResultsState();
  }
}

class OBUserSearchResultsState extends State<OBUserSearchResults>
    with TickerProviderStateMixin {
  TabController _tabController;
  LocalizationService _localizationService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    switch (widget.selectedTab) {
      case OBUserSearchResultsTab.users:
        _tabController.index = 0;
        break;
      case OBUserSearchResultsTab.communities:
        _tabController.index = 1;
        break;
      default:
        throw 'Unhandled tab index';
    }

    _tabController.addListener(_onTabSelectionChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.removeListener(_onTabSelectionChanged);
  }

  @override
  Widget build(BuildContext context) {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    ThemeService _themeService = openbookProvider.themeService;
    _localizationService = openbookProvider.localizationService;
    ThemeValueParserService _themeValueParser =
        openbookProvider.themeValueParserService;
    OBTheme theme = _themeService.getActiveTheme();

    Color tabIndicatorColor =
        _themeValueParser.parseGradient(theme.primaryAccentColor).colors[1];

    Color tabLabelColor = _themeValueParser.parseColor(theme.primaryTextColor);

    return Column(
      children: <Widget>[
        TabBar(
          controller: _tabController,
          tabs: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Tab(text: _localizationService.trans('user_search__users')),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Tab(text: _localizationService.trans('user_search__communities')),
            )
          ],
          isScrollable: false,
          indicatorColor: tabIndicatorColor,
          labelColor: tabLabelColor,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildUserResults(), _buildCommunityResults()],
          ),
        )
      ],
    );
  }

  Widget _buildUserResults() {
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        widget.onScroll();
        return true;
      },
      child: ListView.builder(
          padding: EdgeInsets.all(0),
          physics: const ClampingScrollPhysics(),
          itemCount: widget.userResults.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == widget.userResults.length) {
              String searchQuery = widget.searchQuery;
              if (widget.userSearchInProgress) {
                // Search in progress
                return ListTile(
                    leading: OBProgressIndicator(),
                    title: OBText(_localizationService.user_search__searching_for(searchQuery)));
              } else if (widget.userResults.isEmpty) {
                // Results were empty
                return ListTile(
                    leading: OBIcon(OBIcons.sad),
                    title: OBText(_localizationService.user_search__no_users_for(searchQuery)));
              } else {
                return SizedBox();
              }
            }

            User user = widget.userResults[index];

            return OBUserTile(
              user,
              onUserTilePressed: widget.onUserPressed,
            );
          }),
    );
  }

  Widget _buildCommunityResults() {
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        widget.onScroll();
        return true;
      },
      child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10,
            );
          },
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          physics: const ClampingScrollPhysics(),
          itemCount: widget.communityResults.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == widget.communityResults.length) {
              String searchQuery = widget.searchQuery;
              if (widget.communitySearchInProgress) {
                // Search in progress
                return ListTile(
                    leading: OBProgressIndicator(),
                    title: OBText(_localizationService.user_search__searching_for(searchQuery)));
              } else if (widget.communityResults.isEmpty) {
                // Results were empty
                return ListTile(
                    leading: OBIcon(OBIcons.sad),
                    title: OBText(_localizationService.user_search__no_communities_for(searchQuery)));
              } else {
                return SizedBox();
              }
            }

            Community community = widget.communityResults[index];

            return OBCommunityTile(
              community,
              onCommunityTilePressed: widget.onCommunityPressed,
            );
          }),
    );
  }

  void _onTabSelectionChanged() {
    OBUserSearchResultsTab newSelection =
        OBUserSearchResultsTab.values[_tabController.previousIndex];
    widget.onTabSelectionChanged(newSelection);
  }
}

enum OBUserSearchResultsTab { communities, users }
