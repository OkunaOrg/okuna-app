import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/communities_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/modals/create_post/pages/share_post/share_post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/checkbox.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/community_selectable_tile.dart';
import 'package:Openbook/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSharePostWithCommunityPage extends StatefulWidget {
  final SharePostData sharePostData;

  const OBSharePostWithCommunityPage({Key key, @required this.sharePostData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBSharePostWithCommunityPageState();
  }
}

class OBSharePostWithCommunityPageState
    extends State<OBSharePostWithCommunityPage> {
  UserService _userService;
  ToastService _toastService;
  bool _isCreatePostInProgress;

  bool _needsBootstrap;

  List<Community> _communities;
  List<Community> _communitiesSearchResults;
  Community _chosenCommunity;
  String _communitieSearchQuery;

  @override
  void initState() {
    super.initState();
    _isCreatePostInProgress = false;
    _communities = [];
    _communitiesSearchResults = _communities.toList();
    _communitieSearchQuery = '';
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _toastService = openbookProvider.toastService;
    _userService = openbookProvider.userService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: _buildAvailableAudience(),
        ));
  }

  Widget _buildAvailableAudience() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OBSearchBar(
          onSearch: _onSearch,
          hintText: 'Search communities...',
        ),
        Expanded(
            child: _communitiesSearchResults.length == 0 &&
                    _communitieSearchQuery.isNotEmpty
                ? _buildNoResults()
                : _buildSearchResults())
      ],
    );
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: 'Audience',
      trailing: OBButton(
        size: OBButtonSize.small,
        type: OBButtonType.primary,
        isLoading: _isCreatePostInProgress,
        isDisabled: _chosenCommunity == null,
        onPressed: createPost,
        child: Text('Share'),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      physics: const ClampingScrollPhysics(),
      itemCount: _communitiesSearchResults.length,
      itemBuilder: _buildCommunityItem,
      separatorBuilder: _buildCommunitySeparator,
    );
  }

  Widget _buildCommunityItem(BuildContext context, int index) {
    Community community = _communitiesSearchResults[index];

    return OBCommunitySelectableTile(
      community: community,
      onCommunityPressed: _onCommunityPressed,
      isSelected: community == _chosenCommunity,
    );
  }

  Widget _buildCommunitySeparator(BuildContext context, int index) {
    return const SizedBox(
      height: 10,
    );
  }

  Widget _buildNoResults() {
    return SizedBox(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const OBIcon(OBIcons.sad, customSize: 30.0),
              const SizedBox(
                height: 20.0,
              ),
              OBText(
                'No community found matching \'$_communitieSearchQuery\'.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createPost() async {
    _setCreatePostInProgress(true);

    try {
      Post createdPost = await _userService.createPostForCommunity(
          _chosenCommunity,
          text: widget.sharePostData.text,
          image: widget.sharePostData.image,
          video: widget.sharePostData.video);
      // Remove modal
      Navigator.pop(context, createdPost);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
      _setCreatePostInProgress(false);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    } finally {
      _setCreatePostInProgress(false);
    }
  }

  void _setCreatePostInProgress(bool createPostInProgress) {
    setState(() {
      _isCreatePostInProgress = createPostInProgress;
    });
  }

  void _onCommunityPressed(Community pressedCommunity) {
    if (pressedCommunity == _chosenCommunity) {
      _clearChosenCommunity();
    } else {
      _setChosenCommunity(pressedCommunity);
    }
  }

  void _onSearch(String searchString) {
    if (searchString.length == 0) {
      _resetCommunitieSearchResults();
      return;
    }

    String standarisedSearchStr = searchString.toLowerCase();

    List<Community> results = _communities.where((Community community) {
      return community.name.toLowerCase().contains(standarisedSearchStr);
    }).toList();

    _setCommunitiesSearchResults(results);
    _setCommunitiesSearchQuery(searchString);
  }

  void _bootstrap() async {
    CommunitiesList communityList = await _userService.getJoinedCommunities();
    this._setCommunities(communityList.communities);
  }

  void _resetCommunitieSearchResults() {
    setState(() {
      _communitiesSearchResults = _communities.toList();
    });
  }

  void _setCommunities(List<Community> communities) {
    setState(() {
      _communities = communities;
    });
  }

  void _setCommunitiesSearchResults(List<Community> communitiesearchResults) {
    setState(() {
      _communitiesSearchResults = communitiesearchResults;
    });
  }

  void _setCommunitiesSearchQuery(String searchQuery) {
    setState(() {
      _communitieSearchQuery = searchQuery;
    });
  }

  void _clearChosenCommunity() {
    _setChosenCommunity(null);
  }

  void _setChosenCommunity(Community chosenCommunity) {
    setState(() {
      _chosenCommunity = chosenCommunity;
    });
  }
}
