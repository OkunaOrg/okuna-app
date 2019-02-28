import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reactions_emoji_count.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/modals/create_post/pages/share_post/pages/share_post_with_circles.dart';
import 'package:Openbook/pages/home/modals/create_post/pages/share_post/pages/share_post_with_community.dart';
import 'package:Openbook/pages/home/modals/create_post/pages/share_post/share_post.dart';
import 'package:Openbook/pages/home/modals/post_reactions/post_reactions.dart';
import 'package:Openbook/pages/home/pages/community/community.dart';
import 'package:Openbook/pages/home/pages/community/pages/manage_community/manage_community.dart';
import 'package:Openbook/pages/home/pages/community/pages/manage_community/pages/community_administrators/community_administrators.dart';
import 'package:Openbook/pages/home/pages/community/pages/manage_community/pages/community_administrators/modals/add_community_administrator/pages/confirm_add_community_administrator.dart';
import 'package:Openbook/pages/home/pages/community/pages/manage_community/pages/community_banned_users/community_banned_users.dart';
import 'package:Openbook/pages/home/pages/community/pages/manage_community/pages/community_banned_users/modals/ban_community_user/pages/confirm_ban_community_user.dart';
import 'package:Openbook/pages/home/pages/community/pages/manage_community/pages/community_moderators/community_moderators.dart';
import 'package:Openbook/pages/home/pages/community/pages/manage_community/pages/community_moderators/modals/add_community_moderator/pages/confirm_add_community_moderator.dart';
import 'package:Openbook/pages/home/pages/community/pages/manage_community/pages/delete_community.dart';
import 'package:Openbook/pages/home/pages/community/pages/manage_community/pages/leave_community.dart';
import 'package:Openbook/pages/home/pages/menu/pages/connections_circle/connections_circle.dart';
import 'package:Openbook/pages/home/pages/menu/pages/connections_circles/connections_circles.dart';
import 'package:Openbook/pages/home/pages/menu/pages/follows_list/follows_list.dart';
import 'package:Openbook/pages/home/pages/menu/pages/follows_lists/follows_lists.dart';
import 'package:Openbook/pages/home/pages/menu/widgets/settings/settings.dart';
import 'package:Openbook/pages/home/pages/post/post.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/routes/slide_right_route.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationService {
  void navigateToUserProfile(
      {@required User user, @required BuildContext context}) async {
    await Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSlideProfileView'),
            widget: OBProfilePage(
              user,
            )));
  }

  Future navigateToCommunity(
      {@required Community community, @required BuildContext context}) async {
    await Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSlideCommunityPage'),
            widget: OBCommunityPage(
              community,
            )));
  }

  Future<bool> navigateToConfirmAddCommunityAdministrator(
      {@required Community community,
      @required User user,
      @required BuildContext context}) async {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSlideConfirmAddCommunityAdministratorPage'),
            widget: OBConfirmAddCommunityAdministrator(
              community: community,
              user: user,
            )));
  }

  Future<bool> navigateToConfirmAddCommunityModerator(
      {@required Community community,
      @required User user,
      @required BuildContext context}) async {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSlideConfirmAddCommunityModeratorPage'),
            widget: OBConfirmAddCommunityModerator(
              community: community,
              user: user,
            )));
  }

  Future<bool> navigateToConfirmBanCommunityUser(
      {@required Community community,
      @required User user,
      @required BuildContext context}) async {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSlideConfirmBanCommunityMemberPage'),
            widget: OBConfirmBanCommunityUser(
              community: community,
              user: user,
            )));
  }

  Future<void> navigateToManageCommunity(
      {@required Community community, @required BuildContext context}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obEditCommunityPage'),
            widget: OBManageCommunityPage(
              community: community,
            )));
  }

  Future<void> navigateToLeaveCommunity(
      {@required Community community, @required BuildContext context}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obLeaveCommunityPage'),
            widget: OBLeaveCommunityPage(
              community: community,
            )));
  }

  Future<void> navigateToDeleteCommunity(
      {@required Community community, @required BuildContext context}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obDeleteCommunityPage'),
            widget: OBDeleteCommunityPage(
              community: community,
            )));
  }

  Future<void> navigateToCommunityAdministrators(
      {@required Community community, @required BuildContext context}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obCommunityAdministratorsPage'),
            widget: OBCommunityAdministratorsPage(
              community: community,
            )));
  }

  Future<void> navigateToCommunityModerators(
      {@required Community community, @required BuildContext context}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obCommunityModeratorsPage'),
            widget: OBCommunityModeratorsPage(
              community: community,
            )));
  }

  Future<void> navigateToCommunityBannedUsers(
      {@required Community community, @required BuildContext context}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obCommunityBannedUsersPage'),
            widget: OBCommunityBannedUsersPage(
              community: community,
            )));
  }

  Future navigateToCommentPost(
      {@required Post post, @required BuildContext context}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSlidePostComments'),
            widget: OBPostPage(post, autofocusCommentInput: true)));
  }

  Future navigateToPostComments(
      {@required Post post, @required BuildContext context}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSlideViewComments'),
            widget: OBPostPage(post, autofocusCommentInput: false)));
  }

  Future navigateToSettingsPage({@required BuildContext context}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obMenuViewSettings'), widget: OBSettingsPage()));
  }

  Future<Post> navigateToSharePost(
      {@required BuildContext context, @required SharePostData sharePostData}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSharePostPage'),
            widget: OBSharePostPage(
              sharePostData: sharePostData,
            )));
  }

  Future<Post> navigateToSharePostWithCircles(
      {@required BuildContext context, @required SharePostData sharePostData}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSharePostWithCirclesPage'),
            widget: OBSharePostWithCirclesPage(
              sharePostData: sharePostData,
            )));
  }

  Future<Post> navigateToSharePostWithCommunity(
      {@required BuildContext context, @required SharePostData sharePostData}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSharePostWithCommunityPage'),
            widget: OBSharePostWithCommunityPage(
              sharePostData: sharePostData,
            )));
  }

  Future navigateToFollowsLists({@required BuildContext context}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSeeFollowsLists'), widget: OBFollowsListsPage()));
  }

  Future navigateToConnectionsCircles({@required BuildContext context}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSeeConnectionsCircles'),
            widget: OBConnectionsCirclesPage()));
  }

  Future navigateToConnectionsCircle(
      {@required Circle connectionsCircle, @required BuildContext context}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSeeConnectionsCircle'),
            widget: OBConnectionsCirclePage(connectionsCircle)));
  }

  Future navigateToFollowsList({
    @required FollowsList followsList,
    @required BuildContext context,
  }) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSeeFollowsList'),
            widget: OBFollowsListPage(followsList)));
  }

  Future<void> navigateToPostReactions(
      {@required Post post,
      @required List<PostReactionsEmojiCount> reactionsEmojiCounts,
      @required BuildContext context,
      Emoji reactionEmoji}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obPostReactionsModal'),
            widget: OBPostReactionsModal(
              post: post,
              reactionsEmojiCounts: reactionsEmojiCounts,
              reactionEmoji: reactionEmoji,
            )));
  }

  Future<void> navigateToBlankPageWithWidget(
      {@required BuildContext context,
      @required String navBarTitle,
      @required Key key,
      @required Widget widget}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: key,
            widget: CupertinoPageScaffold(
              navigationBar: OBThemedNavigationBar(
                title: navBarTitle,
              ),
              child: OBPrimaryColorContainer(
                child: widget,
              ),
            )));
  }
}
