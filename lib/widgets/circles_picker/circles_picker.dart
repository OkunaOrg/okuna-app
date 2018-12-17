import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/circles_picker/widgets/circles_search_results.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCirclesPicker extends StatefulWidget {
  final List<Circle> initialPickedCircles;
  final List<Circle> initialCircles;
  final ValueChanged<List<Circle>> onPickedCirclesChanged;

  OBCirclesPicker(
      {@required this.onPickedCirclesChanged,
      this.initialPickedCircles,
      this.initialCircles});

  @override
  State<StatefulWidget> createState() {
    return OBCirclesPickerState();
  }
}

class OBCirclesPickerState extends State<OBCirclesPicker> {
  UserService _userService;

  bool _needsBootstrap;

  List<Circle> _circles;
  List<Circle> _circleSearchResults;
  List<Circle> _selectedCircles;
  List<Circle> _disabledCircles;
  Circle _fakeWorldCircle = Circle(id: 1, name: 'Earth', color: '#023ca7', usersCount: 7700000000);

  String _circleSearchQuery;

  @override
  void initState() {
    super.initState();
    _circles =
        widget.initialCircles != null ? widget.initialCircles.toList() : [];
    _circleSearchResults = _circles.toList();
    _selectedCircles = widget.initialPickedCircles != null
        ? widget.initialPickedCircles.toList()
        : [];
    _circleSearchQuery = '';
    _disabledCircles = [];
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OBSearchBar(
          onSearch: _onSearch,
          hintText: 'Search circles...',
        ),
        Expanded(
            child: OBCirclesSearchResults(
          _circleSearchResults,
          _circleSearchQuery,
          selectedCircles: _selectedCircles,
          disabledCircles: _disabledCircles,
          onCirclePressed: _onCirclePressed,
        ))
      ],
    );
  }

  void _onCirclePressed(Circle pressedCircle) {
    if (_selectedCircles.contains(pressedCircle)) {
      // Remove
      if (pressedCircle == _fakeWorldCircle) {
        // Enable all other circles
        _setDisabledCircles([]);
        _setSelectedCircles([]);
        widget.onPickedCirclesChanged([]);
      } else{
        _removeSelectedCircle(pressedCircle);
        widget.onPickedCirclesChanged(_selectedCircles);
      }
    } else {
      // Add
      if (pressedCircle == _fakeWorldCircle) {
        // Add all circles
        _setSelectedCircles(_circles.toList());
        var disabledCircles = _circles.toList();
        disabledCircles.remove(_fakeWorldCircle);
        _setDisabledCircles(disabledCircles);
        widget.onPickedCirclesChanged([]);
      } else{
        _addSelectedCircle(pressedCircle);
        widget.onPickedCirclesChanged(_selectedCircles);
      }
    }
  }

  void _onSearch(String searchString) {
    if (searchString.length == 0) {
      _resetCircleSearchResults();
      return;
    }

    String standarisedSearchStr = searchString.toLowerCase();

    List<Circle> results = _circles.where((Circle circle) {
      return circle.name.toLowerCase().contains(standarisedSearchStr);
    }).toList();

    _setCircleSearchResults(results);
    _setCircleSearchQuery(searchString);
  }

  void _bootstrap() async {
    CirclesList circleList = await _userService.getConnectionsCircles();
    this._setCircles(circleList.circles);
  }

  void _resetCircleSearchResults() {
    setState(() {
      _circleSearchResults = _circles.toList();
    });
  }

  void _setCircles(List<Circle> circles) {
    var user = _userService.getLoggedInUser();
    setState(() {
      _circles = circles;
      var _connectionsCircle = _circles
          .firstWhere((circle) => circle.id == user.connectionsCircleId);
      _circles.remove(_connectionsCircle);
      _circles.insert(0, _connectionsCircle);
      _circles.insert(0, _fakeWorldCircle);
      _selectedCircles = [];
      _circleSearchResults = circles.toList();
    });
  }

  void _setDisabledCircles(List<Circle> disabledCircles) {
    setState(() {
      _disabledCircles = disabledCircles;
    });
  }

  void _setSelectedCircles(List<Circle> selectedCircles) {
    setState(() {
      _selectedCircles = selectedCircles;
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
}
