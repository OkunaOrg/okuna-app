import 'dart:async';

import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/widgets/alerts/button_alert.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

class OBHttpList<T> extends StatefulWidget {
  final OBHttpListItemBuilder<T> listItemBuilder;
  final OBHttpListItemBuilder<T> searchResultListItemBuilder;
  final OBHttpListSearcher<T> listSearcher;
  final OBHttpListRefresher<T> listRefresher;
  final OBHttpListOnScrollLoader<T> listOnScrollLoader;
  final OBHttpListController controller;
  final String resourceSingularName;
  final String resourcePluralName;
  final EdgeInsets padding;
  final IndexedWidgetBuilder separatorBuilder;
  final ScrollPhysics physics;

  const OBHttpList(
      {Key key,
      @required this.listItemBuilder,
      @required this.listRefresher,
      @required this.listOnScrollLoader,
      @required this.resourceSingularName,
      @required this.resourcePluralName,
      this.physics = const ClampingScrollPhysics(),
      this.padding = const EdgeInsets.all(0),
      this.listSearcher,
      this.searchResultListItemBuilder,
      this.controller,
      this.separatorBuilder})
      : super(key: key);

  @override
  OBHttpListState createState() {
    return OBHttpListState<T>();
  }
}

class OBHttpListState<T> extends State<OBHttpList<T>> {
  ToastService _toastService;

  GlobalKey<RefreshIndicatorState> _listRefreshIndicatorKey;
  ScrollController _listScrollController;
  List<T> _list = [];
  List<T> _listSearchResults = [];

  bool _hasSearch;
  String _searchQuery;
  bool _needsBootstrap;
  bool _refreshInProgress;
  bool _searchRequestInProgress;
  bool _loadingFinished;

  StreamSubscription<List<T>> _searchRequestSubscription;

