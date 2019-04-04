import 'dart:async';
import 'package:Openbook/models/communities_list.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:Openbook/pages/home/lib/poppable_page_controller.dart';
import 'package:Openbook/pages/home/pages/search/widgets/trending_posts.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/pages/home/pages/search/widgets/user_search_results.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainSearchPage extends StatefulWidget {
  final OBMainSearchPageController controller;

  const OBMainSearchPage({Key key, this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBMainSearchPageState();
  }
}

class OBMainSearchPageState extends State<OBMainSearchPage> {
  UserService _userService;
  ToastService _toastService;
  NavigationService _navigationService;

  bool _hasSearch;
  bool _userSearchRequestInProgress;
  bool _communitySearchRequestInProgress;
  String _searchQuery;
  List<User> _userSearchResults;
  List<Community> _communitySearchResults;
  OBTrendingPostsController _trendingPostsController;

  OBUserSearchResultsTab _selectedSearchResultsTab;

  StreamSubscription<UsersList> _getUsersWithQuerySubscription;
  StreamSubscription<CommunitiesList> _getCommunitiesWithQuerySubscription;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null)
      widget.controller.attach(context: context, state: this);
    _trendingPostsController = OBTrendingPostsController();
    _userSearchRequestInProgress = false;
    _communitySearchRequestInProgress = false;
    _hasSearch = false;
    _userSearchResults = [];
    _communitySearchResults = [];
    _selectedSearchResultsTab = OBUserSearchResultsTab.users;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _navigationService = openbookProvider.navigationService;

    Widget currentWidget;

    if (_hasSearch) {
      currentWidget = OBUserSearchResults(
        searchQuery: _searchQuery,
        userResults: _userSearchResults,
        userSearchInProgress: _userSearchRequestInProgress,
        communityResults: _communitySearchResults,
        communitySearchInProgress: _communitySearchRequestInProgress,
        onUserPressed: _onSearchUserPressed,
        onCommunityPressed: _onSearchCommunityPressed,
        selectedTab: _selectedSearchResultsTab,
        onScroll: _onScroll,
        onTabSelectionChanged: _onSearchTabSelectionChanged,
      );
    } else {
      currentWidget = OBTrendingPosts(
        controller: _trendingPostsController,
      );
    }

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(title: 'Search'),
        backgroundColor: Colors.white,
        child: OBPrimaryColorContainer(
          child: Column(
            children: <Widget>[
              SafeArea(
                top: false,
                bottom: false,
                child: OBSearchBar(
                  onSearch: _onSearch,
                  hintText: 'Search...',
                ),
              ),
              Expanded(child: currentWidget),
            ],
          ),
        ));
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

  void _onScroll() {
    _hideKeyboard();
  }

  void _hideKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Future<void> _searchWithQuery(String query) {
    return Future.wait([
      _searchForUsersWithQuery(query),
      _searchForCommunitiesWithQuery(query)
    ]);
  }

  Future<void> _searchForUsersWithQuery(String query) async {
    if (_getUsersWithQuerySubscription != null)
      _getUsersWithQuerySubscription.cancel();

    _setUserSearchRequestInProgress(true);

    _getUsersWithQuerySubscription =
        _userService.getUsersWithQuery(query).asStream().listen(
            (UsersList usersList) {
              _getUsersWithQuerySubscription = null;
              _setUserSearchResults(usersList.users);
            },
            onError: _onError,
            onDone: () {
              _setUserSearchRequestInProgress(false);
            });
  }

  Future<void> _searchForCommunitiesWithQuery(String query) async {
    if (_getCommunitiesWithQuerySubscription != null)
      _getCommunitiesWithQuerySubscription.cancel();

    _setCommunitySearchRequestInProgress(true);

    _getCommunitiesWithQuerySubscription =
        _userService.getCommunitiesWithQuery(query).asStream().listen(
            (CommunitiesList communitiesList) {
              _setCommunitySearchResults(communitiesList.communities);
            },
            onError: _onError,
            onDone: () {
              _setCommunitySearchRequestInProgress(false);
            });
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

  void _onSearchTabSelectionChanged(OBUserSearchResultsTab newSelection) {
    _selectedSearchResultsTab = newSelection;
  }

  void _setUserSearchRequestInProgress(bool requestInProgress) {
    setState(() {
      _userSearchRequestInProgress = requestInProgress;
    });
  }

  void _setCommunitySearchRequestInProgress(bool requestInProgress) {
    setState(() {
      _communitySearchRequestInProgress = requestInProgress;
    });
  }

  void _setHasSearch(bool hasSearch) {
    setState(() {
      _hasSearch = hasSearch;
    });
  }

  void _setSearchQuery(String searchQuery) {
    setState(() {
      _searchQuery = searchQuery;
    });
  }

  void _setUserSearchResults(List<User> searchResults) {
    setState(() {
      _userSearchResults = searchResults;
    });
  }

  void _setCommunitySearchResults(List<Community> searchResults) {
    setState(() {
      _communitySearchResults = searchResults;
    });
  }

  void _onSearchUserPressed(User user) {
    _hideKeyboard();
    _navigationService.navigateToUserProfile(user: user, context: context);
  }

  void _onSearchCommunityPressed(Community community) {
    _hideKeyboard();
    _navigationService.navigateToCommunity(
        community: community, context: context);
  }

  void scrollToTop() {
    _trendingPostsController.scrollToTop();
  }
}

class OBMainSearchPageController extends PoppablePageController {
  OBMainSearchPageState _state;

  void attach({@required BuildContext context, OBMainSearchPageState state}) {
    super.attach(context: context);
    _state = state;
  }

  void scrollToTop() {
    _state.scrollToTop();
  }
}
