import 'package:Openbook/models/badge.dart';
import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/community_invite.dart';
import 'package:Openbook/models/community_invite_list.dart';
import 'package:Openbook/models/community_membership.dart';
import 'package:Openbook/models/community_membership_list.dart';
import 'package:Openbook/models/follows_lists_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/updatable_model.dart';
import 'package:Openbook/models/user_notifications_settings.dart';
import 'package:Openbook/models/user_profile.dart';
import 'package:dcache/dcache.dart';

class User extends UpdatableModel<User> {
  int id;
  String uuid;
  int connectionsCircleId;
  String email;
  String username;
  UserProfile profile;
  UserNotificationsSettings notificationsSettings;
  int followersCount;
  int followingCount;
  int unreadNotificationsCount;
  int postsCount;
  int inviteCount;
  bool areGuidelinesAccepted;
  bool isFollowing;
  bool isConnected;
  bool isReported;
  bool isBlocked;
  bool isFullyConnected;
  bool isPendingConnectionConfirmation;
  bool isMemberOfCommunities;
  CirclesList connectedCircles;
  FollowsListsList followLists;
  CommunityMembershipList communitiesMemberships;
  CommunityInviteList communitiesInvites;

  static final navigationUsersFactory = UserFactory(
      cache:
          LfuCache<int, User>(storage: UpdatableModelSimpleStorage(size: 100)));
  static final sessionUsersFactory = UserFactory(
      cache: SimpleCache<int, User>(
          storage: UpdatableModelSimpleStorage(size: 10)));

  factory User.fromJson(Map<String, dynamic> json,
      {bool storeInSessionCache = false}) {
    int userId = json['id'];

    User user = navigationUsersFactory.getItemWithIdFromCache(userId) ??
        sessionUsersFactory.getItemWithIdFromCache(userId);

    if (user != null) {
      user.update(json);
      return user;
    }
    return storeInSessionCache
        ? sessionUsersFactory.fromJson(json)
        : navigationUsersFactory.fromJson(json);
  }

  static void clearNavigationCache() {
    navigationUsersFactory.clearCache();
  }

  static void clearSessionCache() {
    sessionUsersFactory.clearCache();
  }

  User(
      {this.id,
      this.uuid,
      this.connectionsCircleId,
      this.username,
      this.email,
      this.profile,
      this.notificationsSettings,
      this.followersCount,
      this.followingCount,
      this.unreadNotificationsCount,
      this.postsCount,
      this.inviteCount,
      this.isFollowing,
      this.isBlocked,
      this.isConnected,
      this.isReported,
      this.isFullyConnected,
      this.isMemberOfCommunities,
      this.connectedCircles,
      this.followLists,
      this.communitiesMemberships,
      this.communitiesInvites,
      this.areGuidelinesAccepted});

  void updateFromJson(Map json) {
    if (json.containsKey('username')) username = json['username'];
    if (json.containsKey('uuid')) uuid = json['uuid'];
    if (json.containsKey('are_guidelines_accepted'))
      areGuidelinesAccepted = json['are_guidelines_accepted'];
    if (json.containsKey('email')) email = json['email'];
    if (json.containsKey('profile')) {
      if (profile != null) {
        profile.updateFromJson(json['profile']);
      } else {
        profile = navigationUsersFactory.parseUserProfile(json['profile']);
      }
    }
    if (json.containsKey('notifications_settings')) {
      if (notificationsSettings != null) {
        notificationsSettings.updateFromJson(json['notifications_settings']);
      } else {
        notificationsSettings = navigationUsersFactory
            .parseUserNotificationsSettings(json['notifications_settings']);
      }
    }
    if (json.containsKey('followers_count'))
      followersCount = json['followers_count'];
    if (json.containsKey('following_count'))
      followingCount = json['following_count'];
    if (json.containsKey('unread_notifications_count'))
      unreadNotificationsCount = json['unread_notifications_count'];
    if (json.containsKey('posts_count')) postsCount = json['posts_count'];
    if (json.containsKey('invite_count')) inviteCount = json['invite_count'];
    if (json.containsKey('is_following')) isFollowing = json['is_following'];
    if (json.containsKey('is_connected')) isConnected = json['is_connected'];
    if (json.containsKey('is_blocked')) isBlocked = json['is_blocked'];
    if (json.containsKey('is_reported')) isReported = json['is_reported'];
    if (json.containsKey('connections_circle_id'))
      connectionsCircleId = json['connections_circle_id'];
    if (json.containsKey('is_fully_connected'))
      isFullyConnected = json['is_fully_connected'];
    if (json.containsKey('is_pending_connection_confirmation'))
      isPendingConnectionConfirmation =
          json['is_pending_connection_confirmation'];
    if (json.containsKey('connected_circles')) {
      connectedCircles =
          navigationUsersFactory.parseCircles(json['connected_circles']);
    }
    if (json.containsKey('is_member_of_communities')) {
      isMemberOfCommunities = json['is_member_of_communities'];
    }
    if (json.containsKey('follow_lists')) {
      followLists =
          navigationUsersFactory.parseFollowsLists(json['follow_lists']);
    }
    if (json.containsKey('communities_memberships')) {
      communitiesMemberships = navigationUsersFactory
          .parseMemberships(json['communities_memberships']);
    }
    if (json.containsKey('communities_invites')) {
      communitiesInvites =
          navigationUsersFactory.parseInvites(json['communities_invites']);
    }
  }

