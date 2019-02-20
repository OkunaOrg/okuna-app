import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reactions_emoji_count.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/modals/create_post/pages/share_post/share_post.dart';
import 'package:Openbook/pages/home/modals/post_reactions/post_reactions.dart';
import 'package:Openbook/pages/home/pages/community/community.dart';
import 'package:Openbook/pages/home/pages/community/pages/manage_community.dart';
import 'package:Openbook/pages/home/pages/menu/pages/connections_circle/connections_circle.dart';
import 'package:Openbook/pages/home/pages/menu/pages/connections_circles/connections_circles.dart';
import 'package:Openbook/pages/home/pages/menu/pages/follows_list/follows_list.dart';
import 'package:Openbook/pages/home/pages/menu/pages/follows_lists/follows_lists.dart';
import 'package:Openbook/pages/home/pages/menu/widgets/settings/settings.dart';
import 'package:Openbook/pages/home/pages/post/post.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/widgets/routes/slide_right_route.dart';
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
      {@required BuildContext context,
      @required SharePostData createPostData}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSharePostPage'),
            widget: OBSharePostPage(
              sharePostData: createPostData,
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

  Future<void> navigateToEditCommunity(
      {@required Community community, @required BuildContext context}) {
    return Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obEditCommunityPage'),
            widget: OBManageCommunityPage(
              community: community,
            )));
  }
}
