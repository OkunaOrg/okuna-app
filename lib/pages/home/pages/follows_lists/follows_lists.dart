import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/follows_lists/widgets/follows_list_tile.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/routes/slide_right_route.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/services/httpie.dart';

class OBFollowsListsPage extends StatefulWidget {
  @override
  State<OBFollowsListsPage> createState() {
    return OBFollowsListsPageState();
  }
}

class OBFollowsListsPageState extends State<OBFollowsListsPage> {
  UserService _userService;
  ToastService _toastService;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  ScrollController _followsListsScrollController;
  List<FollowsList> _followsLists = [];
  List<FollowsList> _followsListsSearchResults = [];

  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _followsListsScrollController = ScrollController();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _needsBootstrap = true;
    _followsLists = [];
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: CupertinoNavigationBar(
          middle: Text('My lists'),
          transitionBetweenRoutes: false,
          backgroundColor: Colors.white,
        ),
        child: Container(
          color: Colors.white,
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          controller: _followsListsScrollController,
                          padding: EdgeInsets.all(0),
                          itemCount: _followsListsSearchResults.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Container(
                                  child: OBSearchBar(
                                onSearch: _onSearch,
                                hintText: 'Search for a list...',
                              ));
                            }

                            int commentIndex = index - 1;

                            var followsList =
                                _followsListsSearchResults[commentIndex];

                            var onFollowsListDeletedCallback = () {
                              _removeFollowsList(followsList);
                            };

                            return OBFollowsListTile(
                              followsList: followsList,
                              onWantsToSeeUserProfile: _onWantsToSeeUserProfile,
                              onFollowsListDeletedCallback:
                                  onFollowsListDeletedCallback,
                            );
                          }),
                      onRefresh: _refreshComments),
                ),
              ],
            ),
          ),
        ));
  }

  void _bootstrap() async {
    await _refreshComments();
  }

  void _onWantsToSeeUserProfile(User user) {
    Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSlideProfileViewFromFollowsLists'),
            widget: OBProfilePage(user)));
  }

  Future<void> _refreshComments() async {
    try {
      _followsLists = (await _userService.getFollowsLists()).lists;
      _setFollowsLists(_followsLists);
      _scrollToTop();
    } on HttpieConnectionRefusedError catch (error) {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (error) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    }
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      _resetFollowsListsSearchResults();
      return;
    }

    String uppercaseQuery = query.toUpperCase();
    var searchResults = _followsLists.where((followsList) {
      return followsList.name.toUpperCase().contains(uppercaseQuery);
    }).toList();

    _setFollowsListsSearchResults(searchResults);
  }

  void _resetFollowsListsSearchResults() {
    _setFollowsListsSearchResults(_followsLists.toList());
  }

  void _setFollowsListsSearchResults(
      List<FollowsList> followsListsSearchResults) {
    setState(() {
      _followsListsSearchResults = followsListsSearchResults;
    });
  }

  void _removeFollowsList(FollowsList followsList) {
    setState(() {
      var index = _followsLists.indexOf(followsList);
      var searchIndex = _followsLists.indexOf(followsList);
      _followsLists.removeAt(index);
      _followsListsSearchResults.remove(searchIndex);
    });
  }

  void _onFollowsListCreated(FollowsList createdFollowsList) {
    setState(() {
      this._followsLists.insert(0, createdFollowsList);
    });
  }

  void _scrollToTop() {
    _followsListsScrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _setFollowsLists(List<FollowsList> followsLists) {
    setState(() {
      this._followsLists = followsLists;
      _resetFollowsListsSearchResults();
    });
  }
}
