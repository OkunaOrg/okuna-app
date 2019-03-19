import 'dart:async';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/posts_list.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/alerts/button_alert.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/post/post.dart';
import 'package:Openbook/widgets/theming/primary_accent_text.dart';
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

  List<Post> _posts;
  bool _needsBootstrap;

  StreamSubscription<PostsList> _getTrendingPostsSubscription;
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
  }

  @override
  void dispose() {
    super.dispose();
    if (_getTrendingPostsSubscription != null)
      _getTrendingPostsSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }
    return _posts.isEmpty && _getTrendingPostsSubscription == null
        ? _buildNoTrendingPostsAlert()
        : RefreshIndicator(
            key: _refreshIndicatorKey,
            child: ListView.builder(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemCount: _posts.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: OBPrimaryAccentText('Trending posts',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24)),
                    );
                  }

                  return OBPost(_posts[index - 1]);
                }),
            onRefresh: refresh,
          );
  }

  Widget _buildNoTrendingPostsAlert() {
    return Column(
      children: <Widget>[
        OBButtonAlert(
          text:
              'There are no trending posts. Try refreshing in a couple seconds.',
          onPressed: refresh,
          buttonText: 'Refresh',
          buttonIcon: OBIcons.refresh,
          assetImage: 'assets/images/stickers/perplexed-owl.png',
        )
      ],
    );
  }

  void _bootstrap() {
    refresh();
  }

  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  Future<void> refresh() async {
    if (_getTrendingPostsSubscription != null)
      _getTrendingPostsSubscription.cancel();

    Future<PostsList> refreshFuture = _userService.getTrendingPosts();

    _getTrendingPostsSubscription =
        refreshFuture.asStream().listen((PostsList postsList) {
      _setPosts(postsList.posts);
      _getTrendingPostsSubscription = null;
    }, onError: _onError);

    return refreshFuture;
  }

  void _onError(error) async {
    _getTrendingPostsSubscription = null;

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

  void _setPosts(List<Post> posts) {
    setState(() {
      _posts = posts;
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
