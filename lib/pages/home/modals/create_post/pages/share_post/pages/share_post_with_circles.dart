import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/modals/create_post/pages/share_post/share_post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/circle_selectable_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSharePostWithCirclesPage extends StatefulWidget {
  final SharePostData sharePostData;

  const OBSharePostWithCirclesPage({Key key, @required this.sharePostData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBSharePostWithCirclesPageState();
  }
}

class OBSharePostWithCirclesPageState
    extends State<OBSharePostWithCirclesPage> {
  UserService _userService;
  ToastService _toastService;
  bool _isCreatePostInProgress;

  bool _needsBootstrap;

  List<Circle> _circles;
  List<Circle> _circleSearchResults;
  List<Circle> _selectedCircles;
  List<Circle> _disabledCircles;
  Circle _fakeWorldCircle =
      Circle(id: 1, name: 'World', color: '#023ca7', usersCount: 7700000000);
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
            child: _circleSearchResults.length == 0 &&
                    _circleSearchQuery.isNotEmpty
                ? _buildNoResults()
                : _buildSearchResults())
      ],
    );
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: 'Share to circles',
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

  Widget _buildSearchResults() {
    return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: _circleSearchResults.length,
        itemBuilder: (BuildContext context, int index) {
          Circle circle = _circleSearchResults[index];
          bool isSelected = _selectedCircles.contains(circle);
          bool isDisabled = _disabledCircles.contains(circle);

          return OBCircleSelectableTile(
            circle,
            isSelected: isSelected,
            isDisabled: isDisabled,
            onCirclePressed: _onCirclePressed,
          );
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
                'No circle found matching \'$_circleSearchQuery\'.',
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

  Future<void> createPost() async {
    _setCreatePostInProgress(true);

    Post createdPost;

    List<Circle> selectedCircles =
        _fakeWorldCircleSelected ? [] : _selectedCircles;

    try {
      if (widget.sharePostData.image != null) {
        createdPost = await _userService.createPost(
            text: widget.sharePostData.text,
            image: widget.sharePostData.image,
            circles: selectedCircles);
      } else if (widget.sharePostData.video != null) {
        createdPost = await _userService.createPost(
            text: widget.sharePostData.text,
            video: widget.sharePostData.video,
            circles: selectedCircles);
      } else if (widget.sharePostData.text != null) {
        createdPost = await _userService.createPost(
            text: widget.sharePostData.text, circles: selectedCircles);
      }
      // Remove modal
      Navigator.pop(context, createdPost);
    } catch (error) {
      _onError(error);
    } finally {
      _setCreatePostInProgress(false);
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
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
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
