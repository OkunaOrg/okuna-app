import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/user.dart';

class CommunityInvite {
  final int id;
  final int creatorId;
  final int communityId;
  final int invitedUserId;

  User invitedUser;
  User creator;
  Community community;

  CommunityInvite(
      {this.id,
      this.creatorId,
      this.invitedUserId,
      this.communityId,
      this.community,
      this.invitedUser,
      this.creator});

  factory CommunityInvite.fromJSON(Map<String, dynamic> parsedJson) {
    assert(parsedJson != null);
    User invitedUser;
    if (parsedJson.containsKey('invited_user'))
      invitedUser = User.fromJson(parsedJson['invited_user']);

    User creator;
    if (parsedJson.containsKey('creator'))
      creator = User.fromJson(parsedJson['creator']);

    Community community;
    if (parsedJson.containsKey('community'))
      community = Community.fromJSON(parsedJson['community']);

    return CommunityInvite(
        id: parsedJson['id'],
        communityId: parsedJson['community_id'],
        creatorId: parsedJson['creator_id'],
        invitedUserId: parsedJson['invited_user_id'],
        community: community,
        invitedUser: invitedUser,
        creator: creator);
  }

  void updateFromJson(Map<String, dynamic> json) {
    // No dynamic fields, nothing to update
  }
}
