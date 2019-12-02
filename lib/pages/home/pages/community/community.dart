import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/posts_list.dart';
import 'package:Okuna/models/theme.dart';
import 'package:Okuna/models/user.dart';
import 'package:Okuna/pages/home/pages/community/pages/community_staff/widgets/community_administrators.dart';
import 'package:Okuna/pages/home/pages/community/pages/community_staff/widgets/community_moderators.dart';
import 'package:Okuna/pages/home/pages/community/widgets/community_card/community_card.dart';
import 'package:Okuna/pages/home/pages/community/widgets/community_cover.dart';
import 'package:Okuna/pages/home/pages/community/widgets/community_nav_bar.dart';
import 'package:Okuna/pages/home/pages/community/widgets/community_posts_stream_status_indicator.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/alerts/alert.dart';
import 'package:Okuna/widgets/buttons/community_new_post_button.dart';
import 'package:Okuna/widgets/new_post_data_uploader.dart';
import 'package:Okuna/widgets/posts_stream/posts_stream.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  OBPostsStreamController _obPostsStreamController;
  UserService _userService;
  LocalizationService _localizationService;

  bool _needsBootstrap;

  CancelableOperation _refreshCommunityOperation;

  List<OBNewPostData> _newPostsData;

  @override
  void initState() {
    super.initState();
    _obPostsStreamController = OBPostsStreamController();
    _needsBootstrap = true;
    _community = widget.community;
    _newPostsData = [];
  }

  void _onWantsToUploadNewPostData(OBNewPostData newPostData) {
    _insertNewPostData(newPostData);
  }

  @override
  void dispose() {
    super.dispose();
    if (_refreshCommunityOperation != null) _refreshCommunityOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _localizationService = openbookProvider.localizationService;
      _needsBootstrap = false;

      // If the user doesn't have permission to view the community we need to
      // manually trigger a refresh here to make sure the model contains all
      // relevant community information (like admins and moderators).
      //
      // If the user can see the content, a refresh will be triggered
      // automatically by the OBPostsStream.
      if (!_userCanSeeCommunityContent(_community)) {
        _refreshCommunity();
      }
    }

    return CupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBCommunityNavBar(
          _community,
        ),
        child: OBPrimaryColorContainer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                    stream: _community.updateSubject,
                    initialData: _community,
                    builder: (BuildContext context,
                        AsyncSnapshot<Community> snapshot) {
                      Community latestCommunity = snapshot.data;

                      return _userCanSeeCommunityContent(latestCommunity)
                          ? _buildCommunityContent()
                          : _buildPrivateCommunityContent();
                    }),
              )
            ],
          ),
        ));
  }

  bool _userCanSeeCommunityContent(Community community) {
    bool communityIsPrivate = community.isPrivate();

    User loggedInUser = _userService.getLoggedInUser();
    bool userIsMember = community.isMember(loggedInUser);

    return !communityIsPrivate || userIsMember;
  }

  Widget _buildCommunityContent() {
    List<Widget> prependedItems = [
      OBCommunityCover(_community),
      OBCommunityCard(
        _community,
      )
    ];

    if (_newPostsData.isNotEmpty) {
      prependedItems.addAll(_newPostsData.map((OBNewPostData newPostData) {
        return _buildNewPostDataUploader(newPostData);
      }).toList());
    }

    List<Widget> stackItems = [
      OBPostsStream(
        onScrollLoader: _loadMoreCommunityPosts,
        refresher: _refreshCommunityPosts,
        controller: _obPostsStreamController,
        prependedItems: prependedItems,
        streamIdentifier: 'community_' + widget.community.name,
        secondaryRefresher: _refreshCommunity,
        statusIndicatorBuilder: _buildPostsStreamStatusIndicator,
      ),
    ];

    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    User loggedInUser = openbookProvider.userService.getLoggedInUser();
    bool isMemberOfCommunity = _community.isMember(loggedInUser);

    if (isMemberOfCommunity) {
      stackItems.add(Positioned(
          bottom: 20.0,
          right: 20.0,
          child: OBCommunityNewPostButton(
            community: _community,
            onWantsToUploadNewPostData: _onWantsToUploadNewPostData,
          )));
    }

    return Stack(
      children: stackItems,
    );
  }

  Widget _buildPostsStreamStatusIndicator(
      {BuildContext context,
      OBPostsStreamStatus streamStatus,
      List<Widget> streamPrependedItems,
      Function streamRefresher}) {
    return OBCommunityPostsStreamStatusIndicator(
        streamRefresher: streamRefresher,
        streamPrependedItems: streamPrependedItems,
        streamStatus: streamStatus);
  }

  Widget _buildNewPostDataUploader(OBNewPostData newPostData) {
    return OBNewPostDataUploader(
      data: newPostData,
      onPostPublished: _onNewPostDataUploaderPostPublished,
      onCancelled: _onNewPostDataUploaderCancelled,
    );
  }

  void _onNewPostDataUploaderCancelled(OBNewPostData newPostData) {
    _removeNewPostData(newPostData);
  }

  void _onNewPostDataUploaderPostPublished(
      Post publishedPost, OBNewPostData newPostData) {
    _removeNewPostData(newPostData);
    _community.incrementPostsCount();
    _obPostsStreamController.addPostToTop(publishedPost);
  }

  Widget _buildPrivateCommunityContent() {
    bool communityHasInvitesEnabled = _community.invitesEnabled;
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
                OBText(_localizationService.trans('community__is_private'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 10,
                ),
                OBText(
                  communityHasInvitesEnabled
                      ? _localizationService
                          .trans('community__invited_by_member')
                      : _localizationService
                          .trans('community__invited_by_moderator'),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
        OBCommunityAdministrators(_community),
        OBCommunityModerators(_community)
      ],
    );
  }

  Future<void> _refreshCommunity() async {
    if (_refreshCommunityOperation != null) _refreshCommunityOperation.cancel();
    _refreshCommunityOperation = CancelableOperation.fromFuture(
        _userService.getCommunityWithName(_community.name));
    debugPrint(_localizationService.trans('community__refreshing'));
    var community = await _refreshCommunityOperation.value;
    _setCommunity(community);
  }

  Future<List<Post>> _refreshCommunityPosts() async {
    debugPrint('Refreshing community posts');
    PostsList communityPosts =
        await _userService.getPostsForCommunity(widget.community);
    return communityPosts.posts;
  }

  Future<List<Post>> _loadMoreCommunityPosts(
      List<Post> communityPostsList) async {
    debugPrint('Loading more community posts');
    var lastCommunityPost = communityPostsList.last;
    var lastCommunityPostId = lastCommunityPost.id;
    var moreCommunityPosts = (await _userService.getPostsForCommunity(
      widget.community,
      maxId: lastCommunityPostId,
      count: 10,
    ))
        .posts;
    return moreCommunityPosts;
  }

  void _setCommunity(Community community) {
    setState(() {
      _community = community;
    });
  }

  void _insertNewPostData(OBNewPostData newPostData) {
    setState(() {
      _newPostsData.insert(0, newPostData);
    });
  }

  void _removeNewPostData(OBNewPostData newPostData) {
    setState(() {
      _newPostsData.remove(newPostData);
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
    var localizationService = openbookProvider.localizationService;
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
                Tab(text: localizationService.trans('community__posts')),
                Tab(text: localizationService.trans('community__about')),
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
