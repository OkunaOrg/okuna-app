import 'dart:async';

import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/post/post.dart';
import 'package:flutter/material.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";

class OBHomePosts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBHomePostsState();
  }
}

class OBHomePostsState extends State<OBHomePosts> {
  List<Post> _posts;
  bool _needsBootstrap;
  UserService _userService;
  StreamSubscription _loggedInUserChangeSubscription;
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _posts = [];
    _needsBootstrap = true;
    _refreshController = RefreshController();
  }

  @override
  void dispose() {
    super.dispose();
    _loggedInUserChangeSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _userService = provider.userService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        controller: _refreshController,
        child: new ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            var post = _posts[index];
            return OBPost(post);
          },
        ));
  }

  void _bootstrap() async {
    _loggedInUserChangeSubscription =
        _userService.loggedInUserChange.listen(_onLoggedInUserChange);
  }

  void _onRefresh(bool upperRefresh) {
    if (upperRefresh) {
      _refreshPosts();
    } else {
      _getMorePosts();
    }
  }

  void _onLoggedInUserChange(User newUser) async {
    if (newUser == null) return;
    _refreshPosts();
  }

  void _refreshPosts() async {
    _posts = (await _userService.getAllPosts()).posts;
    _setPosts(_posts);
    _refreshController.sendBack(true, RefreshStatus.completed);
  }

  void _getMorePosts() async {
    var lastPost = _posts.last;
    var lastPostId = lastPost.id;
    var morePosts = (await _userService.getAllPosts(maxId: lastPostId)).posts;
    _refreshController.sendBack(false, RefreshStatus.completed);

    if(morePosts.length > 0){
      setState(() {
        _posts.addAll(morePosts);
      });
    }
  }

  void _setPosts(List<Post> posts) {
    setState(() {
      this._posts = posts;
    });
  }
}