  ScrollPhysics noItemsPhysics = const AlwaysScrollableScrollPhysics();

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller.attach(this);
    _listScrollController = ScrollController();
    _listRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _loadingFinished = false;
    _needsBootstrap = true;
    _refreshInProgress = false;
    _searchRequestInProgress = false;
    _hasSearch = false;
    _list = [];
    _searchQuery = '';
  }

  void insertListItem(T listItem, {bool shouldScrollToTop = true}) {
    this._list.insert(0, listItem);
    this._setList(this._list.toList());
    if (shouldScrollToTop) scrollToTop();
  }

  void removeListItem(T listItem) {
    setState(() {
      _list.remove(listItem);
      _listSearchResults.remove(listItem);
    });
  }

  void scrollToTop() {
    if (_listScrollController.offset == 0) {
      _listRefreshIndicatorKey.currentState.show();
    }

    _listScrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _toastService = provider.toastService;
      _bootstrap();
      _needsBootstrap = false;
    }

    List<Widget> columnItems = [];

    if (widget.listSearcher != null) {
      columnItems.add(SizedBox(
          child: OBSearchBar(
        onSearch: _onSearch,
        hintText: 'Search ' + widget.resourcePluralName + '...',
      )));
    }

    columnItems.add(
        Expanded(child: _hasSearch ? _buildSearchResultsList() : _buildList()));

    return Column(
      children: columnItems,
      mainAxisSize: MainAxisSize.max,
    );
  }

  Widget _buildSearchResultsList() {
    int listItemCount = _listSearchResults.length + 1;

    ScrollPhysics physics = listItemCount > 0 ? widget.physics : noItemsPhysics;

    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        // Hide keyboard
        FocusScope.of(context).requestFocus(new FocusNode());
        return true;
      },
      child: widget.separatorBuilder != null
          ? ListView.separated(
              separatorBuilder: widget.separatorBuilder,
              padding: widget.padding,
              physics: physics,
              itemCount: listItemCount,
              itemBuilder: _buildSearchResultsListItem)
          : ListView.builder(
              padding: widget.padding,
              physics: physics,
              itemCount: listItemCount,
              itemBuilder: _buildSearchResultsListItem),
    );
  }

  Widget _buildSearchResultsListItem(BuildContext context, int index) {
    if (index == _listSearchResults.length) {
      String searchQuery = _searchQuery;

      if (_searchRequestInProgress) {
        // Search in progress
        return ListTile(
            leading: const OBProgressIndicator(),
            title: OBText('Searching for $searchQuery'));
      } else if (_listSearchResults.isEmpty) {
        // Results were empty
        return ListTile(
            leading: const OBIcon(OBIcons.sad),
            title: OBText('No results for $searchQuery.'));
      } else {
        return const SizedBox();
      }
    }

    T listItem = _listSearchResults[index];

    return widget.searchResultListItemBuilder(context, listItem);
  }

  Widget _buildList() {
    return _list.isEmpty && !_refreshInProgress
        ? _buildNoList()
        : RefreshIndicator(
            key: _listRefreshIndicatorKey,
            child: LoadMore(
                whenEmptyLoad: false,
                isFinish: _loadingFinished,
                delegate: const OBHttpListLoadMoreDelegate(),
                child: widget.separatorBuilder != null
                    ? ListView.separated(
                        separatorBuilder: widget.separatorBuilder,
                        controller: _listScrollController,
                        physics: widget.physics,
                        padding: widget.padding,
                        itemCount: _list.length,
                        itemBuilder: _buildListItem)
                    : ListView.builder(
                        controller: _listScrollController,
                        physics: widget.physics,
                        padding: widget.padding,
                        itemCount: _list.length,
                        itemBuilder: _buildListItem),
                onLoadMore: _loadMoreListItems),
            onRefresh: _refreshList);
  }

  Widget _buildNoList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OBButtonAlert(
          text: 'No ' + widget.resourcePluralName + ' found.',
          onPressed: _refreshList,
          buttonText: 'Refresh',
          buttonIcon: OBIcons.refresh,
          assetImage: 'assets/images/stickers/perplexed-owl.png',
        )
      ],
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    T listItem = _list[index];

    return widget.listItemBuilder(context, listItem);
  }

  void _bootstrap() async {
    await _refreshList();
  }

  Future<void> _refreshList() async {
    _setLoadingFinished(false);
    _setRefreshInProgress(true);
    try {
      _list = await widget.listRefresher();
      _setList(_list);
    } catch (error) {
      _onError(error);
    } finally {
      _setRefreshInProgress(false);
    }
  }

  Future refreshList(
      {bool shouldScrollToTop = false,
      bool shouldUseRefreshIndicator = false}) async {
    await (shouldUseRefreshIndicator
        ? _listRefreshIndicatorKey.currentState.show()
        : _refreshList());
    if (shouldScrollToTop && _listScrollController.offset != 0) {
      scrollToTop();
    }
  }

  Future<bool> _loadMoreListItems() async {
    try {
      List<T> moreListItems = await widget.listOnScrollLoader(_list);

      if (moreListItems.length == 0) {
        _setLoadingFinished(true);
      } else {
        _addListItems(moreListItems);
      }
      return true;
    } catch (error) {
      _onError(error);
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
    if (_searchRequestSubscription != null) _searchRequestSubscription.cancel();

    _setSearchRequestInProgress(true);

    _searchRequestSubscription =
        widget.listSearcher(_searchQuery).asStream().listen(
            (List<T> listSearchResults) {
              _searchRequestSubscription = null;
              _setListSearchResults(listSearchResults);
            },
            onError: _onError,
            onDone: () {
              _setSearchRequestInProgress(false);
            });
  }

  void _resetListSearchResults() {
    _setListSearchResults(_list.toList());
  }

  void _setListSearchResults(List<T> listSearchResults) {
    setState(() {
      _listSearchResults = listSearchResults;
    });
  }

  void _setLoadingFinished(bool loadingFinished) {
    setState(() {
      _loadingFinished = loadingFinished;
    });
  }

  void _setList(List<T> list) {
    setState(() {
      this._list = list;
      _resetListSearchResults();
    });
  }

  void _addListItems(List<T> items) {
    setState(() {
      this._list.addAll(items);
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

  void _setRefreshInProgress(bool refreshInProgress) {
    setState(() {
      _refreshInProgress = refreshInProgress;
    });
  }

  void _setSearchRequestInProgress(bool searchRequestInProgress) {
    setState(() {
      _searchRequestInProgress = searchRequestInProgress;
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
}

class OBHttpListController<T> {
  OBHttpListState _state;

  void attach(OBHttpListState state) {
    _state = state;
  }

  void insertListItem(T listItem, {bool shouldScrollToTop = true}) {
    if (!_isAttached() || !_state.mounted) return;
    _state.insertListItem(listItem, shouldScrollToTop: shouldScrollToTop);
  }

  void removeListItem(T listItem) {
    if (!_isAttached() || !_state.mounted) return;
    _state.removeListItem(listItem);
  }

  void scrollToTop() {
    if (!_isAttached() || !_state.mounted) return;
    _state.scrollToTop();
  }

  Future refresh(
      {bool shouldScrollToTop = false,
      bool shouldUseRefreshIndicator = false}) async {
    if (!_state.mounted) return;
    _state.refreshList(
        shouldScrollToTop: shouldScrollToTop,
        shouldUseRefreshIndicator: shouldUseRefreshIndicator);
  }

  bool hasItems() {
    return _state._list.isNotEmpty;
  }

  T firstItem() {
    return _state._list.first;
  }

  bool _isAttached() {
    return _state != null;
  }
}

typedef Widget OBHttpListItemBuilder<T>(BuildContext context, T listItem);
typedef Future<List<T>> OBHttpListSearcher<T>(String searchQuery);
typedef Future<List<T>> OBHttpListRefresher<T>();
typedef Future<List<T>> OBHttpListOnScrollLoader<T>(List<T> currentList);

class OBHttpListLoadMoreDelegate extends LoadMoreDelegate {
  const OBHttpListLoadMoreDelegate();

  @override
  Widget buildChild(LoadMoreStatus status,
      {LoadMoreTextBuilder builder = DefaultLoadMoreTextBuilder.chinese}) {
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