  String getEmail() {
    return this.email;
  }

  bool hasProfileLocation() {
    return profile.hasLocation();
  }

  bool hasProfileUrl() {
    return profile.hasUrl();
  }

  bool hasProfileAvatar() {
    return this.profile.avatar != null;
  }

  bool hasProfileCover() {
    return this.profile.cover != null;
  }

  String getProfileAvatar() {
    return this.profile?.avatar;
  }

  String getProfileName() {
    return this.profile.name;
  }

  String getProfileCover() {
    return this.profile.cover;
  }

  String getProfileBio() {
    return this.profile.bio;
  }

  bool getProfileFollowersCountVisible() {
    return this.profile.followersCountVisible;
  }

  String getProfileUrl() {
    return this.profile.url;
  }

  String getProfileLocation() {
    return this.profile.location;
  }

  List<Badge> getProfileBadges() {
    return this.profile.badges;
  }

  bool hasProfileBadges() {
    return this.profile.badges != null && this.profile.badges.length > 0;
  }

  bool isConnectionsCircle(Circle circle) {
    return connectionsCircleId != null && connectionsCircleId == circle.id;
  }

  bool hasFollowLists() {
    return followLists != null && followLists.lists.length > 0;
  }

  bool isAdministratorOfCommunity(Community community) {
    CommunityMembership membership = getMembershipForCommunity(community);
    if (membership == null) return false;
    return membership.isAdministrator;
  }

  bool isModeratorOfCommunity(Community community) {
    CommunityMembership membership = getMembershipForCommunity(community);
    if (membership == null) return false;
    return membership.isModerator;
  }

  bool isMemberOfCommunity(Community community) {
    return getMembershipForCommunity(community) != null;
  }

  CommunityMembership getMembershipForCommunity(Community community) {
    if (communitiesMemberships == null) return null;

    int membershipIndex = communitiesMemberships.communityMemberships
        .indexWhere((CommunityMembership communityMembership) {
      return communityMembership.userId == this.id &&
          communityMembership.communityId == community.id;
    });

    if (membershipIndex < 0) return null;

    return communitiesMemberships.communityMemberships[membershipIndex];
  }

  bool isInvitedToCommunity(Community community) {
    CommunityInvite invite = getInviteForCommunity(community);
    return invite != null;
  }

  CommunityInvite getInviteForCommunity(Community community) {
    if (communitiesInvites == null) return null;

    int inviteIndex = communitiesInvites.communityInvites
        .indexWhere((CommunityInvite communityInvite) {
      return communityInvite.communityId == community.id;
    });

    if (inviteIndex < 0) return null;

    return communitiesInvites.communityInvites[inviteIndex];
  }

  bool hasUnreadNotifications() {
    return unreadNotificationsCount != null && unreadNotificationsCount > 0;
  }

  void resetUnreadNotificationsCount() {
    this.unreadNotificationsCount = 0;
    notifyUpdate();
  }

  void incrementUnreadNotificationsCount() {
    if (this.unreadNotificationsCount != null) {
      this.unreadNotificationsCount += 1;
      notifyUpdate();
    }
  }

