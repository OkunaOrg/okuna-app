import 'package:Okuna/models/post.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/widgets/buttons/button.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/post/post.dart';
import 'package:Okuna/widgets/theming/secondary_text.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:Okuna/widgets/tiles/loading_indicator_tile.dart';
import 'package:Okuna/widgets/tiles/retry_tile.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

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
  final WidgetBuilder statusTileEmptyBuilder;

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
      this.statusTileEmptyBuilder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBPostsStreamState();
  }
}

class OBPostsStreamState extends State<OBPostsStream> {
  List<Post> _posts;
  bool _needsBootstrap;
  bool _isFirstLoad;
  ToastService _toastService;
  LocalizationService _localizationService;
  ScrollController _streamScrollController;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  OBPostsStreamStatus _status;

  CancelableOperation _refreshOperation;
  CancelableOperation _secondaryRefresherOperation;
  bool _refreshInProgress;
  CancelableOperation _loadMoreOperation;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller.attach(this);
    _posts = widget.initialPosts != null ? widget.initialPosts.toList() : [];
    _needsBootstrap = true;
    _isFirstLoad = true;
    _status = OBPostsStreamStatus.refreshing;
    _streamScrollController = ScrollController();
    _streamScrollController.addListener(_onScroll);
    _refreshInProgress = false;
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

    Widget postsStreamWidget = _posts.isEmpty ? _buildDrHoo() : _buildStream();

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshPosts,
      child: postsStreamWidget,
    );
  }

  Widget _buildStream() {
    List<Widget> streamItems = [];
    if (widget.prependedItems != null)
      streamItems.addAll(widget.prependedItems);

    streamItems.addAll(_buildStreamPosts());

    if (_status != OBPostsStreamStatus.idle)
      streamItems.add(_buildStatusTile());
    return InViewNotifierList(
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
    String inViewId = '${widget.streamIdentifier}_${post.id.toString()}';

    return OBPost(
      post,
      key: Key(post.id.toString()),
      onPostDeleted: _onPostDeleted,
      inViewId: inViewId,
    );
  }

  Widget _buildStatusTile() {
    Widget statusTile;

    switch (_status) {
      case OBPostsStreamStatus.loadingMore:
        return OBLoadingIndicatorTile();
        break;
      case OBPostsStreamStatus.loadingMoreFailed:
        return OBRetryTile(
          onWantsToRetry: _loadMorePosts,
        );
        break;
      case OBPostsStreamStatus.noMoreToLoad:
        return ListTile(
          title: OBSecondaryText(
            _localizationService.posts_stream__status_tile_no_more_to_load,
            textAlign: TextAlign.center,
          ),
        );
      case OBPostsStreamStatus.empty:
        if (widget.statusTileEmptyBuilder != null)
          return widget.statusTileEmptyBuilder(context);

        return ListTile(
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

  Widget _buildDrHoo() {
    String drHooTitle;
    String drHooSubtitle;
    bool hasRefreshButton = !_isFirstLoad;
    Function refreshFunction = _refreshPosts;

    switch (_status) {
      case OBPostsStreamStatus.refreshing:
        drHooTitle = _localizationService.posts_stream__refreshing_drhoo_title;
        drHooSubtitle =
            _localizationService.posts_stream__refreshing_drhoo_subtitle;
        break;
      case OBPostsStreamStatus.noMoreToLoad:
        drHooTitle = _localizationService.posts_stream__empty_drhoo_title;
        drHooSubtitle = _localizationService.posts_stream__empty_drhoo_subtitle;
        break;
      case OBPostsStreamStatus.loadingMoreFailed:
        drHooTitle =
            _localizationService.post__timeline_posts_failed_drhoo_title;
        drHooSubtitle =
            _localizationService.post__timeline_posts_failed_drhoo_subtitle;
        refreshFunction = _refresh;
        hasRefreshButton = true;
        break;
      default:
        drHooTitle =
            _localizationService.post__timeline_posts_default_drhoo_title;
        drHooSubtitle =
            _localizationService.post__timeline_posts_default_drhoo_subtitle;
        hasRefreshButton = true;
    }

    List<Widget> drHooColumnItems = [
      Image.asset(
        'assets/images/stickers/owl-instructor.png',
        height: 100,
      ),
      const SizedBox(
        height: 20.0,
      ),
      OBText(
        drHooTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 10.0,
      ),
      OBText(
        drHooSubtitle,
        textAlign: TextAlign.center,
      )
    ];

    if (hasRefreshButton) {
      drHooColumnItems.addAll([
        const SizedBox(
          height: 30,
        ),
        OBButton(
          icon: const OBIcon(
            OBIcons.refresh,
            size: OBIconSize.small,
          ),
          type: OBButtonType.highlight,
          child:
              OBText(_localizationService.post__timeline_posts_refresh_posts),
          onPressed: refreshFunction,
          isLoading: _refreshInProgress != null,
        )
      ]);
    }

    return SizedBox(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: drHooColumnItems,
          ),
        ),
      ),
    );
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
      _refreshOperation =
          await CancelableOperation.fromFuture(widget.refresher());

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
        _status == OBPostsStreamStatus.noMoreToLoad) return null;
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
    debugPrint('OBPostsStream:${widget.streamIdentifier}: $log');
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

typedef Future<List<Post>> OBPostsStreamRefresher<Post>();
typedef Future<List<Post>> OBPostsStreamOnScrollLoader<T>(List<Post> posts);
typedef Future OBPostsStreamSecondaryRefresher();
