import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/user.dart';
import 'package:Okuna/models/users_list.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/http_list.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/tiles/user_tile.dart';
import 'package:flutter/material.dart';

class OBPostParticipantsSearchBox extends StatefulWidget {
  final ValueChanged<User> onPostParticipantPressed;
  final Post post;
  final OBPostParticipantsSearchBoxController controller;

  const OBPostParticipantsSearchBox(
      {Key key,
      this.onPostParticipantPressed,
      @required this.post,
      this.controller})
      : super(key: key);

  @override
  OBPostParticipantsSearchBoxState createState() {
    return OBPostParticipantsSearchBoxState();
  }
}

class OBPostParticipantsSearchBoxState
    extends State<OBPostParticipantsSearchBox> {
  UserService _userService;
  LocalizationService _localizationService;
  OBHttpListController _httpListController;

  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _httpListController = OBHttpListController();
    if (widget.controller != null) widget.controller.attach(this);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _localizationService = openbookProvider.localizationService;
      _needsBootstrap = false;
    }

    return OBPrimaryColorContainer(
        child: OBHttpList<User>(
            controller: _httpListController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            listItemBuilder: _buildPostParticipantItem,
            searchResultListItemBuilder: _buildPostParticipantItem,
            listRefresher: _refreshPostParticipants,
            listOnScrollLoader: _loadMorePostParticipants,
            listSearcher: _searchPostParticipants,
            resourceSingularName: _localizationService
                .post__comments_page_search_post_participant,
            resourcePluralName: _localizationService
                .post__comments_page_search_post_participants,
            hasSearchBar: false));
  }

  Widget _buildPostParticipantItem(BuildContext context, User postParticipant) {
    return OBUserTile(
      postParticipant,
      onUserTilePressed: widget.onPostParticipantPressed,
    );
  }

  Future<List<User>> _refreshPostParticipants() async {
    UsersList postParticipants =
        await _userService.getPostParticipants(post: widget.post);
    return postParticipants.users;
  }

  Future<List<User>> _loadMorePostParticipants(
      List<User> postParticipantsList) async {
    return [];
  }

  Future<List<User>> _searchPostParticipants(String query) async {
    UsersList results = await _userService.searchPostParticipants(
        query: query, post: widget.post);

    return results.users;
  }

  Future _search(String query) {
    return _httpListController.search(query);
  }
}

class OBPostParticipantsSearchBoxController {
  OBPostParticipantsSearchBoxState _state;

  void attach(OBPostParticipantsSearchBoxState state) {
    _state = state;
  }

  Future searchPostParticipants(String searchQuery) async {
    if(_state == null || !_state.mounted) return null;
    return _state._search(searchQuery);
  }
}
