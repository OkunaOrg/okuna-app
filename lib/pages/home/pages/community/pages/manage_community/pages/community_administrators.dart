import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/buttons/accent_button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/icon_button.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/services/httpie.dart';

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
  UserService _userService;
  ToastService _toastService;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  ScrollController _communityAdministratorsScrollController;
  List<User> _communityAdministrators = [];
  List<User> _communityAdministratorsSearchResults = [];
  String _searchQuery;

  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _communityAdministratorsScrollController = ScrollController();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _needsBootstrap = true;
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
              child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      controller: _communityAdministratorsScrollController,
                      padding: EdgeInsets.all(0),
                      itemCount:
                          _communityAdministratorsSearchResults.length + 1,
                      itemBuilder: (context, index) {
                        if (index ==
                            _communityAdministratorsSearchResults.length) {
                          if (_communityAdministratorsSearchResults.isEmpty) {
                            // Results were empty
                            return ListTile(
                                leading: OBIcon(OBIcons.sad),
                                title: OBText(
                                    'No administrators found for "$_searchQuery"'));
                          } else {
                            return const SizedBox();
                          }
                        }

                        int commentIndex = index;

                        var communityAdministrator =
                            _communityAdministratorsSearchResults[commentIndex];

                        return OBUserTile(
                          communityAdministrator,
                          onUserTileDeleted: _removeCommunityAdministrator,
                        );
                      }),
                  onRefresh: _refreshAdministrators),
            ),
          ],
        ),
      ),
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
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (error) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    }
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      _resetCommunityAdministratorsSearchResults();
      _setSearchQuery(null);
      return;
    }

    _setSearchQuery(query);
    String uppercaseQuery = query.toUpperCase();
    var searchResults =
        _communityAdministrators.where((communityAdministrator) {
      return communityAdministrator
              .getProfileName()
              .toUpperCase()
              .contains(uppercaseQuery) ||
          communityAdministrator.username
              .toUpperCase()
              .contains(uppercaseQuery);
    }).toList();

    _setCommunityAdministratorsSearchResults(searchResults);
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

  void _setSearchQuery(String searchQuery) {
    setState(() {
      _searchQuery = searchQuery;
    });
  }
}

typedef Future<User> OnWantsToCreateCommunityAdministrator();
typedef Future<User> OnWantsToEditCommunityAdministrator(
    User communityAdministrator);
typedef void OnWantsToSeeCommunityAdministrator(User communityAdministrator);
