import 'dart:async';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:Openbook/pages/home/lib/poppable_page_controller.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/pages/home/pages/search/widgets/user_search_results.dart';
import 'package:Openbook/pages/home/pages/search/widgets/trending/trending.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/search_bar.dart';
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
  bool _requestInProgress;
  String _searchQuery;
  List<User> _userSearchResults;
  OBTrendingController _trendingController;

  StreamSubscription<UsersList> _getUsersWithQuerySubscription;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null)
      widget.controller.attach(context: context, state: this);
    _trendingController = OBTrendingController();
    _requestInProgress = false;
    _hasSearch = false;
    _userSearchResults = [];
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _navigationService = openbookProvider.navigationService;

    Widget currentWidget;

    if (_requestInProgress) {
      currentWidget = Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[OBProgressIndicator()],
        ),
      );
    } else if (_hasSearch) {
      currentWidget = OBUserSearchResults(
        _userSearchResults,
        _searchQuery,
        onSearchUserPressed: _onSearchUserPressed,
      );
    } else {
      currentWidget = OBTrending(
        controller: _trendingController,
      );
    }

    return OBCupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: OBPrimaryColorContainer(
          child: Column(
            children: <Widget>[
              SafeArea(
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
      _searchForUsersWithQuery(query);
    }
  }

  Future<void> _searchForUsersWithQuery(String query) async {
    if (_getUsersWithQuerySubscription != null)
      _getUsersWithQuerySubscription.cancel();

    _setRequestInProgress(true);

    _getUsersWithQuerySubscription = _userService
        .getUsersWithQuery(query)
        .asStream()
        .listen((UsersList usersList) {
      _getUsersWithQuerySubscription = null;
      _setUserSearchResults(usersList.users);
    }, onError: (error) {
      if (error is HttpieConnectionRefusedError) {
        _toastService.error(
            message: 'No internet connection', context: context);
      } else {
        _toastService.error(message: 'Unknown error.', context: context);
        throw error;
      }
    }, onDone: () {
      _setRequestInProgress(false);
    });
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
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

  void _onSearchUserPressed(User user) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _navigationService.navigateToUserProfile(user: user, context: context);
  }

  void scrollToTop() {
    _trendingController.scrollToTop();
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
