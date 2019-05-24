import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/moderation/moderation_category.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/updatable_model.dart';
import 'package:Openbook/models/user.dart';
import 'package:dcache/dcache.dart';
import 'package:meta/meta.dart';

class ModeratedObject extends UpdatableModel<ModeratedObject> {
  static final factory = ModeratedObjectFactory();

  static String objectTypePost = 'P';
  static String objectTypePostComment = 'PC';
  static String objectTypeCommunity = 'C';
  static String objectTypeUser = 'C';
  static String statusPending = 'P';
  static String statusApproved = 'A';
  static String statusRejected = 'R';

  final int id;
  final Community community;

  dynamic contentObject;
  ModeratedObjectType type;
  ModeratedObjectStatus status;
  ModerationCategory category;

  String description;
  bool verified;

  ModeratedObject(
      {this.id,
      this.community,
      this.contentObject,
      this.type,
      this.status,
      this.category,
      this.description,
      this.verified});

  @override
  void updateFromJson(Map json) {
    if (json.containsKey('description')) {
      description = json['description'];
    }

    if (json.containsKey('verified')) {
      verified = json['verified'];
    }

    if (json.containsKey('status')) {
      status = factory.parseStatus(json['status']);
    }

    if (json.containsKey('type')) {
      type = factory.parseType(json['object_type']);
    }

    if (json.containsKey('content_object')) {
      contentObject = factory.parseContentObject(
          contentObjectData: json['content_object'], type: type);
    }
  }
}

class ModeratedObjectFactory extends UpdatableModelFactory<ModeratedObject> {
  @override
  SimpleCache<int, ModeratedObject> cache =
      SimpleCache(storage: UpdatableModelSimpleStorage(size: 120));

  @override
  ModeratedObject makeFromJson(Map json) {
    ModeratedObjectType type = parseType(json['object_type']);
    ModeratedObjectStatus status = parseStatus(json['status']);
    ModerationCategory category = parseModerationCategory(json['category']);
    Community community = parseCommunity(json['community']);

    return ModeratedObject(
        id: json['id'],
        community: community,
        category: category,
        description: json['description'],
        status: status,
        type: type,
        contentObject: parseContentObject(
            contentObjectData: json['content_object'], type: type),
        verified: json['verified']);
  }

  Community parseCommunity(Map communityData) {
    if (communityData == null) return null;
    return Community.fromJSON(communityData);
  }

  ModerationCategory parseModerationCategory(Map moderationCategoryData) {
    if (moderationCategoryData == null) return null;
    return ModerationCategory.fromJson(moderationCategoryData);
  }

  ModeratedObjectType parseType(String moderatedObjectTypeStr) {
    if (moderatedObjectTypeStr == null) return null;

    ModeratedObjectType moderatedObjectType;
    if (moderatedObjectTypeStr == ModeratedObject.objectTypeCommunity) {
      moderatedObjectType = ModeratedObjectType.community;
    } else if (moderatedObjectTypeStr == ModeratedObject.objectTypePost) {
      moderatedObjectType = ModeratedObjectType.post;
    } else if (moderatedObjectTypeStr ==
        ModeratedObject.objectTypePostComment) {
      moderatedObjectType = ModeratedObjectType.postComment;
    } else if (moderatedObjectTypeStr == ModeratedObject.objectTypeUser) {
      moderatedObjectType = ModeratedObjectType.user;
    } else {
      // Don't throw as we might introduce new moderatedObjects on the API which might not be yet in code
      print('Unsupported moderatedObject type');
    }

    return moderatedObjectType;
  }

  ModeratedObjectStatus parseStatus(String moderatedObjectStatusStr) {
    if (moderatedObjectStatusStr == null) return null;

    ModeratedObjectStatus moderatedObjectStatus;
    if (moderatedObjectStatusStr == ModeratedObject.statusPending) {
      moderatedObjectStatus = ModeratedObjectStatus.pending;
    } else if (moderatedObjectStatusStr == ModeratedObject.statusApproved) {
      moderatedObjectStatus = ModeratedObjectStatus.approved;
    } else if (moderatedObjectStatusStr == ModeratedObject.statusRejected) {
      moderatedObjectStatus = ModeratedObjectStatus.rejected;
    } else {
      // Don't throw as we might introduce new moderatedObjects on the API which might not be yet in code
      print('Unsupported moderatedObject status');
    }

    return moderatedObjectStatus;
  }

  dynamic parseContentObject(
      {@required Map contentObjectData, @required ModeratedObjectType type}) {
    if (contentObjectData == null) return null;

    dynamic contentObject;
    switch (type) {
      case ModeratedObjectType.post:
        contentObject = Post.fromJson(contentObjectData);
        break;
      case ModeratedObjectType.postComment:
        contentObject = PostComment.fromJSON(contentObjectData);
        break;
      case ModeratedObjectType.community:
        contentObject = Community.fromJSON(contentObjectData);
        break;
      case ModeratedObjectType.user:
        contentObject = User.fromJson(contentObjectData);
        break;
      default:
    }
    return contentObject;
  }

  DateTime parseCreated(String created) {
    return DateTime.parse(created).toLocal();
  }
}

enum ModeratedObjectType { post, postComment, user, community }

enum ModeratedObjectStatus {
  approved,
  rejected,
  pending,
}
