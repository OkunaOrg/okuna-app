import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/user_invite.dart';
import 'package:Openbook/pages/home/pages/menu/pages/user_invites/widgets/user_invite_count.dart';
import 'package:Openbook/pages/home/pages/menu/pages/user_invites/widgets/user_invite_tile.dart';
import 'package:Openbook/services/modal_service.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/services/httpie.dart';

class OBUserInvitesPage extends StatefulWidget {
  @override
  State<OBUserInvitesPage> createState() {
    return OBUserInvitesPageState();
  }
}

class OBUserInvitesPageState extends State<OBUserInvitesPage> {
  UserService _userService;
  ToastService _toastService;
  ModalService _modalService;

  User _user;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  ScrollController _userInvitesScrollController;
  List<UserInvite> _userInvites = [];
  List<UserInvite> _userInvitesSearchResults = [];

  String _searchQuery;

  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _userInvitesScrollController = ScrollController();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _needsBootstrap = true;
    _userInvites = [];
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _userService = provider.userService;
      _toastService = provider.toastService;
      _modalService = provider.modalService;
      _user = _userService.getLoggedInUser();
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBThemedNavigationBar(
          title: 'My Invites',
          trailing: Opacity(
              opacity: _user.inviteCount == 0 ? 0.5: 1.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  OBUserInviteCount(
                    count: _user.inviteCount,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OBIconButton(
                    OBIcons.add,
                    themeColor: OBIconThemeColor.primaryAccent,
                    onPressed: _onWantsToCreateInvite,
                  ),
                ],
              ),
          ),
        ),
        child: Stack(
          children: <Widget>[
            OBPrimaryColorContainer(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                        child: OBSearchBar(
                          onSearch: _onSearch,
                          hintText: 'Search for someone...',
                        )),
                    Expanded(
                      child: RefreshIndicator(
                          key: _refreshIndicatorKey,
                          child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              controller: _userInvitesScrollController,
                              padding: EdgeInsets.all(0),
                              itemCount: _userInvitesSearchResults.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _userInvitesSearchResults.length) {
                                  if (_userInvitesSearchResults.isEmpty) {
                                    // Results were empty
                                    if(_searchQuery != null) {
                                      return ListTile(
                                          leading: OBIcon(OBIcons.sad),
                                          title: OBText(
                                              'No one found with nickname "$_searchQuery"'));
                                    }else{
                                      return ListTile(
                                          leading: OBIcon(OBIcons.sad),
                                          title: OBText(
                                              'No invites found.'));
                                    }
                                  } else {
                                    return const SizedBox();
                                  }
                                }

                                var userInvite = _userInvitesSearchResults[index];

                                var onUserInviteDeletedCallback = () {
                                  _removeUserInvite(userInvite);
                                  _refreshUser();
                                };

                                return OBUserInviteTile(
                                  userInvite: userInvite,
                                  onUserInviteDeletedCallback:
                                  onUserInviteDeletedCallback,
                                );
                              }),
                          onRefresh: _refreshInvites),
                    ),
                  ],
                )),
          ],
        ));
  }

  void _bootstrap() async {
    await _refreshInvites();
  }

  Future<void> _refreshInvites() async {
    try {
      await _refreshUser();
      _userInvites = (await _userService.getUserInvites()).invites;
      _setUserInvites(_userInvites);
      _scrollToTop();
    } catch (error) {
      _onError(error);
    }
  }

  Future<void> _refreshUser() async {
      await _userService.refreshUser();
      User refreshedUser = _userService.getLoggedInUser();
      setState(() {
        _user = refreshedUser;
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

  void _onWantsToCreateInvite() async {
    if (_user.inviteCount == 0) {
      _showNoInvitesLeft();
      return;
    }
     UserInvite createdUserInvite =
     await _modalService.openCreateUserInvite(context: context);
    if (createdUserInvite != null) {
      _onUserInviteCreated(createdUserInvite);
    }
  }

  void _showNoInvitesLeft() {
    _toastService.error(message: 'You have no invites left', context: context);
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      _resetUserInvitesSearchResults();
      _setSearchQuery(null);
      return;
    }

    _setSearchQuery(query);
    String uppercaseQuery = query.toUpperCase();
    var searchResults = _userInvites.where((userInvite) {
      return userInvite.nickname.toUpperCase().contains(uppercaseQuery);
    }).toList();

    _setUserInvitesSearchResults(searchResults);
  }

  void _resetUserInvitesSearchResults() {
    _setUserInvitesSearchResults(_userInvites.toList());
  }

  void _setUserInvitesSearchResults(
      List<UserInvite> userInvitesSearchResults) {
    setState(() {
      _userInvitesSearchResults = userInvitesSearchResults;
    });
  }

  void _removeUserInvite(UserInvite userInvite) {
    setState(() {
      _userInvites.remove(userInvite);
      _userInvitesSearchResults.remove(userInvite);
    });
  }

  void _onUserInviteCreated(UserInvite createdUserInvite) {
    _refreshInvites();
    _scrollToTop();
  }

  void _scrollToTop() {
    _userInvitesScrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _setUserInvites(List<UserInvite> userInvites) {
    setState(() {
      this._userInvites = userInvites;
      _resetUserInvitesSearchResults();
    });
  }

  void _setSearchQuery(String searchQuery) {
    setState(() {
      _searchQuery = searchQuery;
    });
  }
}

typedef Future<UserInvite> OnWantsToCreateUserInvite();
typedef Future<UserInvite> OnWantsToEditUserInvite(UserInvite userInvite);
typedef void OnWantsToSeeUserInvite(UserInvite userInvite);
