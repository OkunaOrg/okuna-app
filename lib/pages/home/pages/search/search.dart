import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:Openbook/pages/home/pages/post/post.dart';
import 'package:Openbook/pages/home/pages/post/widgets/expanded_post_comment.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/pages/home/pages/search/widgets/user_search_results.dart';
import 'package:Openbook/pages/home/pages/search/widgets/trending.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainSearchPage extends StatefulWidget {
  final OnWantsToReactToPost onWantsToReactToPost;
  final OnWantsToSeeUserProfile onWantsToSeeUserProfile;

  const OBMainSearchPage(
      {Key key, this.onWantsToReactToPost, this.onWantsToSeeUserProfile})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBMainSearchPageState();
  }
}

class OBMainSearchPageState extends State<OBMainSearchPage> {
  UserService _userService;
  ToastService _toastService;

  bool _hasSearch;
  int _pushedRoutes;
  bool _requestInProgress;
  String _searchQuery;
  List<User> _userSearchResults;

  @override
  void initState() {
    super.initState();
    _pushedRoutes = 0;
    _requestInProgress = false;
    _hasSearch = false;
    _userSearchResults = [];
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                OBSearchBar(
                  onSearch: _onSearch,
                  hintText: 'Search...',
                ),
                Expanded(
                    child: _hasSearch
                        ? OBUserSearchResults(
                            _userSearchResults,
                            _searchQuery,
                            onSearchUserPressed: _onSearchUserPressed,
                          )
                        : OBTrending())
              ],
            )));
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
    _setRequestInProgress(true);

    try {
      UsersList usersList = await _userService.getUsersWithQuery(query);
      _setUserSearchResults(usersList.users);
      // Remove modal
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    } finally {
      _setRequestInProgress(false);
    }
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
    _incrementPushedRoutes();
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
    _decrementPushedRoutes();
  }

  void _onWantsToCommentPost(Post post) async {
    _incrementPushedRoutes();
    await Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => Material(
              child: OBPostPage(post,
                  autofocusCommentInput: true,
                  onWantsToReactToPost: widget.onWantsToReactToPost),
            )));
    _decrementPushedRoutes();
  }

  void _onWantsToSeePostComments(Post post) async {
    _incrementPushedRoutes();
    await Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => Material(
              child: OBPostPage(post,
                  autofocusCommentInput: false,
                  onWantsToReactToPost: widget.onWantsToReactToPost),
            )));
    _decrementPushedRoutes();
  }

  void _incrementPushedRoutes() {
    _pushedRoutes += 1;
  }

  void _decrementPushedRoutes() {
    if (_pushedRoutes == 0) return;
    _pushedRoutes -= 1;
  }
}