  void incrementFollowersCount() {
    if (this.followersCount != null) {
      this.followersCount += 1;
      notifyUpdate();
    }
  }

  void decrementFollowersCount() {
    if (this.followersCount != null && this.followersCount > 0) {
      this.followersCount -= 1;
      notifyUpdate();
    }
  }

  void setIsReported(isReported) {
    this.isReported = isReported;
    notifyUpdate();
  }

  bool canDisableOrEnableCommentsForPost(Post post) {
    User loggedInUser = this;
    bool _canDisableOrEnableComments = false;

    if (post.hasCommunity()) {
      Community postCommunity = post.community;

      if (postCommunity.isAdministrator(loggedInUser) ||
          postCommunity.isModerator(loggedInUser)) {
        _canDisableOrEnableComments = true;
      }
    }
    return _canDisableOrEnableComments;
  }

  bool canCloseOrOpenPost(Post post) {
    User loggedInUser = this;
    bool _canCloseOrOpenPost = false;

    if (post.hasCommunity()) {
      Community postCommunity = post.community;

      if (postCommunity.isAdministrator(loggedInUser) ||
          postCommunity.isModerator(loggedInUser)) {
        _canCloseOrOpenPost = true;
      }
    }
    return _canCloseOrOpenPost;
  }

  bool canCloseOrOpenPostsInCommunity(Community community) {
    User loggedInUser = this;
    bool _canCloseOrOpenPost = false;

    if (community.isAdministrator(loggedInUser) ||
        community.isModerator(loggedInUser)) {
      _canCloseOrOpenPost = true;
    }

    return _canCloseOrOpenPost;
  }

  bool canBanOrUnbanUsersInCommunity(Community community) {
    User loggedInUser = this;
    bool _canBanOrUnban = false;

    if (community.isAdministrator(loggedInUser) ||
        community.isModerator(loggedInUser)) {
      _canBanOrUnban = true;
    }

    return _canBanOrUnban;
  }

  bool isCreatorOfCommunity(Community community) {
    return community.isCreator;
  }

  bool canChangeDetailsOfCommunity(Community community) {
    User loggedInUser = this;
    bool _canChangeDetails = false;

    if (community.isAdministrator(loggedInUser)) {
      _canChangeDetails = true;
    }

    return _canChangeDetails;
  }

  bool canAddOrRemoveModeratorsInCommunity(Community community) {
    User loggedInUser = this;
    bool _canAddOrRemoveMods = false;

    if (community.isAdministrator(loggedInUser)) {
      _canAddOrRemoveMods = true;
    }

    return _canAddOrRemoveMods;
  }

  bool canAddOrRemoveAdministratorsInCommunity(Community community) {
    return community.isCreator;
  }

  bool canCommentOnPostWithDisabledComments(Post post) {
    User loggedInUser = this;
    bool _canComment = false;

    if (post.hasCommunity()) {
      Community postCommunity = post.community;

      if (postCommunity.isAdministrator(loggedInUser) ||
          postCommunity.isModerator(loggedInUser)) {
        _canComment = true;
      }
    }
    return _canComment;
  }

  bool isStaffForCommunity(Community community) {
    User loggedInUser = this;
    bool loggedInUserIsCommunityAdministrator = false;
    bool loggedInUserIsCommunityModerator = false;

    loggedInUserIsCommunityAdministrator =
        community.isAdministrator(loggedInUser);

    loggedInUserIsCommunityModerator = community.isModerator(loggedInUser);

    return loggedInUserIsCommunityModerator ||
        loggedInUserIsCommunityAdministrator;
  }

  bool canDeletePost(Post post) {
    User loggedInUser = this;
    bool loggedInUserIsPostCreator = loggedInUser.id == post.getCreatorId();
    bool _canDelete = false;
    bool loggedInUserIsStaffForCommunity = false;

    if (post.hasCommunity()) {
      loggedInUserIsStaffForCommunity =
          this.isStaffForCommunity(post.community);
    }

    if (loggedInUserIsPostCreator || loggedInUserIsStaffForCommunity) {
      _canDelete = true;
    }

    return _canDelete;
  }

