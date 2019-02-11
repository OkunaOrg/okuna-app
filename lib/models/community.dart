import 'package:Openbook/models/categories_list.dart';
import 'package:Openbook/models/updatable_model.dart';
import 'package:Openbook/models/user.dart';
import 'package:dcache/dcache.dart';

class Community extends UpdatableModel<Community> {
  final int id;
  final User creator;
  String name;
  String title;
  String description;
  String type;
  String rules;
  String color;
  String avatar;
  String userAdjective;
  String usersAdjective;
  int membersCount;

  CategoriesList categories;

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
      this.membersCount,
      this.categories});

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
      type = json['type'];
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

    if (json.containsKey('color')) {
      color = json['color'];
    }

    if (json.containsKey('avatar')) {
      avatar = json['avatar'];
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
        color: json['color'],
        membersCount: json['members_count'],
        creator: parseUser(json['creator']),
        categories: parseCategories(json['categories']));
  }

  User parseUser(Map userData) {
    if (userData == null) return null;
    return User.fromJson(userData);
  }

  CategoriesList parseCategories(List categoriesData) {
    if (categoriesData == null) return null;
    return CategoriesList.fromJson(categoriesData);
  }
}
