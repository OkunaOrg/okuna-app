import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/pages/home/pages/menu/pages/follows_lists/widgets/follows_list_tile.dart';
import 'package:Openbook/widgets/buttons/accent_button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
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
    var modalService = provider.modalService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBThemedNavigationBar(
          title: 'My lists',
        ),
        child: Stack(
          children: <Widget>[
            OBPrimaryColorContainer(
              child: SizedBox(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                        child: OBSearchBar(
                      onSearch: _onSearch,
                      hintText: 'Search for a list...',
                    )),
                    Expanded(
                      child: RefreshIndicator(
                          key: _refreshIndicatorKey,
                          child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              controller: _followsListsScrollController,
                              padding: EdgeInsets.all(0),
                              itemCount: _followsListsSearchResults.length,
                              itemBuilder: (context, index) {
                                int commentIndex = index;

                                var followsList =
                                    _followsListsSearchResults[commentIndex];

                                var onFollowsListDeletedCallback = () {
                                  _removeFollowsList(followsList);
                                };

                                return OBFollowsListTile(
                                  followsList: followsList,
                                  onFollowsListDeletedCallback:
                                      onFollowsListDeletedCallback,
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
                      FollowsList createdFollowsList = await modalService
                          .openCreateFollowsList(context: context);
                      if (createdFollowsList != null) {
                        _onFollowsListCreated(createdFollowsList);
                      }
                    },
                    icon: const OBIcon(
                      OBIcons.add,
                      size: OBIconSize.small,
                      color: Colors.white,
                    ),
                    child: Text('Create new list')))
          ],
        ));
  }

  void scrollToTop() {}

  void _bootstrap() async {
    await _refreshComments();
  }

  Future<void> _refreshComments() async {
    try {
      _followsLists = (await _userService.getFollowsLists()).lists;
      _setFollowsLists(_followsLists);
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
      _followsLists.remove(followsList);
      _followsListsSearchResults.remove(followsList);
    });
  }

  void _onFollowsListCreated(FollowsList createdFollowsList) {
    this._followsLists.insert(0, createdFollowsList);
    this._setFollowsLists(this._followsLists.toList());
    _scrollToTop();
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

typedef Future<FollowsList> OnWantsToCreateFollowsList();
typedef Future<FollowsList> OnWantsToEditFollowsList(FollowsList followsList);
typedef void OnWantsToSeeFollowsList(FollowsList followsList);
