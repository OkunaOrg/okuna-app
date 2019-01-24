import 'package:Openbook/models/circle.dart';
import 'package:Openbook/pages/home/pages/menu/pages/connections_circles/widgets/connections_circle_tile.dart';
import 'package:Openbook/widgets/buttons/accent_button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/services/httpie.dart';

class OBConnectionsCirclesPage extends StatefulWidget {
  OBConnectionsCirclesPage();

  @override
  State<OBConnectionsCirclesPage> createState() {
    return OBConnectionsCirclesPageState();
  }
}

class OBConnectionsCirclesPageState extends State<OBConnectionsCirclesPage> {
  UserService _userService;
  ToastService _toastService;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  ScrollController _connectionsCirclesScrollController;
  List<Circle> _connectionsCircles = [];
  List<Circle> _connectionsCirclesSearchResults = [];

  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _connectionsCirclesScrollController = ScrollController();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _needsBootstrap = true;
    _connectionsCircles = [];
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;
    var modalService = provider.modalService;

    var loggedInUser = _userService.getLoggedInUser();

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBNavigationBar(
          title: 'My circles',
        ),
        child: Stack(
          children: <Widget>[
            OBPrimaryColorContainer(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        child: OBSearchBar(
                      onSearch: _onSearch,
                      hintText: 'Search for a circle...',
                    )),
                    Expanded(
                      child: RefreshIndicator(
                          key: _refreshIndicatorKey,
                          child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _connectionsCirclesScrollController,
                              padding: EdgeInsets.all(0),
                              itemCount:
                                  _connectionsCirclesSearchResults.length,
                              itemBuilder: (context, index) {
                                int commentIndex = index;

                                var connectionsCircle =
                                    _connectionsCirclesSearchResults[
                                        commentIndex];

                                var onConnectionsCircleDeletedCallback = () {
                                  _removeConnectionsCircle(connectionsCircle);
                                };

                                return OBConnectionsCircleTile(
                                  connectionsCircle: connectionsCircle,
                                  isReadOnly: loggedInUser
                                      .isConnectionsCircle(connectionsCircle),
                                  onConnectionsCircleDeletedCallback:
                                      onConnectionsCircleDeletedCallback,
                                );
                              }),
                          onRefresh: _refreshComments),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 20.0,
                right: 20.0,
                child: OBAccentButton(
                    onPressed: () async {
                      Circle createdConnectionsCircle = await modalService
                          .openCreateConnectionsCircle(context: context);
                      if (createdConnectionsCircle != null) {
                        _onConnectionsCircleCreated(createdConnectionsCircle);
                      }
                    },
                    icon: OBIcon(
                      OBIcons.add,
                      size: OBIconSize.small,
                      color: Colors.white,
                    ),
                    child: Text('Create new circle')))
          ],
        ));
  }

  void scrollToTop() {}

  void _bootstrap() async {
    await _refreshComments();
  }

  Future<void> _refreshComments() async {
    try {
      _connectionsCircles =
          (await _userService.getConnectionsCircles()).circles;
      // This assumes the connections circle always come last
      Circle connectionsCircle = _connectionsCircles.removeLast();
      _connectionsCircles.insert(0, connectionsCircle);
      _setConnectionsCircles(_connectionsCircles);
      _scrollToTop();
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (error) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    }
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      _resetConnectionsCirclesSearchResults();
      return;
    }

    String uppercaseQuery = query.toUpperCase();
    var searchResults = _connectionsCircles.where((connectionsCircle) {
      return connectionsCircle.name.toUpperCase().contains(uppercaseQuery);
    }).toList();

    _setConnectionsCirclesSearchResults(searchResults);
  }

  void _resetConnectionsCirclesSearchResults() {
    _setConnectionsCirclesSearchResults(_connectionsCircles.toList());
  }

  void _setConnectionsCirclesSearchResults(
      List<Circle> connectionsCirclesSearchResults) {
    setState(() {
      _connectionsCirclesSearchResults = connectionsCirclesSearchResults;
    });
  }

  void _removeConnectionsCircle(Circle connectionsCircle) {
    setState(() {
      _connectionsCircles.remove(connectionsCircle);
      _connectionsCirclesSearchResults.remove(connectionsCircle);
    });
  }

  void _onConnectionsCircleCreated(Circle createdConnectionsCircle) {
    this._connectionsCircles.insert(1, createdConnectionsCircle);
    this._setConnectionsCircles(this._connectionsCircles.toList());
    _scrollToTop();
  }

  void _scrollToTop() {
    _connectionsCirclesScrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _setConnectionsCircles(List<Circle> connectionsCircles) {
    setState(() {
      this._connectionsCircles = connectionsCircles;
      _resetConnectionsCirclesSearchResults();
    });
  }
}

typedef Future<Circle> OnWantsToCreateConnectionsCircle();
typedef Future<Circle> OnWantsToEditConnectionsCircle(Circle connectionsCircle);
typedef void OnWantsToSeeConnectionsCircle(Circle connectionsCircle);
