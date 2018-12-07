import 'dart:async';

import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:Openbook/pages/home/lib/base_state.dart';
import 'package:Openbook/pages/home/pages/post/post.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/pages/home/pages/search/widgets/user_search_results.dart';
import 'package:Openbook/pages/home/pages/search/widgets/trending/trending.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainSearchPage extends StatefulWidget {
  final OnWantsToReactToPost onWantsToReactToPost;
  final OBMainSearchPageController controller;

  const OBMainSearchPage({Key key, this.onWantsToReactToPost, this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBMainSearchPageState();
  }
}

class OBMainSearchPageState extends OBBasePageState<OBMainSearchPage> {
  UserService _userService;
  ToastService _toastService;

  bool _hasSearch;
  bool _requestInProgress;
  String _searchQuery;
  List<User> _userSearchResults;
  OBTrendingController _trendingController;

  StreamSubscription<UsersList> _getUsersWithQuerySubscription;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller.attach(this);
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

    Widget currentWidget;

    if (_requestInProgress) {
      currentWidget = Container(
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
        onWantsToSeeUserProfile: _onWantsToSeeUserProfile,
        onWantsToSeePostComments: _onWantsToSeePostComments,
        onWantsToCommentPost: _onWantsToCommentPost,
        onWantsToReactToPost: widget.onWantsToReactToPost,
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

  Future<List<User>> _searchForUsersWithQuery(String query) async {
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
    _onWantsToSeeUserProfile(user);
  }

  void _onWantsToSeeUserProfile(User user) async {
    incrementPushedRoutes();
    await Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => Material(
              child: OBProfilePage(
                user,
                onWantsToSeeUserProfile: _onWantsToSeeUserProfile,
                onWantsToSeePostComments: _onWantsToSeePostComments,
                onWantsToCommentPost: _onWantsToCommentPost,
                onWantsToReactToPost: widget.onWantsToReactToPost,
              ),
            )));
    decrementPushedRoutes();
  }

  void _onWantsToCommentPost(Post post) async {
    incrementPushedRoutes();
    await Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => Material(
              child: OBPostPage(post,
                  autofocusCommentInput: true,
                  onWantsToReactToPost: widget.onWantsToReactToPost),
            )));
    decrementPushedRoutes();
  }

  void _onWantsToSeePostComments(Post post) async {
    incrementPushedRoutes();
    await Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => Material(
              child: OBPostPage(post,
                  autofocusCommentInput: false,
                  onWantsToReactToPost: widget.onWantsToReactToPost),
            )));
    decrementPushedRoutes();
  }

  @override
  void scrollToTop() {
    _trendingController.scrollToTop();
  }
}

class OBMainSearchPageController
    extends OBBasePageStateController<OBMainSearchPageState> {}
