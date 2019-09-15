import 'dart:math';

import 'package:Okuna/models/post.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/widgets/post/post.dart';
import 'package:Okuna/widgets/posts_stream/widgets/dr_hoo.dart';
import 'package:Okuna/widgets/theming/secondary_text.dart';
import 'package:Okuna/widgets/tiles/loading_indicator_tile.dart';
import 'package:Okuna/widgets/tiles/retry_tile.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

var rng = new Random();

class OBPostsStream extends StatefulWidget {
  final List<Widget> prependedItems;
  final OBPostsStreamRefresher refresher;
  final OBPostsStreamOnScrollLoader onScrollLoader;
  final OBPostsStreamController controller;
  final List<Post> initialPosts;
  final String streamIdentifier;
  final ValueChanged<List<Post>> onPostsRefreshed;
  final bool refreshOnCreate;
  final OBPostsStreamSecondaryRefresher secondaryRefresher;
  final OBPostsStreamStatusIndicatorBuilder statusIndicatorBuilder;

  const OBPostsStream(
      {Key key,
      this.prependedItems,
      @required this.refresher,
      @required this.onScrollLoader,
      this.controller,
      this.initialPosts,
      @required this.streamIdentifier,
      this.onPostsRefreshed,
      this.refreshOnCreate = true,
      this.secondaryRefresher,
      this.statusIndicatorBuilder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBPostsStreamState();
  }
}

class OBPostsStreamState extends State<OBPostsStream> {
  List<Post> _posts;
  bool _needsBootstrap;
  ToastService _toastService;
  LocalizationService _localizationService;
  ScrollController _streamScrollController;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  OBPostsStreamStatus _status;

  CancelableOperation _refreshOperation;
  CancelableOperation _secondaryRefresherOperation;
  CancelableOperation _loadMoreOperation;

  String _streamUniqueIdentifier;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller.attach(this);
    _posts = widget.initialPosts != null ? widget.initialPosts.toList() : [];
    _needsBootstrap = true;
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _status = OBPostsStreamStatus.refreshing;
    _streamScrollController = ScrollController();
    _streamScrollController.addListener(_onScroll);
    _streamUniqueIdentifier =
        '${widget.streamIdentifier}_${rng.nextInt(1000).toString()}';
  }

  @override
  void dispose() {
    super.dispose();
    _streamScrollController.removeListener(_onScroll);
    _secondaryRefresherOperation?.cancel();
    _refreshOperation?.cancel();
    _loadMoreOperation?.cancel();
  }