  bool canEditPost(Post post) {
    User loggedInUser = this;
    bool loggedInUserIsPostCreator = loggedInUser.id == post.getCreatorId();

    return loggedInUserIsPostCreator && !post.isClosed;
  }

  bool canEditPostComment(PostComment postComment, Post post) {
    User loggedInUser = this;
    User postCommenter = postComment.commenter;
    bool loggedInUserIsStaffForCommunity = false;
    bool loggedInUserIsCommenter = loggedInUser.id == postCommenter.id;
    bool loggedInUserIsCommenterForOpenPost =
        loggedInUserIsCommenter && !post.isClosed && post.areCommentsEnabled;

    if (post.hasCommunity()) {
      loggedInUserIsStaffForCommunity = isStaffForCommunity(post.community);
    }

    return loggedInUserIsCommenterForOpenPost ||
        (loggedInUserIsStaffForCommunity && loggedInUserIsCommenter);
  }

  bool canReportPostComment(PostComment postComment) {
    User loggedInUser = this;
    User postCommenter = postComment.commenter;

    return loggedInUser.id != postCommenter.id;
  }

  bool canReplyPostComment(PostComment postComment) {
    return postComment.parentComment == null;
  }

  bool canDeletePostComment(Post post, PostComment postComment) {
    User loggedInUser = this;
    User postCommenter = postComment.commenter;
    bool loggedInUserIsPostCreator = loggedInUser.id == post.getCreatorId();
    bool userIsCreatorOfNonCommunityPost =
        loggedInUserIsPostCreator && !post.hasCommunity();
    bool loggedInUserIsStaffForCommunity = false;
    bool loggedInUserIsCommenterForOpenPost =
        (loggedInUser.id == postCommenter.id) && !post.isClosed;

    if (post.hasCommunity()) {
      loggedInUserIsStaffForCommunity =
          this.isStaffForCommunity(post.community);
    }

    return (loggedInUserIsCommenterForOpenPost ||
        loggedInUserIsStaffForCommunity ||
        userIsCreatorOfNonCommunityPost);
  }

  bool canBlockOrUnblockUser(User user) {
    return user.id != id;
  }
}

class UserFactory extends UpdatableModelFactory<User> {
  UserFactory({cache}) : super(cache: cache);

  @override
  User makeFromJson(Map json) {
    return User(
        id: json['id'],
        uuid: json['uuid'],
        areGuidelinesAccepted: json['are_guidelines_accepted'],
        connectionsCircleId: json['connections_circle_id'],
        followersCount: json['followers_count'],
        postsCount: json['posts_count'],
        inviteCount: json['invite_count'],
        unreadNotificationsCount: json['unread_notifications_count'],
        email: json['email'],
        username: json['username'],
        followingCount: json['following_count'],
        isFollowing: json['is_following'],
        isConnected: json['is_connected'],
        isBlocked: json['is_blocked'],
        isReported: json['is_reported'],
        isFullyConnected: json['is_fully_connected'],
        isMemberOfCommunities: json['is_member_of_communities'],
        profile: parseUserProfile(json['profile']),
        connectedCircles: parseCircles(json['connected_circles']),
        communitiesMemberships:
            parseMemberships(json['communities_memberships']),
        communitiesInvites: parseInvites(json['communities_invites']),
        followLists: parseFollowsLists(json['follow_lists']));
  }

  CommunityMembershipList parseMemberships(List membershipsData) {
    if (membershipsData == null) return null;
    return CommunityMembershipList.fromJson(membershipsData);
  }

  CommunityInviteList parseInvites(List invitesData) {
    if (invitesData == null) return null;
    return CommunityInviteList.fromJson(invitesData);
  }

  UserProfile parseUserProfile(Map profile) {
    if (profile == null) return null;
    return UserProfile.fromJSON(profile);
  }

  UserNotificationsSettings parseUserNotificationsSettings(
      Map notificationsSettings) {
    if (notificationsSettings == null) return null;
    return UserNotificationsSettings.fromJSON(notificationsSettings);
  }

  CirclesList parseCircles(List circlesData) {
    if (circlesData == null) return null;
    return CirclesList.fromJson(circlesData);
  }

  FollowsListsList parseFollowsLists(List followsListsData) {
    if (followsListsData == null) return null;
    return FollowsListsList.fromJson(followsListsData);
  }
}
