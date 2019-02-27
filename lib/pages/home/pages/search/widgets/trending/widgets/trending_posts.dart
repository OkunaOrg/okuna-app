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

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller.attach(this);
    _needsBootstrap = true;
    _posts = [];
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
    return Column(
      children: [
        ListTile(
            title: OBPrimaryAccentText('Trending posts',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))),
        _posts.isEmpty && _getTrendingPostsSubscription == null
            ? _buildNoTrendingPostsAlert()
            : Column(
                children: _posts.map((Post post) {
                return OBPost(post);
              }).toList())
      ],
    );
  }

  Widget _buildNoTrendingPostsAlert() {
    return OBButtonAlert(
      text: 'There are no trending posts. Try refreshing in a couple seconds.',
      onPressed: refresh,
      buttonText: 'Refresh',
      buttonIcon: OBIcons.refresh,
      assetImage: 'assets/images/stickers/perplexed-owl.png',
    );
  }

  void _bootstrap() {
    refresh();
  }

  Future<void> refresh() async {
    if (_getTrendingPostsSubscription != null)
      _getTrendingPostsSubscription.cancel();

    _getTrendingPostsSubscription = _userService
        .getTrendingPosts()
        .asStream()
        .listen((PostsList postsList) {
      _setPosts(postsList.posts);
      _getTrendingPostsSubscription = null;
    }, onError: (error) {
      if (error is HttpieConnectionRefusedError) {
        _toastService.error(
            message: 'No internet connection', context: context);
      } else {
        _toastService.error(message: 'Unknown error.', context: context);
        throw error;
      }
      _getTrendingPostsSubscription = null;
    });
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
}
