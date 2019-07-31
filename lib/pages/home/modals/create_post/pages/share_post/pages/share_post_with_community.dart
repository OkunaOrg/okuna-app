import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/communities_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/modals/create_post/pages/share_post/share_post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/http_list.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/tiles/community_selectable_tile.dart';
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
  LocalizationService _localizationService;
  bool _isCreatePostInProgress;

  Community _chosenCommunity;

  @override
  void initState() {
    super.initState();
    _isCreatePostInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _toastService = openbookProvider.toastService;
    _userService = openbookProvider.userService;
    _localizationService = openbookProvider.localizationService;

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
        Expanded(
            child: OBHttpList<Community>(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          separatorBuilder: _buildCommunitySeparator,
          listItemBuilder: _buildCommunityItem,
          searchResultListItemBuilder: _buildCommunityItem,
          listRefresher: _refreshCommunities,
          listOnScrollLoader: _loadMoreCommunities,
          listSearcher: _searchCommunities,
          resourceSingularName: _localizationService.trans('community__community'),
          resourcePluralName: _localizationService.trans('community__communities'),
        ))
      ],
    );
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: _localizationService.trans('post__share_to_community'),
      trailing: OBButton(
        size: OBButtonSize.small,
        type: OBButtonType.primary,
        isLoading: _isCreatePostInProgress,
        isDisabled: _chosenCommunity == null,
        onPressed: createPost,
        child: Text(_localizationService.trans('post__share_community')),
      ),
    );
  }

  Widget _buildCommunityItem(BuildContext context, Community community) {
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
    } catch (error) {
      _onError(error);
    } finally {
      _setCreatePostInProgress(false);
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
      _toastService.error(message: _localizationService.trans('error__unknown_error'), context: context);
      throw error;
    }
  }

  Future<List<Community>> _refreshCommunities() async {
    CommunitiesList communities = await _userService.getJoinedCommunities();
    return communities.communities;
  }

  Future<List<Community>> _loadMoreCommunities(
      List<Community> communitiesList) async {
    int offset = communitiesList.length;

    List<Community> moreCommunities = (await _userService.getJoinedCommunities(
      offset: offset,
    ))
        .communities;
    return moreCommunities;
  }

  Future<List<Community>> _searchCommunities(String query) async {
    CommunitiesList results =
        await _userService.searchJoinedCommunities(query: query);

    return results.communities;
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

  void _clearChosenCommunity() {
    _setChosenCommunity(null);
  }

  void _setChosenCommunity(Community chosenCommunity) {
    setState(() {
      _chosenCommunity = chosenCommunity;
    });
  }
}
