import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
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
  ToastService _toastService;

  bool _needsBootstrap;

  List<Circle> _circles;
  List<Circle> _circleSearchResults;
  List<Circle> _selectedCircles;

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
    _needsBootstrap = true;
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
    widget.onPickedCirclesChanged(_circles);
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
    // If we have initial circles, no reason to refetch
    if (_circles.length > 0) return;
    CirclesList circleList = await _userService.getConnectionsCircles();
    this._setCircles(circleList.circles);
  }

  void _resetCircleSearchResults() {
    setState(() {
      _circleSearchResults = _circles.toList();
    });
  }

  void _setCircles(List<Circle> circles) {
    setState(() {
      _circles = circles;
      _selectedCircles = [];
      _circleSearchResults = circles.toList();
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
