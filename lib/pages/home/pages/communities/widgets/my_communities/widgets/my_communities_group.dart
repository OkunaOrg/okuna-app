import 'package:Openbook/libs/str_utils.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/widgets/http_list.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMyCommunitiesGroup extends StatefulWidget {
  final OBHttpListRefresher<Community> communityGroupListRefresher;
  final OBHttpListOnScrollLoader<Community> communityGroupListOnScrollLoader;
  final OBMyCommunitiesGroupFallbackBuilder noGroupItemsFallbackBuilder;
  final OBMyCommunitiesGroupController controller;
  final String groupItemName;
  final String groupName;
  final int maxGroupListPreviewItems;

  const OBMyCommunitiesGroup(
      {Key key,
      @required this.communityGroupListRefresher,
      @required this.communityGroupListOnScrollLoader,
      @required this.groupItemName,
      @required this.groupName,
      @required this.maxGroupListPreviewItems,
      this.noGroupItemsFallbackBuilder,
      this.controller})
      : super(key: key);

  @override
  OBMyCommunitiesGroupState createState() {
    return OBMyCommunitiesGroupState();
  }
}

class OBMyCommunitiesGroupState extends State<OBMyCommunitiesGroup> {
  bool _needsBootstrap;
  ToastService _toastService;
  NavigationService _navigationService;
  List<Community> _communityGroupList;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller.attach(this);
    _needsBootstrap = true;
    _communityGroupList = [];
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _toastService = openbookProvider.toastService;
      _navigationService = openbookProvider.navigationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    String capitalizedGroupName = capitalize(widget.groupName);
    int listItemCount =
        _communityGroupList.length < widget.maxGroupListPreviewItems
            ? _communityGroupList.length
            : widget.maxGroupListPreviewItems;

    if (listItemCount == 0) {
      if (widget.noGroupItemsFallbackBuilder != null) {
        return widget.noGroupItemsFallbackBuilder(
            context, _refreshJoinedCommunities);
      }
      return const SizedBox();
    }

    List<Widget> columnItems = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: OBText(
          capitalizedGroupName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      ListView.separated(
          physics: const ClampingScrollPhysics(),
          separatorBuilder: _buildCommunitySeparator,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          shrinkWrap: true,
          itemCount: listItemCount,
          itemBuilder: _buildGroupListPreviewItem),
    ];

    if (_communityGroupList.length > widget.maxGroupListPreviewItems) {
      columnItems.add(_buildSeeAllButton());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnItems,
    );
  }

  Widget _buildSeeAllButton() {
    return GestureDetector(
      onTap: _onWantsToSeeAll,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OBSecondaryText(
              'See all ' + widget.groupName,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 5,
            ),
            OBIcon(OBIcons.seeMore, themeColor: OBIconThemeColor.secondaryText)
          ],
        ),
      ),
    );
  }

  Widget _buildGroupListPreviewItem(BuildContext context, index) {
    return OBCommunityTile(
      _communityGroupList[index],
      size: OBCommunityTileSize.small,
      onCommunityTilePressed: _onCommunityPressed,
    );
  }

  Widget _buildGroupListItem(BuildContext context, Community community) {
    return OBCommunityTile(
      community,
      size: OBCommunityTileSize.small,
      onCommunityTilePressed: _onCommunityPressed,
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
      List<Community> groupCommunities =
          await widget.communityGroupListRefresher();
      _setCommunityGroupList(groupCommunities);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (error) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    }
  }

  void _onCommunityPressed(Community community) {
    _navigationService.navigateToCommunity(
        context: context, community: community);
  }

  void _onWantsToSeeAll() {
    _navigationService.navigateToBlankPageWithWidget(
        context: context,
        key: Key('obMyCommunitiesGroup' + widget.groupItemName),
        navBarTitle: capitalize(widget.groupName),
        widget: _buildSeeAllGroupItemsPage());
  }

  Widget _buildSeeAllGroupItemsPage() {
    return Column(
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: OBHttpList<Community>(
              listItemBuilder: _buildGroupListItem,
              listRefresher: widget.communityGroupListRefresher,
              listOnScrollLoader: widget.communityGroupListOnScrollLoader,
              resourcePluralName: widget.groupName,
              resourceSingularName: widget.groupItemName),
        )),
      ],
    );
  }

  void _setCommunityGroupList(List<Community> communities) {
    setState(() {
      _communityGroupList = communities;
    });
  }
}

class OBMyCommunitiesGroupController {
  OBMyCommunitiesGroupState _state;

  void attach(OBMyCommunitiesGroupState state) {
    this._state = state;
  }

  Future<void> refresh() {
    return _state._refreshJoinedCommunities();
  }
}

typedef Future<void> OBMyCommunitiesGroupRetry();

typedef Widget OBMyCommunitiesGroupFallbackBuilder(
    BuildContext context, OBMyCommunitiesGroupRetry retry);
