class UserProfile {
  final int id;
  final String name;
  final String birthDate;
  final String avatar;
  final String cover;
  final String bio;
  final bool followersCountVisible;

  UserProfile(
      {this.id,
      this.name,
      this.birthDate,
      this.avatar,
      this.cover,
      this.bio,
      this.followersCountVisible});

  factory UserProfile.fromJSON(Map<String, dynamic> parsedJson) {
    return UserProfile(
        id: parsedJson['id'],
        name: parsedJson['name'],
        birthDate: parsedJson['birth_date'],
        avatar: parsedJson['avatar'],
        cover: parsedJson['cover'],
        bio: parsedJson['bio'],
        followersCountVisible: parsedJson['followers_count_visible']
    );
  }
}
