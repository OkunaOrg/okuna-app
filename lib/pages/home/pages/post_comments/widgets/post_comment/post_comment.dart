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

  OBPostComment(
      {@required this.post,
      @required this.postComment,
      this.onPostCommentDeletedCallback,
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
    Widget postTile = _buildPostTile(widget.postComment);

    return OBPostCommentActions(
      post: widget.post,
      postComment: widget.postComment,
      onPostCommentDeletedCallback: widget.onPostCommentDeletedCallback,
      child: postTile,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildPostTile(PostComment postComment) {
    return StreamBuilder(
        stream: widget.postComment.updateSubject,
        initialData: widget.postComment,
        builder: (BuildContext context, AsyncSnapshot<PostComment> snapshot) {
          PostComment postComment = snapshot.data;

          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                OBAvatar(
                  onPressed: () {
                    _navigationService.navigateToUserProfile(
                        user: postComment.commenter, context: context);
                  },
                  size: OBAvatarSize.small,
                  avatarUrl: postComment.getCommenterProfileAvatar(),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    OBPostCommentText(
                      postComment,
                      badge: _getCommunityBadge(postComment),
                      onUsernamePressed: () {
                        _navigationService.navigateToUserProfile(
                            user: postComment.commenter, context: context);
                      },
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    OBSecondaryText(
                      postComment.getRelativeCreated(),
                      style: TextStyle(fontSize: 12.0),
                    )
                  ],
                ))
              ],
            ),
          );
        });
  }

  Widget _getCommunityBadge(PostComment postComment) {
    Post post = widget.post;
    User postCommenter = postComment.commenter;

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
