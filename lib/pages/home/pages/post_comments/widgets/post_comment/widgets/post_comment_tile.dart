import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/pages/home/pages/post_comments/widgets/post_comment/widgets/post_comment_text.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';


class OBPostCommentTile extends StatelessWidget {
  final PostComment postComment;
  final Post post;

  OBPostCommentTile({
    @required this.post,
    @required this.postComment});

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    NavigationService _navigationService = provider.navigationService;
    GlobalKey _keyComment = GlobalKey();

    return StreamBuilder(
        key: Key('OBPostCommentTile#${this.postComment.id}'),
        stream: this.postComment.updateSubject,
        initialData: this.postComment,
        builder: (BuildContext context, AsyncSnapshot<PostComment> snapshot) {
          PostComment postComment = snapshot.data;

          Future.delayed(Duration(milliseconds: 1000), () {
            final RenderBox renderBoxRed = _keyComment.currentContext.findRenderObject();
            final sizeRed = renderBoxRed.size;
            print("SIZE of Comment tile: $sizeRed");
          });

          return Padding(
            key: _keyComment,
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
    Post post = this.post;
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