  void _bootstrap() {
    if (widget.refreshOnCreate) {
      Future.delayed(Duration(milliseconds: 100), () {
        _refresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _toastService = provider.toastService;
      _localizationService = provider.localizationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshPosts,
      child: _buildStream(),
    );
  }

  Widget _buildStream() {
    List<Widget> streamItems = [];
    bool hasPrependedItems =
        widget.prependedItems != null && widget.prependedItems.isNotEmpty;
    if (hasPrependedItems) streamItems.addAll(widget.prependedItems);

    if (_posts.isEmpty) {
      OBPostsStreamStatusIndicatorBuilder statusIndicatorBuilder =
          widget.statusIndicatorBuilder ?? defaultStatusIndicatorBuilder;

      streamItems.add(statusIndicatorBuilder(
        context: context,
        streamStatus: _status,
        streamRefresher: _refresh,
        streamPrependedItems: widget.prependedItems,
      ));
    } else {
      streamItems.addAll(_buildStreamPosts());
      if (_status != OBPostsStreamStatus.idle)
        streamItems.add(_buildStatusTile());
    }

    return InViewNotifierList(
      key: Key(_streamUniqueIdentifier),
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(0),
      controller: _streamScrollController,
      isInViewPortCondition: _checkTimelineItemIsInViewport,
      children: streamItems,
    );
  }

  List<Widget> _buildStreamPosts() {
    return _posts.map(_buildStreamPost).toList();
  }

  Widget _buildStreamPost(Post post) {
    String inViewId = '${_streamUniqueIdentifier}_${post.id.toString()}';

    return OBPost(
      post,
      key: Key(inViewId),
      onPostDeleted: _onPostDeleted,
      inViewId: inViewId,
    );
  }

  Widget _buildStatusTile() {
    Widget statusTile;
    Key statusKey = Key('${_streamUniqueIdentifier}_status_tile');

    switch (_status) {
      case OBPostsStreamStatus.loadingMore:
        return Padding(
          key: statusKey,
          padding: const EdgeInsets.all(20),
          child: const OBLoadingIndicatorTile(),
        );
        break;
      case OBPostsStreamStatus.loadingMoreFailed:
        return OBRetryTile(
          key: statusKey,
          onWantsToRetry: _loadMorePosts,
        );
        break;
      case OBPostsStreamStatus.noMoreToLoad:
        return ListTile(
          key: statusKey,
          title: OBSecondaryText(
            _localizationService.posts_stream__status_tile_no_more_to_load,
            textAlign: TextAlign.center,
          ),
        );
      case OBPostsStreamStatus.empty:
        return ListTile(
          key: statusKey,
          title: OBSecondaryText(
            _localizationService.posts_stream__status_tile_empty,
            textAlign: TextAlign.center,
          ),
        );
      default:
    }

    return statusTile;
  }

  bool _checkTimelineItemIsInViewport(
    double deltaTop,
    double deltaBottom,
    double viewPortDimension,
  ) {
    return deltaTop < (0.5 * viewPortDimension) &&
        deltaBottom > (0.5 * viewPortDimension);
  }

  void _scrollToTop({bool skipRefresh = false}) {
    if (_streamScrollController.hasClients) {
      if (_streamScrollController.offset == 0 && !skipRefresh) {
        _refreshIndicatorKey.currentState.show();
      }

      _streamScrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  void _addPostToTop(Post post) {
    setState(() {
      this._posts.insert(0, post);
      if (this._status == OBPostsStreamStatus.empty)
        _setStatus(OBPostsStreamStatus.idle);
    });
  }

  void _onScroll() {
    if (_status == OBPostsStreamStatus.loadingMore ||
        _status == OBPostsStreamStatus.noMoreToLoad) return;
    if (_streamScrollController.position.pixels >
        _streamScrollController.position.maxScrollExtent * 0.1) {
      _loadMorePosts();
    }
  }

  void _ensureNoRefreshPostsInProgress() {
    if (_refreshOperation != null) {
      _refreshOperation.cancel();
      _refreshOperation = null;
    }
  }

  void _ensureNoLoadMoreInProgress() {
    if (_loadMoreOperation != null) {
      _loadMoreOperation.cancel();
      _loadMoreOperation = null;
    }
  }

  Future _refresh() {
    return _refreshIndicatorKey.currentState.show();
  }

  Future<void> _refreshPosts() async {
    debugLog('Refreshing posts');
    _ensureNoRefreshPostsInProgress();
    _setStatus(OBPostsStreamStatus.refreshing);
    try {
      _refreshOperation = CancelableOperation.fromFuture(widget.refresher());

      List<Future> refreshFutures = [_refreshOperation.value];

      if (widget.secondaryRefresher != null) {
        _secondaryRefresherOperation =
            CancelableOperation.fromFuture(widget.secondaryRefresher());
        refreshFutures.add(_secondaryRefresherOperation.value);
      }

      List<dynamic> results = await Future.wait(refreshFutures);
      List<Post> posts = results[0];

      if (posts.length == 0) {
        _setStatus(OBPostsStreamStatus.empty);
      } else {
        _setStatus(OBPostsStreamStatus.idle);
      }
      _setPosts(posts);
      if (widget.onPostsRefreshed != null) widget.onPostsRefreshed(posts);
    } catch (error) {
      _setStatus(OBPostsStreamStatus.loadingMoreFailed);
      _onError(error);
    } finally {
      _refreshOperation = null;
      _secondaryRefresherOperation = null;
    }
  }

  Future _loadMorePosts() async {
    if (_status == OBPostsStreamStatus.refreshing ||
        _status == OBPostsStreamStatus.noMoreToLoad ||
        _status == OBPostsStreamStatus.loadingMore ||
        _posts.isEmpty) return null;
    debugLog('Loading more posts');
    _ensureNoLoadMoreInProgress();
    _setStatus(OBPostsStreamStatus.loadingMore);

    try {
      _loadMoreOperation =
          CancelableOperation.fromFuture(widget.onScrollLoader(_posts));

      List<Post> morePosts = await _loadMoreOperation.value;

      if (morePosts.length == 0) {
        _setStatus(OBPostsStreamStatus.noMoreToLoad);
      } else {
        _setStatus(OBPostsStreamStatus.idle);
        _addPosts(morePosts);
      }
    } catch (error) {
      _setStatus(OBPostsStreamStatus.loadingMoreFailed);
      _onError(error);
    } finally {
      _loadMoreOperation = null;
    }
  }

  void _onPostDeleted(Post deletedPost) {
    setState(() {
      _posts.remove(deletedPost);
      if (_posts.isEmpty) _setStatus(OBPostsStreamStatus.empty);
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
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setPosts(List<Post> posts) {
    setState(() {
      _posts = posts;
    });
  }

  void _addPosts(List<Post> posts) {
    setState(() {
      _posts.addAll(posts);
    });
  }

  void _setStatus(OBPostsStreamStatus status) {
    setState(() {
      _status = status;
    });
  }

  void debugLog(String log) {
    //debugPrint('OBPostsStream:${widget.streamIdentifier}: $log');
  }
}

class OBPostsStreamController {
  OBPostsStreamState _state;

  /// Register the OBHomePostsState to the controller
  void attach(OBPostsStreamState state) {
    assert(state != null, 'Cannot attach to empty state');
    _state = state;
  }

  void scrollToTop({bool skipRefresh = false}) {
    _state._scrollToTop(skipRefresh: skipRefresh);
  }

  void addPostToTop(Post post) {
    _state._addPostToTop(post);
  }

  Future refreshPosts() {
    return _state._refreshPosts();
  }

  bool isAttached() {
    return _state != null;
  }
}

enum OBPostsStreamStatus {
  refreshing,
  loadingMore,
  loadingMoreFailed,
  noMoreToLoad,
  empty,
  idle
}

Widget defaultStatusIndicatorBuilder(
    {BuildContext context,
    OBPostsStreamStatus streamStatus,
    List<Widget> streamPrependedItems,
    Function streamRefresher}) {
  return OBPostsStreamDrHoo(
    streamStatus: streamStatus,
    streamPrependedItems: streamPrependedItems,
    streamRefresher: streamRefresher,
  );
}

typedef Future<List<Post>> OBPostsStreamRefresher<Post>();
typedef Future<List<Post>> OBPostsStreamOnScrollLoader<T>(List<Post> posts);
typedef Future OBPostsStreamSecondaryRefresher();

typedef OBPostsStreamStatusIndicatorBuilder = Widget Function(
    {@required BuildContext context,
    @required OBPostsStreamStatus streamStatus,
    @required List<Widget> streamPrependedItems,
    @required Function streamRefresher});
