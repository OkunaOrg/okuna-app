import 'package:Okuna/models/hashtags_list.dart';
import 'package:Okuna/models/hashtag.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/progress_indicator.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:Okuna/widgets/tiles/hashtag_tile.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

class OBContextualHashtagSearchBox extends StatefulWidget {
  final ValueChanged<Hashtag> onHashtagPressed;
  final OBContextualHashtagSearchBoxController controller;
  final String initialSearchQuery;

  const OBContextualHashtagSearchBox(
      {Key key,
        this.onHashtagPressed,
        this.controller,
        this.initialSearchQuery})
      : super(key: key);

  @override
  OBContextualHashtagSearchBoxState createState() {
    return OBContextualHashtagSearchBoxState();
  }
}

class OBContextualHashtagSearchBoxState
    extends State<OBContextualHashtagSearchBox> {
  UserService _userService;
  LocalizationService _localizationService;
  ToastService _toastService;

  bool _needsBootstrap;

  CancelableOperation _getAllOperation;
  CancelableOperation _searchParticipantsOperation;

  String _searchQuery;
  List<Hashtag> _all;
  bool _getAllInProgress;
  List<Hashtag> _searchResults;
  bool _searchInProgress;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    if (widget.controller != null) widget.controller.attach(this);
    _all = [];
    _searchResults = [];
    _searchQuery = '';
    _searchInProgress = false;
    _getAllInProgress = false;
  }

  @override
  void dispose() {
    _searchParticipantsOperation?.cancel();
    _getAllOperation?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _localizationService = openbookProvider.localizationService;
      _toastService = openbookProvider.toastService;
      _bootstrap();
      _needsBootstrap = false;
      if (widget.initialSearchQuery != null &&
          widget.initialSearchQuery.isNotEmpty) {
        _searchQuery = widget.initialSearchQuery;
        _searchInProgress = true;
        Future.delayed(Duration(milliseconds: 0), () {
          search(widget.initialSearchQuery);
        });
      }
    }

    return OBPrimaryColorContainer(
        child: _buildSearchResultsList());
  }

  Widget _buildSearchResultsList() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.separated(
            itemBuilder: _buildResultItem,
            itemCount: _searchResults.length + 1,
            padding: const EdgeInsets.all(0),
            separatorBuilder: _buildListItemSeparator,
          ),
        )
      ],
    );
  }

  Widget _buildListItemSeparator(BuildContext context, int index) {
    return const SizedBox(height: 10);
  }

  Widget _buildResultItem(BuildContext context, int index) {
    if (index == _searchResults.length) {
      // LastItem
      if (_searchInProgress) {
        // Search in progress
        return const Padding(
          padding: EdgeInsets.all(10),
          child: Center(child: OBProgressIndicator()),
        );
      } else if (_searchResults.isEmpty) {
        return ListTile(
            leading: const OBIcon(OBIcons.sad),
            title: OBText('No results found'));
      } else {
        return const SizedBox();
      }
    }

    return OBHashtagTile(
      _searchResults[index],
      key: Key(_searchResults[index].id.toString()),
      onHashtagTilePressed: widget.onHashtagPressed,
    );
  }

  Widget _buildAllItem(BuildContext context, int index) {
    return OBHashtagTile(
      _all[index],
      key: Key(_all[index].id.toString()),
      onHashtagTilePressed: widget.onHashtagPressed,
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Center(child: OBProgressIndicator()),
    );
  }

  void _bootstrap() {
    debugLog('Bootstrapping');
    refreshAll();
  }

  Future refreshAll() async {
    if (_getAllOperation != null) _getAllOperation.cancel();

    _setGetAllInProgress(true);

    debugLog('Refreshing all hashtags');

    try {
      _getAllOperation =
          CancelableOperation.fromFuture(_userService.getSuggestedHashtags());
      HashtagsList all = await _getAllOperation.value;
      _setAll(all.hashtags);
    } catch (error) {
      _onError(error);
    } finally {
      _setGetAllInProgress(false);
      _getAllOperation = null;
    }
  }

  Future search(String searchQuery) async {
    if (_searchParticipantsOperation != null)
      _searchParticipantsOperation.cancel();
    _setSearchInProgress(true);

    debugLog('Searching post participants with query:$searchQuery');

    if (searchQuery == null || searchQuery.isEmpty) {
      clearSearch();
      return null;
    }

    _setSearchQuery(searchQuery);

    try {
      _searchParticipantsOperation = CancelableOperation.fromFuture(
          _userService.getHashtagsWithQuery(searchQuery));
      HashtagsList searchResults = await _searchParticipantsOperation.value;
      _setSearchResults(searchResults.hashtags);
    } catch (error) {
      _onError(error);
    } finally {
      _setSearchInProgress(false);
      _searchParticipantsOperation = null;
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setSearchResults(List<Hashtag> searchResults) {
    setState(() {
      _searchResults = searchResults;
    });
  }

  void _setAll(List<Hashtag> all) {
    setState(() {
      _all = all;
    });
  }

  void _setSearchQuery(String searchQuery) {
    setState(() {
      _searchQuery = searchQuery;
    });
  }

  void _setSearchInProgress(bool searchInProgress) {
    setState(() {
      _searchInProgress = searchInProgress;
    });
  }

  void _setGetAllInProgress(bool getAllInProgress) {
    setState(() {
      _getAllInProgress = getAllInProgress;
    });
  }

  void clearSearch() {
    debugLog('Clearing search');
    setState(() {
      if (_searchParticipantsOperation != null)
        _searchParticipantsOperation.cancel();
      _searchInProgress = false;
      _searchQuery = '';
      _searchResults = [];
    });
  }

  void debugLog(String log) {
    debugPrint('OBContextualHashtagSearchBox:$log');
  }
}

class OBContextualHashtagSearchBoxController {
  OBContextualHashtagSearchBoxState _state;
  String _lastSearchQuery;

  void attach(OBContextualHashtagSearchBoxState state) {
    _state = state;
  }

  Future search(String searchQuery) async {
    _lastSearchQuery = searchQuery;

    if (_state == null || !_state.mounted) {
      debugLog('Tried to search without mounted state');
      return null;
    }

    return _state.search(searchQuery);
  }

  void clearSearch() {
    _lastSearchQuery = null;
    _state.clearSearch();
  }

  String getLastSearchQuery() {
    return _lastSearchQuery;
  }

  void debugLog(String log) {
    debugPrint('OBContextualHashtagSearchBoxController:$log');
  }
}
