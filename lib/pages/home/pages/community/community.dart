import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/posts_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/community_card.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_cover.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_nav_bar.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_no_posts.dart';
import 'package:Openbook/pages/home/pages/timeline/widgets/timeline-posts.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/post/post.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class OBCommunityPage extends StatefulWidget {
  final Community community;

  OBCommunityPage(this.community);

  @override
  OBCommunityPageState createState() {
    return OBCommunityPageState();
  }
}

class OBCommunityPageState extends State<OBCommunityPage>
    with TickerProviderStateMixin {
  Community _community;
  bool _needsBootstrap;
  bool _morePostsToLoad;
  List<Post> _posts;
  UserService _userService;
  ToastService _toastService;
  ScrollController _scrollController;
  TabController _tabController;
  bool _refreshPostsInProgress;
  PagewiseLoadController _pageWiseController;

  // This is also the max of items retrieved from the backend
  static const pageWiseSize = 10;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageWiseController = PagewiseLoadController(
        pageFuture: _loadMorePosts, pageSize: pageWiseSize);
    _needsBootstrap = true;
    _morePostsToLoad = false;
    _community = widget.community;
    _posts = [];
    _refreshPostsInProgress = false;
    _tabController = TabController(length: 2, vsync: this);
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

    return CupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBCommunityNavBar(_community),
        child: OBPrimaryColorContainer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    // These are the slivers that show up in the "outer" scroll view.
                    return <Widget>[
                      SliverOverlapAbsorber(
                        // This widget takes the overlapping behavior of the SliverAppBar,
                        // and redirects it to the SliverOverlapInjector below. If it is
                        // missing, then it is possible for the nested "inner" scroll view
                        // below to end up under the SliverAppBar even when the inner
                        // scroll view thinks it has not been scrolled.
                        // This is not necessary if the "headerSliverBuilder" only builds
                        // widgets that do not overlap the next sliver.
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        child: SliverList(
                          delegate: new SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              switch (index) {
                                case 0:
                                  return OBCommunityCover(_community);
                                  break;
                                case 1:
                                  return OBCommunityCard(
                                    _community,
                                  );
                                  break;
                              }
                            },
                            childCount: 2,
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: new CommunityTabBarDelegate(
                            controller: _tabController),
                      ),
                    ];
                  },
                  body: TabBarView(
                    // These are the contents of the tab views, below the tabs.
                    controller: _tabController,
                    children: [
                      SafeArea(
                        top: false,
                        bottom: false,
                        child: Builder(
                          // This Builder is needed to provide a BuildContext that is "inside"
                          // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
                          // find the NestedScrollView.
                          builder: (BuildContext context) {
                            return RefreshIndicator(
                              child: CustomScrollView(
                                // The "controller" and "primary" members should be left
                                // unset, so that the NestedScrollView can control this
                                // inner scroll view.
                                // If the "controller" property is set, then this scroll
                                // view will not be associated with the NestedScrollView.
                                // The PageStorageKey should be unique to this ScrollView;
                                // it allows the list to remember its scroll position when
                                // the tab view is not on the screen.
                                key: PageStorageKey<String>('communityPosts'),
                                slivers: <Widget>[
                                  SliverOverlapInjector(
                                    // This is the flip side of the SliverOverlapAbsorber above.
                                    handle: NestedScrollView
                                        .sliverOverlapAbsorberHandleFor(
                                            context),
                                  ),
                                  PagewiseSliverList(
                                    pageLoadController:
                                        this._pageWiseController,
                                    itemBuilder: (BuildContext context,
                                        dynamic post, int index) {
                                      return OBPost(post,
                                          onPostDeleted: _onPostDeleted,
                                          key: Key(post.id.toString()));
                                    },
                                  )
                                ],
                              ),
                              onRefresh: _refresh,
                              displacement: 20,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _bootstrap() async {
    await _refresh();
  }

  Future<void> _refresh() async {
    try {
      await Future.wait([_refreshCommunity(), _refreshPosts()]);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    } finally {}
  }

  Future<void> _refreshCommunity() async {
    var community = await _userService.getCommunityWithName(_community.name);
    _setCommunity(community);
  }

  Future<void> _refreshPosts() async {
    _setPosts([]);
    this._pageWiseController.reset();

/*    _setRefreshPostsInProgress(true);
    PostsList postsList = await _userService.getPostsForCommunity(_community);
    _posts = postsList.posts;
    _setPosts(_posts);
    _setRefreshPostsInProgress(false);*/
  }

  Future<List<Post>> _loadMorePosts(int pageIndex) async {
    List<Post> morePosts = [];
    int lastPostId;
    if (_posts.isNotEmpty) {
      Post lastPost = _posts.last;
      lastPostId = lastPost.id;
    }

    try {
      morePosts = (await _userService.getPostsForCommunity(_community,
              maxId: lastPostId))
          .posts;
      _setPosts(morePosts);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (error) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    }

    return morePosts;
  }

  void _onPostDeleted(Post deletedPost) {
    setState(() {
      _posts.remove(deletedPost);
    });
  }

  void _setCommunity(Community community) {
    setState(() {
      _community = community;
    });
  }

  void _setPosts(List<Post> posts) {
    setState(() {
      _posts = posts;
    });
  }

  void _setMorePostsToLoad(bool morePostsToLoad) {
    setState(() {
      _morePostsToLoad = morePostsToLoad;
    });
  }

  void _setRefreshPostsInProgress(bool refreshPostsInProgress) {
    setState(() {
      _refreshPostsInProgress = refreshPostsInProgress;
    });
  }
}

class CommunityTabBarDelegate extends SliverPersistentHeaderDelegate {
  CommunityTabBarDelegate({this.controller});

  final TabController controller;

  @override
  double get minExtent => kToolbarHeight;

  @override
  double get maxExtent => kToolbarHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Theme.of(context).cardColor,
      height: kToolbarHeight,
      child: new TabBar(
        controller: controller,
        key: new PageStorageKey<Type>(TabBar),
        indicatorColor: Theme.of(context).primaryColor,
        tabs: <Widget>[
          Tab(text: 'Posts'),
          Tab(text: 'About'),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant CommunityTabBarDelegate oldDelegate) {
    return oldDelegate.controller != controller;
  }
}

typedef void OnWantsToEditUserCommunity(User user);
