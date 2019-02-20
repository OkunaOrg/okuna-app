import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/community_card.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_cover.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_moderators.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_nav_bar.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_no_posts.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_rules.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/alerts/alert.dart';
import 'package:Openbook/widgets/post/post.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<Post> _posts;
  UserService _userService;
  ToastService _toastService;
  ScrollController _scrollController;
  TabController _tabController;
  PagewiseLoadController _pageWiseController;

  // This is also the max of items retrieved from the backend
  static const pageWiseSize = 10;

  bool _refreshInProgress;

  PageStorageKey _pageStorageKey;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageWiseController = PagewiseLoadController(
        pageFuture: _loadMorePosts, pageSize: pageWiseSize);
    _needsBootstrap = true;
    _refreshInProgress = false;
    _community = widget.community;
    _posts = [];
    _tabController = TabController(length: 2, vsync: this);
    _pageStorageKey = PageStorageKey<Type>(TabBar);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _bootstrap();
      _needsBootstrap = false;
    }

    bool communityIsPrivate = widget.community.isPrivate();
    bool userIsMember = widget.community.isMember;
    bool userCanSeePosts = !communityIsPrivate || userIsMember;

    return CupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBCommunityNavBar(
          _community,
          refreshInProgress: _refreshInProgress,
          onWantsRefresh: _refresh,
        ),
        child: OBPrimaryColorContainer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: userCanSeePosts
                    ? _buildUserCanSeePostsPage()
                    : _buildUserCannotSeePostsPage(),
              )
            ],
          ),
        ));
  }

  Widget _buildUserCannotSeePostsPage() {
    bool communityHasInvitesEnabled = widget.community.invitesEnabled;
    return ListView(
      padding: EdgeInsets.all(0),
      physics: const ClampingScrollPhysics(),
      children: <Widget>[
        OBCommunityCover(_community),
        OBCommunityCard(
          _community,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: OBAlert(
            child: Column(
              children: <Widget>[
                OBText('This community is private.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 10,
                ),
                OBText(
                  communityHasInvitesEnabled
                      ? 'You must be invited by a member.'
                      : 'You must be invited by a moderator.',
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
        OBCommunityModerators(widget.community)
      ],
    );
  }

  Widget _buildUserCanSeePostsPage() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
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
            pinned: false,
            delegate: new CommunityTabBarDelegate(
                community: widget.community,
                pageStorageKey: _pageStorageKey,
                controller: _tabController),
          ),
        ];
      },
      body: TabBarView(
        key: _pageStorageKey,
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Builder(
              // This Builder is needed to provide a BuildContext that is "inside"
              // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
              // find the NestedScrollView.
              builder: (BuildContext context) {
                return CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  // The "controller" and "primary" members should be left
                  // unset, so that the NestedScrollView can control this
                  // inner scroll view.
                  // If the "controller" property is set, then this scroll
                  // view will not be associated with the NestedScrollView.
                  // The PageStorageKey should be unique to this ScrollView;
                  // it allows the list to remember its scroll position when
                  // the tab view is not on the screen.
                  key: PageStorageKey<int>(0),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    PagewiseSliverList(
                      noItemsFoundBuilder: (context) {
                        return OBCommunityNoPosts(
                          _community,
                          onWantsToRefreshCommunity: _refreshPosts,
                        );
                      },
                      loadingBuilder: (context) {
                        return Padding(
                          padding: EdgeInsets.all(20),
                          child: OBProgressIndicator(),
                        );
                      },
                      pageLoadController: this._pageWiseController,
                      itemBuilder:
                          (BuildContext context, dynamic post, int index) {
                        return OBPost(post,
                            onPostDeleted: _onPostDeleted,
                            key: Key(post.id.toString()));
                      },
                    )
                  ],
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            bottom: false,
            child: Builder(
              // This Builder is needed to provide a BuildContext that is "inside"
              // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
              // find the NestedScrollView.
              builder: (BuildContext context) {
                return CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  key: PageStorageKey<int>(1),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        switch (index) {
                          case 0:
                            return OBCommunityRules(_community);
                            break;
                          case 1:
                            return OBCommunityModerators(
                              _community,
                            );
                            break;
                        }
                      }, childCount: 2),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
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
    _setRefreshInProgress(true);
    try {
      await Future.wait([_refreshCommunity(), _refreshPosts()]);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    } finally {
      _setRefreshInProgress(false);
    }
  }

  Future<void> _refreshCommunity() async {
    var community = await _userService.getCommunityWithName(_community.name);
    _setCommunity(community);
  }

  Future<void> _refreshPosts() async {
    _setPosts([]);
    this._pageWiseController.reset();
  }

  Future<List<Post>> _loadMorePosts(int pageIndex) async {
    List<Post> morePosts = [];
    int lastPostId;

    // TODO There is a bug where when switching tabs, this function gets executed
    // again, although the state is preserved. Probably something to do with the
    // PageWise library.

    if (_posts.isNotEmpty && pageIndex != 0) {
      Post lastPost = _posts.last;
      lastPostId = lastPost.id;
    }

    try {
      morePosts = (await _userService.getPostsForCommunity(_community,
              maxId: lastPostId))
          .posts;
      _addPosts(morePosts);
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

  void _setRefreshInProgress(bool refreshInProgress) {
    setState(() {
      _refreshInProgress = refreshInProgress;
    });
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
}

class CommunityTabBarDelegate extends SliverPersistentHeaderDelegate {
  CommunityTabBarDelegate({
    this.controller,
    this.pageStorageKey,
    this.community,
  });

  final TabController controller;
  final Community community;
  final PageStorageKey pageStorageKey;

  @override
  double get minExtent => kToolbarHeight;

  @override
  double get maxExtent => kToolbarHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          Color themePrimaryTextColor =
              themeValueParserService.parseColor(theme.primaryTextColor);

          return new SizedBox(
            height: kToolbarHeight,
            child: TabBar(
              controller: controller,
              key: pageStorageKey,
              indicatorColor: themePrimaryTextColor,
              labelColor: themePrimaryTextColor,
              tabs: <Widget>[
                const Tab(text: 'Posts'),
                const Tab(text: 'About'),
              ],
            ),
          );
        });
  }

  @override
  bool shouldRebuild(covariant CommunityTabBarDelegate oldDelegate) {
    return oldDelegate.controller != controller;
  }
}

typedef void OnWantsToEditUserCommunity(User user);
