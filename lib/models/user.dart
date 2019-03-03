import 'package:Openbook/models/badge.dart';
import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/community_invite.dart';
import 'package:Openbook/models/community_invite_list.dart';
import 'package:Openbook/models/community_membership.dart';
import 'package:Openbook/models/community_membership_list.dart';
import 'package:Openbook/models/follows_lists_list.dart';
import 'package:Openbook/models/updatable_model.dart';
import 'package:Openbook/models/user_notifications_settings.dart';
import 'package:Openbook/models/user_profile.dart';
import 'package:dcache/dcache.dart';
import 'package:meta/meta.dart';

class User extends UpdatableModel<User> {
  int id;
  int connectionsCircleId;
  String email;
  String username;
  UserProfile profile;
  UserNotificationsSettings notificationsSettings;
  int followersCount;
  int followingCount;
  int postsCount;
  bool isFollowing;
  bool isConnected;
  bool isFullyConnected;
  bool isPendingConnectionConfirmation;
  bool isMemberOfCommunities;
  CirclesList connectedCircles;
  FollowsListsList followLists;
  CommunityMembershipList communitiesMemberships;
  CommunityInviteList communitiesInvites;
  CommunityInviteList createdCommunitiesInvites;

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

  User({
    this.id,
    this.connectionsCircleId,
    this.username,
    this.email,
    this.profile,
    this.notificationsSettings,
    this.followersCount,
    this.followingCount,
    this.postsCount,
    this.isFollowing,
    this.isConnected,
    this.isFullyConnected,
    this.isMemberOfCommunities,
    this.connectedCircles,
    this.followLists,
    this.communitiesMemberships,
    this.communitiesInvites,
    this.createdCommunitiesInvites,
  });

  void updateFromJson(Map json) {
    if (json.containsKey('username')) username = json['username'];
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
        notificationsSettings = navigationUsersFactory.parseUserNotificationsSettings(json['notifications_settings']);
      }
    }
    if (json.containsKey('followers_count'))
      followersCount = json['followers_count'];
    if (json.containsKey('following_count'))
      followingCount = json['following_count'];
    if (json.containsKey('posts_count')) postsCount = json['posts_count'];
    if (json.containsKey('is_following')) isFollowing = json['is_following'];
    if (json.containsKey('is_connected')) isConnected = json['is_connected'];
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

    if (json.containsKey('created_communities_invites')) {
      createdCommunitiesInvites = navigationUsersFactory
          .parseInvites(json['created_communities_invites']);
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
    return this.profile.avatar;
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

  bool hasInvitedUserToCommunity(
      {@required User user, @required Community community}) {
    CommunityInvite createdInvite =
        getCreatedInviteForUserAndCommunity(user: user, community: community);
    return createdInvite != null;
  }

  CommunityInvite getCreatedInviteForUserAndCommunity(
      {@required User user, @required Community community}) {
    if (createdCommunitiesInvites == null) return null;

    int inviteIndex = createdCommunitiesInvites.communityInvites
        .indexWhere((CommunityInvite communityInvite) {
      return communityInvite.communityId == community.id &&
          communityInvite.invitedUserId == user.id;
    });

    if (inviteIndex < 0) return null;

    return createdCommunitiesInvites.communityInvites[inviteIndex];
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
}

class UserFactory extends UpdatableModelFactory<User> {
  UserFactory({cache}) : super(cache: cache);

  @override
  User makeFromJson(Map json) {
    return User(
        id: json['id'],
        connectionsCircleId: json['connections_circle_id'],
        followersCount: json['followers_count'],
        postsCount: json['posts_count'],
        email: json['email'],
        username: json['username'],
        followingCount: json['following_count'],
        isFollowing: json['is_following'],
        isConnected: json['is_connected'],
        isFullyConnected: json['is_fully_connected'],
        isMemberOfCommunities: json['is_member_of_communities'],
        profile: parseUserProfile(json['profile']),
        connectedCircles: parseCircles(json['connected_circles']),
        communitiesMemberships:
            parseMemberships(json['communities_memberships']),
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
    return UserProfile.fromJSON(profile);
  }

  UserNotificationsSettings parseUserNotificationsSettings(Map notificationsSettings) {
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
