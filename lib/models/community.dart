import 'package:Openbook/models/categories_list.dart';
import 'package:Openbook/models/updatable_model.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:dcache/dcache.dart';

class Community extends UpdatableModel<Community> {
  final int id;
  final User creator;
  String name;
  String title;
  String description;
  String rules;
  String color;
  String avatar;
  String cover;
  String userAdjective;
  String usersAdjective;
  int membersCount;
  CommunityType type;

  // Whether the user has been invited to the community
  bool isInvited;

  // Whether the user is member of the community
  bool isMember;

  // Whether the user is admin of the community
  bool isAdmin;

  // Whether the user is mod of the community
  bool isMod;

  // Whether the user is the creator of the community
  bool isCreator;

  CategoriesList categories;

  UsersList moderators;

  UsersList administrators;

  Community(
      {this.id,
      this.creator,
      this.rules,
      this.avatar,
      this.title,
      this.type,
      this.userAdjective,
      this.usersAdjective,
      this.description,
      this.name,
      this.color,
      this.cover,
      this.isInvited,
      this.isMember,
      this.isAdmin,
      this.isCreator,
      this.moderators,
      this.administrators,
      this.isMod,
      this.membersCount,
      this.categories});

  bool hasDescription() {
    return description != null;
  }

  static final factory = CommunityFactory();

  factory Community.fromJSON(Map<String, dynamic> json) {
    return factory.fromJson(json);
  }

  @override
  void updateFromJson(Map json) {
    if (json.containsKey('name')) {
      name = json['name'];
    }

    if (json.containsKey('type')) {
      type = factory.parseType(json['type']);
    }

    if (json.containsKey('is_invited')) {
      isInvited = json['is_invited'];
    }

    if (json.containsKey('is_member')) {
      isMember = json['is_member'];
    }

    if (json.containsKey('is_admin')) {
      isAdmin = json['is_admin'];
    }

    if (json.containsKey('is_mod')) {
      isMod = json['is_mod'];
    }

    if (json.containsKey('is_creator')) {
      isCreator = json['is_creator'];
    }

    if (json.containsKey('title')) {
      title = json['title'];
    }

    if (json.containsKey('rules')) {
      rules = json['rules'];
    }

    if (json.containsKey('description')) {
      description = json['description'];
    }

    if (json.containsKey('user_adjective')) {
      userAdjective = json['user_adjective'];
    }

    if (json.containsKey('users_adjective')) {
      usersAdjective = json['users_adjective'];
    }

    if (json.containsKey('color')) {
      color = json['color'];
    }

    if (json.containsKey('avatar')) {
      avatar = json['avatar'];
    }

    if (json.containsKey('cover')) {
      cover = json['cover'];
    }

    if (json.containsKey('members_count')) {
      membersCount = json['members_count'];
    }
    if (json.containsKey('color')) {
      color = json['color'];
    }

    if (json.containsKey('categories')) {
      categories = factory.parseCategories(json['categories']);
    }

    if (json.containsKey('moderators')) {
      moderators = factory.parseUsers(json['moderators']);
    }

    if (json.containsKey('administrators')) {
      administrators = factory.parseUsers(json['administrators']);
    }
  }
}

class CommunityFactory extends UpdatableModelFactory<Community> {
  @override
  SimpleCache<int, Community> cache =
      SimpleCache(storage: SimpleStorage(size: 20));

  @override
  Community makeFromJson(Map json) {
    return Community(
        id: json['id'],
        name: json['name'],
        title: json['title'],
        description: json['description'],
        rules: json['rules'],
        avatar: json['avatar'],
        isInvited: json['is_invited'],
        isMember: json['is_member'],
        isAdmin: json['is_admin'],
        isMod: json['is_moderator'],
        isCreator: json['is_creator'],
        cover: json['cover'],
        color: json['color'],
        membersCount: json['members_count'],
        userAdjective: json['user_adjective'],
        usersAdjective: json['users_adjective'],
        type: parseType(json['type']),
        creator: parseUser(json['creator']),
        moderators: parseUsers(json['moderators']),
        administrators: parseUsers(json['administrators']),
        categories: parseCategories(json['categories']));
  }

  User parseUser(Map userData) {
    if (userData == null) return null;
    return User.fromJson(userData);
  }

  UsersList parseUsers(List usersData) {
    if (usersData == null) return null;
    return UsersList.fromJson(usersData);
  }

  CategoriesList parseCategories(List categoriesData) {
    if (categoriesData == null) return null;
    return CategoriesList.fromJson(categoriesData);
  }

  CommunityType parseType(String strType) {
    if (strType == null) return null;

    CommunityType type;
    if (strType == 'P') {
      type = CommunityType.public;
    } else if (strType == 'T') {
      type = CommunityType.private;
    } else {
      throw 'Unsupported community type';
    }

    return type;
  }
}

enum CommunityType { public, private }
