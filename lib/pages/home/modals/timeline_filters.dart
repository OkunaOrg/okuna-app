import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/timeline/timeline.dart';
import 'package:Openbook/widgets/fields/color_field.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/fields/text_form_field.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/circle_selectable_tile.dart';
import 'package:Openbook/widgets/tiles/follows_list_selectable_tile.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
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
  ToastService _toastService;

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
      _toastService = openbookProvider.toastService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            OBSearchBar(
              onSearch: _onSearch,
            ),
            _buildCirclesSearchResult(),
            _buildFollowsListsSearchResult()
          ],
        )));
  }

  Widget _buildCirclesSearchResult() {
    return ListView.builder(
        itemCount: _circlesSearchResults.length,
        itemBuilder: (BuildContext context, int index) {
          Circle circle = _circlesSearchResults[index];
          bool isSelected = _selectedCircles.contains(circle);

          return OBCircleSelectableTile(
            circle,
            isSelected: isSelected,
            onCirclePressed: _onCirclePressed,
          );
        });
  }

  Widget _buildFollowsListsSearchResult() {
    return ListView.builder(
        itemCount: _followsListsSearchResults.length,
        itemBuilder: (BuildContext context, int index) {
          FollowsList followsList = _followsListsSearchResults[index];
          bool isSelected = _selectedFollowsLists.contains(followsList);

          return OBFollowsListSelectableTile(
            followsList,
            isSelected: isSelected,
            onFollowsListPressed: _onFollowsListPressed,
          );
        });
  }

  Widget _buildNavigationBar() {
    return OBNavigationBar(
        leading: GestureDetector(
          child: OBIcon(OBIcons.close),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: 'Timeline Filters',
        trailing: OBButton(
          size: OBButtonSize.small,
          onPressed: _onWantsToApplyFilters,
          child: Text('Apply'),
        ));
  }

  void _onWantsToApplyFilters() async {
    _setRequestInProgress(true);
    await widget.timelinePageController
        .setPostFilters(circles: _selectedCircles, followsLists: _followsLists);
    _setRequestInProgress(false);
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
      _followsLists = _followsLists.toList();
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

    this._setCircles(results[0]);
    this._setFollowsLists(results[1]);
    _setRequestInProgress(false);
  }
}
