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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
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
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        if (index == 0) {
                                          Widget postsItem;

                                          if (_refreshPostsInProgress &&
                                              _posts.isEmpty) {
                                            postsItem = SizedBox(
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                  child: OBProgressIndicator(),
                                                ),
                                              ),
                                            );
                                          } else if (_posts.length == 0) {
                                            postsItem = OBCommunityNoPosts(
                                              _community,
                                              onWantsToRefreshCommunity:
                                                  _refresh,
                                            );
                                          } else {
                                            postsItem = const SizedBox(
                                              height: 20,
                                            );
                                          }

                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[postsItem],
                                          );
                                        }

                                        int postIndex = index - 1;

                                        var post = _posts[postIndex];

                                        return OBPost(post,
                                            onPostDeleted: _onPostDeleted,
                                            key: Key(post.id.toString()));
                                      },
                                      // The childCount of the SliverChildBuilderDelegate
                                      // specifies how many children this inner list
                                      // has. In this example, each tab has a list of
                                      // exactly 30 items, but this is arbitrary.
                                      childCount: _posts.length + 1,
                                    ),
                                  ),
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

  Widget _buildContent() {
    return RefreshIndicator(
        child: ListView(
          children: <Widget>[
            OBCommunityCover(_community),
            OBCommunityCard(
              _community,
            ),
            _buildCommunityPosts()
          ],
        ),
        onRefresh: _refresh);
  }

  Widget _buildCommunityPosts() {
    return LoadMore(
        whenEmptyLoad: false,
        isFinish: !_morePostsToLoad,
        delegate: OBHomePostsLoadMoreDelegate(),
        child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            itemCount: _posts.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                Widget postsItem;

                if (_refreshPostsInProgress && _posts.isEmpty) {
                  postsItem = SizedBox(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: OBProgressIndicator(),
                      ),
                    ),
                  );
                } else if (_posts.length == 0) {
                  postsItem = OBCommunityNoPosts(
                    _community,
                    onWantsToRefreshCommunity: _refresh,
                  );
                } else {
                  postsItem = const SizedBox(
                    height: 20,
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[postsItem],
                );
              }

              int postIndex = index - 1;

              var post = _posts[postIndex];

              return OBPost(post,
                  onPostDeleted: _onPostDeleted, key: Key(post.id.toString()));
            }),
        onLoadMore: _loadMorePosts);
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
    _setRefreshPostsInProgress(true);
    PostsList postsList = await _userService.getPostsForCommunity(_community);
    _posts = postsList.posts;
    _setPosts(_posts);
    _setRefreshPostsInProgress(false);
  }

  Future<bool> _loadMorePosts() async {
    var lastPost = _posts.last;
    var lastPostId = lastPost.id;
    try {
      var morePosts = (await _userService.getPostsForCommunity(_community,
              maxId: lastPostId))
          .posts;

      if (morePosts.length == 0) {
        _setMorePostsToLoad(false);
      } else {
        setState(() {
          _posts.addAll(morePosts);
        });
      }
      return true;
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (error) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    }

    return false;
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
