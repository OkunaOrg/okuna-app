import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/circles_picker/widgets/circles/circles.dart';
import 'package:Openbook/widgets/circles_picker/widgets/circles_search_results.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCirclesPicker extends StatefulWidget {
  final OnCirclesPicked onCirclesPicked;
  final List<Circle> initialPickedCircles;

  OBCirclesPicker(
      {@required this.onCirclesPicked, @required this.initialPickedCircles});

  @override
  State<StatefulWidget> createState() {
    return OBCirclesPickerState();
  }
}

class OBCirclesPickerState extends State<OBCirclesPicker> {
  UserService _userService;
  ToastService _toastService;

  bool _needsBootstrap;
  bool _hasSearch;

  List<Circle> _circles;
  List<Circle> _circleSearchResults;
  List<Circle> _selectedCircles;

  String _circleSearchQuery;

  @override
  void initState() {
    super.initState();
    _circles = widget.initialPickedCircles != null
        ? widget.initialPickedCircles.toList()
        : [];
    _circleSearchResults = [];
    _selectedCircles = [];
    _circleSearchQuery = '';
    _needsBootstrap = true;
    _hasSearch = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        OBSearchBar(
          onSearch: _onSearch,
          hintText: 'Search circles...',
        ),
        Expanded(
            child: _hasSearch
                ? OBCirclesSearchResults(
                    _circleSearchResults,
                    _circleSearchQuery,
                    selectedCircles: _selectedCircles,
                    onCirclePressed: _onCirclePressed,
                  )
                : OBCircles(
                    _circles,
                    selectedCircles: _selectedCircles,
                    onCirclePressed: _onCirclePressed,
                  ))
      ],
    );
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

  void _onSearch(String searchString) {
    if (searchString.length == 0) {
      _setHasSearch(false);
      return;
    }

    if (!_hasSearch) _setHasSearch(true);

    String standarisedSearchStr = searchString.toLowerCase();

    List<Circle> results = _circles.where((Circle circle) {
      return circle.name.contains(standarisedSearchStr);
    }).toList();

    _setCircleSearchResults(results);
    _setCircleSearchQuery(searchString);
  }

  void _bootstrap() async {
    CirclesList circleList = await _userService.getConnectionsCircles();
    this._setCircles(circleList.circles);
  }

  void _setCircles(List<Circle> circles) {
    setState(() {
      _circles = circles;
      _selectedCircles = [];
      _circleSearchResults = [];
    });
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

  void _setCircleSearchResults(List<Circle> circleSearchResults) {
    setState(() {
      _circleSearchResults = circleSearchResults;
    });
  }

  void _setCircleSearchQuery(String searchQuery) {
    setState(() {
      _circleSearchQuery = searchQuery;
    });
  }

  void _setHasSearch(bool hasSearch) {
    setState(() {
      _hasSearch = hasSearch;
    });
  }
}

typedef void OnCirclesPicked(List<Circle> selectedCircles);
