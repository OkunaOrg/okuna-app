class UserProfile {
  final int id;
  final String name;
  final String birthDate;
  final String avatar;

  UserProfile({this.id, this.name, this.birthDate, this.avatar});

  factory UserProfile.fromJSON(Map<String, dynamic> parsedJson) {
    return UserProfile(
        id: parsedJson['id'],
        name: parsedJson['name'],
        birthDate: parsedJson['birth_date'],
        avatar: parsedJson['avatar']);
  }
}