import 'dart:async';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/posts_list.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/alerts/button_alert.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/post/post.dart';
import 'package:Openbook/widgets/theming/primary_accent_text.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

class OBTrendingPosts extends StatefulWidget {
  final OBTrendingPostsController controller;

  OBTrendingPosts({
    this.controller,
  });

  @override
  State<StatefulWidget> createState() {
    return OBTrendingPostsState();
  }
}

class OBTrendingPostsState extends State<OBTrendingPosts> {
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;

  List<Post> _posts;
  bool _needsBootstrap;
  bool _refreshInProgress;
  bool _wasBootstrapped;

  CancelableOperation _getTrendingPostsOperation;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller.attach(this);
    _needsBootstrap = true;
    _posts = [];
    _scrollController = ScrollController();
    _refreshInProgress = false;
    _wasBootstrapped = false;
  }

  @override
  void dispose() {
    super.dispose();
    if (_getTrendingPostsOperation != null) _getTrendingPostsOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _localizationService = openbookProvider.localizationService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      displacement: 60,
      child: _posts.isEmpty && !_refreshInProgress && !_wasBootstrapped
          ? _buildNoTrendingPostsAlert()
          : ListView.builder(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          itemCount: _posts.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                child: OBPrimaryAccentText(_localizationService.post__trending_posts_title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24)),
              );
            }

            Post post = _posts[index - 1];

            return OBPost(
              post,
              key: Key(post.id.toString()),
              onPostDeleted: _onPostDeleted,
            );
          }),
      onRefresh: refresh,
    );
  }

  Widget _buildNoTrendingPostsAlert() {
    return Column(
      children: <Widget>[
        OBButtonAlert(
          text:
          _localizationService.post__trending_posts_no_trending_posts,
          onPressed: refresh,
          buttonText: _localizationService.post__trending_posts_refresh,
          buttonIcon: OBIcons.refresh,
          assetImage: 'assets/images/stickers/perplexed-owl.png',
        )
      ],
    );
  }

  void _bootstrap() {
    Future.delayed(Duration(milliseconds: 0), () {
      _refreshIndicatorKey.currentState.show();
      setState(() {
        _wasBootstrapped = true;
      });
    });
  }

  void _onPostDeleted(Post post) {
    setState(() {
      _posts.remove(post);
    });
  }

  void scrollToTop() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset == 0) {
        _refreshIndicatorKey.currentState.show();
      }

      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  Future<void> refresh() async {
    _setRefreshInProgress(true);

    try {
      _getTrendingPostsOperation =
          CancelableOperation.fromFuture(_userService.getTrendingPosts());

      PostsList postsList = await _getTrendingPostsOperation.value;
      _setPosts(postsList.posts);

    } catch (error) {
      _onError(error);
    } finally {
      _setRefreshInProgress(false);
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
      _toastService.error(message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setPosts(List<Post> posts) {
    setState(() {
      _posts = posts;
    });
  }

  void _setRefreshInProgress(refreshInProgress) {
    setState(() {
      _refreshInProgress = refreshInProgress;
    });
  }
}

class OBTrendingPostsController {
  OBTrendingPostsState _state;

  void attach(OBTrendingPostsState state) {
    _state = state;
  }

  Future<void> refresh() {
    return _state.refresh();
  }

  void scrollToTop() {
    _state.scrollToTop();
  }
}
