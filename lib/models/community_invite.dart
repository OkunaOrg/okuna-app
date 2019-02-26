class CommunityInvite {
  final int id;
  final int creatorId;
  final int communityId;
  final int invitedUserId;

  const CommunityInvite(
      {this.id, this.creatorId, this.invitedUserId, this.communityId});

  factory CommunityInvite.fromJSON(Map<String, dynamic> parsedJson) {
    return CommunityInvite(
        id: parsedJson['id'],
        communityId: parsedJson['community_id'],
        creatorId: parsedJson['creator_id'],
        invitedUserId: parsedJson['invited_user_id']);
  }

  void updateFromJson(Map<String, dynamic> json) {
    // No dynamic fields, nothing to update
  }
}
