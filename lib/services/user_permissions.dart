import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/services/user.dart';

class UserPermissionsService {

  UserService _userService;

  void setUserService(UserService userService) {
    _userService = userService;
  }

  bool canDisableEnableCommentsForPost(Post post) {
    User loggedInUser = _userService.getLoggedInUser();
    bool _canDisableEnableComments = false;

    if (post.hasCommunity()) {
      Community postCommunity = post.community;

      if (postCommunity.isAdministrator(loggedInUser) || postCommunity.isModerator(loggedInUser)) {
        _canDisableEnableComments = true;
      }
    }
    return _canDisableEnableComments;
  }

  bool canCommentOnPostWithDisabledComments(Post post) {
    User loggedInUser = _userService.getLoggedInUser();
    bool _canComment = false;

    if (post.hasCommunity()) {
      Community postCommunity = post.community;

      if (postCommunity.isAdministrator(loggedInUser) || postCommunity.isModerator(loggedInUser)) {
        _canComment = true;
      }
    }
    return _canComment;
  }

  bool canDeletePost(Post post) {
    User loggedInUser = _userService.getLoggedInUser();
    bool loggedInUserIsPostCreator = loggedInUser.id == post.getCreatorId();
    bool loggedInUserIsCommunityAdministrator = false;
    bool loggedInUserIsCommunityModerator = false;
    bool _canDelete = false;

    if (post.hasCommunity()) {
      Community postCommunity = post.community;

      loggedInUserIsCommunityAdministrator =
          postCommunity.isAdministrator(loggedInUser);

      loggedInUserIsCommunityModerator =
          postCommunity.isModerator(loggedInUser);
    }

    if (loggedInUserIsPostCreator || loggedInUserIsCommunityAdministrator || loggedInUserIsCommunityModerator) {
      _canDelete = true;
    }

    return _canDelete;
  }

  bool canEditPost(Post post) {
    User loggedInUser = _userService.getLoggedInUser();
    bool loggedInUserIsPostCreator = loggedInUser.id == post.getCreatorId();
    return loggedInUserIsPostCreator;
  }

  bool canEditPostComment(PostComment postComment) {
    User loggedInUser = _userService.getLoggedInUser();
    User postCommenter = postComment.commenter;

    return loggedInUser.id == postCommenter.id;

  }

  bool canDeletePostComment(Post post, PostComment postComment) {
    User loggedInUser = _userService.getLoggedInUser();
    User postCommenter = postComment.commenter;
    bool loggedInUserIsCommunityAdministrator = false;
    bool loggedInUserIsCommunityModerator = false;

    return (loggedInUser.id == postCommenter.id
        || loggedInUserIsCommunityModerator
        || loggedInUserIsCommunityAdministrator);

  }
}