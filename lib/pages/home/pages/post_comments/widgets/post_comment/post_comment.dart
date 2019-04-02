import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post_comment/packages/post_comment_text.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post_comment/post_comment_actions.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/bottom_sheet.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

class OBPostComment extends StatefulWidget {
  final PostComment postComment;
  final Post post;
  final VoidCallback onPostCommentDeletedCallback;
  final void Function(PostComment) onPostCommentEditedCallback;

  OBPostComment(
      {@required this.post,
      @required this.postComment,
      this.onPostCommentDeletedCallback,
      this.onPostCommentEditedCallback,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBPostCommentState();
  }
}

class OBPostCommentState extends State<OBPostComment> {
  NavigationService _navigationService;
  BottomSheetService _bottomSheetService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _navigationService = provider.navigationService;
    _bottomSheetService = provider.bottomSheetService;

    Widget postTile = _buildPostTile();

    return OBPostCommentActions(
      post: widget.post,
      postComment: widget.postComment,
      onPostCommentDeletedCallback: widget.onPostCommentDeletedCallback,
      onPostCommentEditedCallback: widget.onPostCommentEditedCallback,
      child: postTile,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildPostTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OBAvatar(
            onPressed: () {
              _navigationService.navigateToUserProfile(
                  user: widget.postComment.commenter, context: context);
            },
            size: OBAvatarSize.small,
            avatarUrl: widget.postComment.getCommenterProfileAvatar(),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              OBPostCommentText(
                widget.postComment,
                badge: _getCommunityBadge(),
                onUsernamePressed: () {
                  _navigationService.navigateToUserProfile(
                      user: widget.postComment.commenter, context: context);
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              OBSecondaryText(
                widget.postComment.getRelativeCreated(),
                style: TextStyle(fontSize: 12.0),
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _getCommunityBadge() {
    Post post = widget.post;
    User postCommenter = widget.postComment.commenter;

    if (post.hasCommunity()) {
      Community postCommunity = post.community;

      bool isCommunityAdministrator =
          postCommenter.isAdministratorOfCommunity(postCommunity);

      if (isCommunityAdministrator) {
        return _buildCommunityAdministratorBadge();
      }

      bool isCommunityModerator =
          postCommenter.isModeratorOfCommunity(postCommunity);

      if (isCommunityModerator) {
        return _buildCommunityModeratorBadge();
      }
    }

    return const SizedBox();
  }

  Widget _buildCommunityAdministratorBadge() {
    return const OBIcon(
      OBIcons.communityAdministrators,
      size: OBIconSize.small,
      themeColor: OBIconThemeColor.primaryAccent,
    );
  }

  Widget _buildCommunityModeratorBadge() {
    return const OBIcon(
      OBIcons.communityModerators,
      size: OBIconSize.small,
      themeColor: OBIconThemeColor.primaryAccent,
    );
  }
}

typedef void OnWantsToSeeUserProfile(User user);
