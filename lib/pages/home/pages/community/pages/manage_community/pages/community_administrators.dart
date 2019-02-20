import 'dart:async';

import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:Openbook/widgets/alerts/button_alert.dart';
import 'package:Openbook/widgets/buttons/accent_button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/icon_button.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:loadmore/loadmore.dart';

class OBCommunityAdministratorsPage extends StatefulWidget {
  final Community community;

  const OBCommunityAdministratorsPage({Key key, @required this.community})
      : super(key: key);

  @override
  State<OBCommunityAdministratorsPage> createState() {
    return OBCommunityAdministratorsPageState();
  }
}

class OBCommunityAdministratorsPageState
    extends State<OBCommunityAdministratorsPage> {
  static const int pageWiseSize = 10;

  UserService _userService;
  ToastService _toastService;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  PagewiseLoadController _pageWiseLoadController;
  ScrollController _communityAdministratorsScrollController;
  List<User> _communityAdministrators = [];
  List<User> _communityAdministratorsSearchResults = [];
  bool _hasSearch;
  String _searchQuery;
  bool _needsBootstrap;
  bool _requestInProgress;
  bool _searchRequestInProgress;
  bool _loadingFinished;

  StreamSubscription<UsersList>
      _getCommunityAdministratorsWithQuerySubscription;

  @override
  void initState() {
    super.initState();
    _communityAdministratorsScrollController = ScrollController();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _loadingFinished = false;
    _needsBootstrap = true;
    _requestInProgress = false;
    _searchRequestInProgress = false;
    _hasSearch = false;
    _communityAdministrators = [];
    _searchQuery = '';
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
      navigationBar: OBThemedNavigationBar(
        title: 'Administrators',
        trailing: OBIconButton(
          OBIcons.add,
          themeColor: OBIconThemeColor.primaryAccent,
          onPressed: _onWantsToAddNewAdministrator,
        ),
      ),
      child: OBPrimaryColorContainer(
        child: Column(
          children: <Widget>[
            SizedBox(
                child: OBSearchBar(
              onSearch: _onSearch,
              hintText: 'Search for an administrator...',
            )),
            Expanded(
                child: _hasSearch
                    ? _buildAdministratorsSearchResultsList()
                    : _buildAdministratorsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAdministratorsSearchResultsList() {
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        // Hide keyboard
        return true;
      },
      child: ListView.builder(
          padding: EdgeInsets.all(0),
          physics: const ClampingScrollPhysics(),
          itemCount: _communityAdministratorsSearchResults.length + 1,
          itemBuilder: _buildAdministratorsSearchResultsListItem),
    );
  }

  Widget _buildAdministratorsSearchResultsListItem(
      BuildContext context, int index) {
    if (index == _communityAdministratorsSearchResults.length) {
      String searchQuery = _searchQuery;

      if (_searchRequestInProgress) {
        // Search in progress
        return ListTile(
            leading: const OBProgressIndicator(),
            title: OBText('Searching for $searchQuery'));
      } else if (_communityAdministratorsSearchResults.isEmpty) {
        // Results were empty
        return ListTile(
            leading: const OBIcon(OBIcons.sad),
            title: OBText('No users found for $searchQuery.'));
      } else {
        return const SizedBox();
      }
    }

    User user = _communityAdministratorsSearchResults[index];

    return OBUserTile(
      user,
    );
  }

  Widget _buildAdministratorsList() {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        child: LoadMore(
            whenEmptyLoad: false,
            isFinish: _loadingFinished,
            delegate: const OBLoadMoreDelegate(),
            child: ListView.builder(
                controller: _communityAdministratorsScrollController,
                physics: const ClampingScrollPhysics(),
                cacheExtent: 30,
                addAutomaticKeepAlives: true,
                padding: const EdgeInsets.all(0),
                itemCount: _communityAdministrators.length,
                itemBuilder: _buildAdministratorListItem),
            onLoadMore: _loadMoreCommunityAdministrators),
        onRefresh: _refreshAdministrators);
  }

  Widget _buildAdministratorListItem(BuildContext context, int index) {
    return OBUserTile(
      _communityAdministrators[index],
      onUserTileDeleted: _removeCommunityAdministrator,
    );
  }

  void _bootstrap() async {
    await _refreshAdministrators();
  }

  Future<void> _refreshAdministrators() async {
    try {
      _communityAdministrators =
          (await _userService.getAdministratorsForCommunity(widget.community))
              .users;
      _setCommunityAdministrators(_communityAdministrators);
      _scrollToTop();
    } catch (error) {
      _onRequestError(error);
    }
  }

  Future<bool> _loadMoreCommunityAdministrators() async {
    var lastCommunityAdministrator = _communityAdministrators.last;
    var lastCommunityAdministratorId = lastCommunityAdministrator.id;
    try {
      var moreCommunityAdministrators =
          (await _userService.getAdministratorsForCommunity(
        widget.community,
        maxId: lastCommunityAdministratorId,
        count: 20,
      ))
              .users;

      if (moreCommunityAdministrators.length == 0) {
        _setLoadingFinished(true);
      } else {
        setState(() {
          _communityAdministrators.addAll(moreCommunityAdministrators);
        });
      }
      return true;
    } catch (error) {
      _onRequestError(error);
    }

    return false;
  }

  void _onSearch(String query) {
    _setSearchQuery(query);
    if (query.isEmpty) {
      _setHasSearch(false);
    } else {
      _setHasSearch(true);
      _searchWithQuery(query);
    }
  }

  void _searchWithQuery(String query) {
    if (_getCommunityAdministratorsWithQuerySubscription != null)
      _getCommunityAdministratorsWithQuerySubscription.cancel();

    _setSearchRequestInProgress(true);

    _getCommunityAdministratorsWithQuerySubscription = _userService
        .searchCommunityAdministrators(
            query: query, community: widget.community)
        .asStream()
        .listen(
            (UsersList communityAdministrators) {
              _getCommunityAdministratorsWithQuerySubscription = null;
              _setCommunityAdministratorsSearchResults(
                  communityAdministrators.users);
            },
            onError: _onRequestError,
            onDone: () {
              _setSearchRequestInProgress(false);
            });
  }

  void _onWantsToAddNewAdministrator() {
    /*  User createdCommunityAdministrator = await modalService
                          .openCreateCommunityAdministrator(context: context);
                      if (createdCommunityAdministrator != null) {
                        _onCommunityAdministratorCreated(
                            createdCommunityAdministrator);
                      }*/
  }

  void _resetCommunityAdministratorsSearchResults() {
    _setCommunityAdministratorsSearchResults(_communityAdministrators.toList());
  }

  void _setCommunityAdministratorsSearchResults(
      List<User> communityAdministratorsSearchResults) {
    setState(() {
      _communityAdministratorsSearchResults =
          communityAdministratorsSearchResults;
    });
  }

  void _removeCommunityAdministrator(User communityAdministrator) {
    setState(() {
      _communityAdministrators.remove(communityAdministrator);
      _communityAdministratorsSearchResults.remove(communityAdministrator);
    });
  }

  void _onCommunityAdministratorCreated(User createdCommunityAdministrator) {
    this._communityAdministrators.insert(0, createdCommunityAdministrator);
    this._setCommunityAdministrators(this._communityAdministrators.toList());
    _scrollToTop();
  }

  void _setLoadingFinished(bool loadingFinished) {
    setState(() {
      _loadingFinished = loadingFinished;
    });
  }

  void _scrollToTop() {
    _communityAdministratorsScrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _setCommunityAdministrators(List<User> communityAdministrators) {
    setState(() {
      this._communityAdministrators = communityAdministrators;
      _resetCommunityAdministratorsSearchResults();
    });
  }

  void _addCommunityAdministrators(List<User> communityAdministrators) {
    setState(() {
      _communityAdministrators.addAll(communityAdministrators);
    });
  }

  void _setSearchQuery(String searchQuery) {
    setState(() {
      _searchQuery = searchQuery;
    });
  }

  void _setHasSearch(bool hasSearch) {
    setState(() {
      _hasSearch = hasSearch;
    });
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _setSearchRequestInProgress(bool searchRequestInProgress) {
    setState(() {
      _searchRequestInProgress = searchRequestInProgress;
    });
  }

  void _onRequestError(error) {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(message: 'No internet connection', context: context);
    } else {
      _toastService.error(message: 'Unknown error.', context: context);
      throw error;
    }
  }
}

typedef Future<User> OnWantsToCreateCommunityAdministrator();
typedef Future<User> OnWantsToEditCommunityAdministrator(
    User communityAdministrator);
typedef void OnWantsToSeeCommunityAdministrator(User communityAdministrator);

class OBLoadMoreDelegate extends LoadMoreDelegate {
  const OBLoadMoreDelegate();

  @override
  Widget buildChild(LoadMoreStatus status,
      {LoadMoreTextBuilder builder = DefaultLoadMoreTextBuilder.english}) {
    if (status == LoadMoreStatus.fail) {
      return SizedBox(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OBIcon(OBIcons.refresh),
            const SizedBox(
              width: 10.0,
            ),
            OBText('Tap to retry.')
          ],
        ),
      );
    }
    if (status == LoadMoreStatus.loading) {
      return SizedBox(
          child: Center(
        child: OBProgressIndicator(),
      ));
    }
    return const SizedBox();
  }
}
