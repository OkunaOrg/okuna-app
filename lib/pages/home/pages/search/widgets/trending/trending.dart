import 'package:Openbook/pages/home/pages/search/widgets/trending/widgets/trending_posts.dart';
import 'package:flutter/material.dart';

class OBTrending extends StatefulWidget {
  final OBTrendingController controller;

  const OBTrending({
    this.controller,
  });

  @override
  State<StatefulWidget> createState() {
    return OBTrendingState();
  }
}

class OBTrendingState extends State<OBTrending> {
  ScrollController _scrollController;
  OBTrendingPostsController _trendingPostsController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller.attach(this);
    _trendingPostsController = OBTrendingPostsController();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            padding: EdgeInsets.all(0),
            itemCount: 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return OBTrendingPosts(
                  controller: _trendingPostsController,
                );
              }
            }),
        onRefresh: _refresh);
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

  Future<void> _refresh() {
    return _trendingPostsController.refresh();
  }
}

class OBTrendingController {
  OBTrendingState _state;

  void attach(OBTrendingState state) {
    _state = state;
  }

  void scrollToTop() {
    _state.scrollToTop();
  }
}
