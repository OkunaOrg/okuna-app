import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/follows_lists_list.dart';
import 'package:Openbook/pages/home/pages/timeline/timeline.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tile_group_title.dart';
import 'package:Openbook/widgets/tiles/circle_selectable_tile.dart';
import 'package:Openbook/widgets/tiles/follows_list_selectable_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBTimelineFiltersModal extends StatefulWidget {
  final OBTimelinePageController timelinePageController;

  const OBTimelineFiltersModal({Key key, @required this.timelinePageController})
      : super(key: key);

  @override
  OBTimelineFiltersModalState createState() {
    return OBTimelineFiltersModalState();
  }
}

class OBTimelineFiltersModalState extends State<OBTimelineFiltersModal> {
  UserService _userService;

  bool _requestInProgress;
  bool _needsBootstrap;

  String _searchQuery;

  List<Circle> _circles;
  List<Circle> _selectedCircles;
  List<Circle> _circlesSearchResults;

  List<FollowsList> _followsLists;
  List<FollowsList> _selectedFollowsLists;
  List<FollowsList> _followsListsSearchResults;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
    _circles = [];
    _selectedCircles = widget.timelinePageController.getFilteredCircles();
    _circlesSearchResults = [];
    _followsLists = [];
    _selectedFollowsLists =
        widget.timelinePageController.getFilteredFollowsLists();
    _followsListsSearchResults = [];
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            OBSearchBar(
              onSearch: _onSearch,
              hintText: 'Search for circles and lists...',
            ),
            Expanded(
              child: _circlesSearchResults.isNotEmpty ||
                      _followsListsSearchResults.isNotEmpty ||
                      _requestInProgress
                  ? _buildSearchResults()
                  : _buildNoResults(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OBButton(
                      size: OBButtonSize.large,
                      type: OBButtonType.highlight,
                      child: Text('Clear all'),
                      onPressed: _onWantsToClearFilters,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: OBButton(
                      size: OBButtonSize.large,
                      child: _buildApplyFiltersText(),
                      onPressed: _onWantsToApplyFilters,
                      isLoading: _requestInProgress,
                    ),
                  )
                ],
              ),
            )
          ],
        )));
  }

  Widget _buildApplyFiltersText() {
    String text = 'Apply filters';
    int filterCount = _selectedCircles.length + _selectedFollowsLists.length;
    if (filterCount > 0) {
      String friendlyCount = filterCount.toString();
      text += ' ($friendlyCount)';
    }
    return Text(text);
  }

  Widget _buildSearchResults() {
    return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount:
            _circlesSearchResults.length + _followsListsSearchResults.length,
        itemBuilder: (BuildContext context, int index) {
          bool isCircle = index < _circlesSearchResults.length;
          if (isCircle) {
            Circle circle = _circlesSearchResults[index];
            bool isSelected = _selectedCircles.contains(circle);

            Widget circleTile = OBCircleSelectableTile(
              circle,
              isSelected: isSelected,
              onCirclePressed: _onCirclePressed,
            );

            if (index == 0) {
              circleTile = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  OBTileGroupTitle(
                    title: 'Circles',
                  ),
                  circleTile
                ],
              );
            }
            return circleTile;
          }

          int listsIndex = index - _circlesSearchResults.length;

          FollowsList followsList = _followsListsSearchResults[listsIndex];
          bool isSelected = _selectedFollowsLists.contains(followsList);

          Widget listTile = OBFollowsListSelectableTile(
            followsList,
            isSelected: isSelected,
            onFollowsListPressed: _onFollowsListPressed,
          );

          if (index == _circlesSearchResults.length) {
            listTile = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                OBTileGroupTitle(
                  title: 'Lists',
                ),
                listTile
              ],
            );
          }
          return listTile;
        });
  }

  Widget _buildNoResults() {
    return SizedBox(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const OBIcon(OBIcons.sad, customSize: 30.0),
              const SizedBox(
                height: 20.0,
              ),
              OBText(
                'No match for \'$_searchQuery\'.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
        leading: GestureDetector(
          child: const OBIcon(OBIcons.close),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: 'Timeline filters');
  }

  void _onWantsToApplyFilters() async {
    _setRequestInProgress(true);
    await widget.timelinePageController.setPostFilters(
        circles: _selectedCircles, followsLists: _selectedFollowsLists);
    _setRequestInProgress(false);
    Navigator.pop(context);
  }

  void _onWantsToClearFilters() async {
    setState(() {
      _selectedFollowsLists = [];
      _selectedCircles = [];
    });
  }

  void _onSearch(String searchString) {
    if (searchString.length == 0) {
      _resetSearchResults();
      return;
    }

    String standarisedSearchStr = searchString.toLowerCase();
    _searchCircles(standarisedSearchStr);
    _searchFollowsLists(standarisedSearchStr);
    _setSearchQuery(searchString);
  }

  void _searchCircles(String standarisedSearchStr) {
    List<Circle> results = _circles.where((Circle circle) {
      return circle.name.toLowerCase().contains(standarisedSearchStr);
    }).toList();

    _setCirclesSearchResults(results);
  }

  void _searchFollowsLists(String standarisedSearchStr) {
    List<FollowsList> results = _followsLists.where((FollowsList followsList) {
      return followsList.name.toLowerCase().contains(standarisedSearchStr);
    }).toList();
    _setFollowsListsSearchResults(results);
  }

  void _resetSearchResults() {
    setState(() {
      _circlesSearchResults = _circles.toList();
      _followsListsSearchResults = _followsLists.toList();
    });
  }

  void _onCirclePressed(Circle pressedCircle) {
    if (_selectedCircles.contains(pressedCircle)) {
      // Remove
      _removeSelectedCircle(pressedCircle);
    } else {
      // Add
      _addSelectedCircle(pressedCircle);
    }
  }

  void _addSelectedCircle(Circle circle) {
    setState(() {
      _selectedCircles.add(circle);
    });
  }

  void _removeSelectedCircle(Circle circle) {
    setState(() {
      _selectedCircles.remove(circle);
    });
  }

  void _setCircles(List<Circle> circles) {
    setState(() {
      _circles = circles;
    });
  }

  void _setCirclesSearchResults(List<Circle> circlesSearchResults) {
    setState(() {
      _circlesSearchResults = circlesSearchResults;
    });
  }

  void _onFollowsListPressed(FollowsList pressedFollowsList) {
    if (_selectedFollowsLists.contains(pressedFollowsList)) {
      // Remove
      _removeSelectedFollowsList(pressedFollowsList);
    } else {
      // Add
      _addSelectedFollowsList(pressedFollowsList);
    }
  }

  void _addSelectedFollowsList(FollowsList followsList) {
    setState(() {
      _selectedFollowsLists.add(followsList);
    });
  }

  void _removeSelectedFollowsList(FollowsList followsList) {
    setState(() {
      _selectedFollowsLists.remove(followsList);
    });
  }

  void _setFollowsLists(List<FollowsList> followsLists) {
    setState(() {
      _followsLists = followsLists;
    });
  }

  void _setFollowsListsSearchResults(
      List<FollowsList> followsListsSearchResults) {
    setState(() {
      _followsListsSearchResults = followsListsSearchResults;
    });
  }

  void _setSearchQuery(String searchQuery) {
    setState(() {
      _searchQuery = searchQuery;
    });
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _bootstrap() async {
    _setRequestInProgress(true);
    var results = await Future.wait(
        [_userService.getConnectionsCircles(), _userService.getFollowsLists()]);

    CirclesList circlesList = results[0];
    FollowsListsList followsList = results[1];

    _setCircles(circlesList.circles);
    _setCirclesSearchResults(circlesList.circles);
    _setFollowsLists(followsList.lists);
    _setFollowsListsSearchResults(followsList.lists);
    _setRequestInProgress(false);
  }
}
