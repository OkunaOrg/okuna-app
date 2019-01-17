import 'dart:io';
import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/modals/create_post/pages/share_post/widgets/post_audience_search_results.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSharePostPage extends StatefulWidget {
  final SharePostData sharePostData;

  const OBSharePostPage({Key key, @required this.sharePostData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBSharePostPageState();
  }
}

class OBSharePostPageState extends State<OBSharePostPage> {
  UserService _userService;
  ToastService _toastService;
  bool _isCreatePostInProgress;

  bool _needsBootstrap;

  List<Circle> _circles;
  List<Circle> _circleSearchResults;
  List<Circle> _selectedCircles;
  List<Circle> _disabledCircles;
  Circle _fakeWorldCircle =
      Circle(id: 1, name: 'Earth', color: '#023ca7', usersCount: 7700000000);
  bool _fakeWorldCircleSelected;

  String _circleSearchQuery;

  @override
  void initState() {
    super.initState();
    _fakeWorldCircleSelected = false;
    _isCreatePostInProgress = false;
    _circles = [];
    _circleSearchResults = _circles.toList();
    _selectedCircles = [];
    _circleSearchQuery = '';
    _disabledCircles = [];
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _toastService = openbookProvider.toastService;
    _userService = openbookProvider.userService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: _buildAvailableAudience(),
        ));
  }

  Widget _buildAvailableAudience() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OBSearchBar(
          onSearch: _onSearch,
          hintText: 'Search circles...',
        ),
        Expanded(
            child: OBPostAudienceSearchResults(
          _circleSearchResults,
          _circleSearchQuery,
          selectedCircles: _selectedCircles,
          disabledCircles: _disabledCircles,
          onCirclePressed: _onCirclePressed,
        ))
      ],
    );
  }

  Widget _buildNavigationBar() {
    return OBNavigationBar(
      title: 'Audience',
      trailing: OBButton(
        size: OBButtonSize.small,
        type: OBButtonType.primary,
        isLoading: _isCreatePostInProgress,
        isDisabled: _selectedCircles.length == 0 && !_fakeWorldCircleSelected,
        onPressed: createPost,
        child: Text('Share'),
      ),
    );
  }

  Future<void> createPost() async {
    _setCreatePostInProgress(true);

    Post createdPost;
    try {
      if (widget.sharePostData.image != null) {
        createdPost = await _userService.createPost(
            text: widget.sharePostData.text,
            image: widget.sharePostData.image,
            circles: _selectedCircles);
      } else if (widget.sharePostData.video != null) {
        createdPost = await _userService.createPost(
            text: widget.sharePostData.text,
            video: widget.sharePostData.video,
            circles: _selectedCircles);
      } else if (widget.sharePostData.text != null) {
        createdPost = await _userService.createPost(
            text: widget.sharePostData.text, circles: _selectedCircles);
      }
      // Remove modal
      Navigator.pop(context, createdPost);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
      _setCreatePostInProgress(false);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    } finally {
      _setCreatePostInProgress(false);
    }
  }

  void _setCreatePostInProgress(bool createPostInProgress) {
    setState(() {
      _isCreatePostInProgress = createPostInProgress;
    });
  }

  void _onCirclePressed(Circle pressedCircle) {
    if (_selectedCircles.contains(pressedCircle)) {
      // Remove
      if (pressedCircle == _fakeWorldCircle) {
        // Enable all other circles
        _setDisabledCircles([]);
        _setSelectedCircles([]);
        _setFakeWorlCircleSelected(false);
      } else {
        _removeSelectedCircle(pressedCircle);
      }
    } else {
      // Add
      if (pressedCircle == _fakeWorldCircle) {
        // Add all circles
        _setSelectedCircles(_circles.toList());
        var disabledCircles = _circles.toList();
        disabledCircles.remove(_fakeWorldCircle);
        _setDisabledCircles(disabledCircles);
        _setFakeWorlCircleSelected(true);
      } else {
        _addSelectedCircle(pressedCircle);
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
      // Move connections circle to top
      var _connectionsCircle = _circles
          .firstWhere((circle) => circle.id == user.connectionsCircleId);
      _circles.remove(_connectionsCircle);
      _circles.insert(0, _connectionsCircle);
      // Add fake world circle
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

  void _setFakeWorlCircleSelected(bool fakeWorldCircleSelected) {
    setState(() {
      _fakeWorldCircleSelected = fakeWorldCircleSelected;
    });
  }
}

class SharePostData {
  String text;
  File image;
  File video;

  SharePostData({@required this.text, this.image, this.video});
}
