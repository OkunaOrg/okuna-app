import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:dcache/dcache.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:Openbook/models/updatable_model.dart';

class PostComment extends UpdatableModel<PostComment> {
  final int id;
  int creatorId;
  DateTime created;
  String text;
  User commenter;
  Post post;
  bool isEdited;

  static convertPostCommentSortTypeToString(PostCommentsSortType type) {
    String result;
    switch (type) {
      case PostCommentsSortType.asc:
        result = 'ASC';
        break;
      case PostCommentsSortType.dec:
        result = 'DESC';
        break;
      default:
        throw 'Unsupported post comment sort type';
    }
    return result;
  }

  static PostCommentsSortType parsePostCommentSortType(String sortType) {
    PostCommentsSortType type;
    if (sortType == 'ASC') {
      type = PostCommentsSortType.asc;
    }

    if (sortType == 'DESC') {
      type = PostCommentsSortType.dec;
    }

    return type;
  }

  PostComment(
      {this.id,
      this.created,
      this.text,
      this.creatorId,
      this.commenter,
      this.post,
      this.isEdited});

  static final factory = PostCommentFactory();

  factory PostComment.fromJSON(Map<String, dynamic> json) {
    return factory.fromJson(json);
  }

  @override
  void updateFromJson(Map json) {
    if (json.containsKey('commenter')) {
      commenter = factory.parseUser(json['commenter']);
    }

    if (json.containsKey('creater_id')) {
      creatorId = json['creator_id'];
    }

    if (json.containsKey('is_edited')) {
      isEdited = json['is_edited'];
    }

    if (json.containsKey('text')) {
      text = json['text'];
    }

    if (json.containsKey('post')) {
      post = factory.parsePost(json['post']);
    }

    if (json.containsKey('created')) {
      created = factory.parseCreated(json['created']);
    }
  }

  String getRelativeCreated() {
    return timeago.format(created);
  }

  String getCommenterUsername() {
    return this.commenter.username;
  }

  String getCommenterName() {
    return this.commenter.getProfileName();
  }

  String getCommenterProfileAvatar() {
    return this.commenter.getProfileAvatar();
  }

  int getCommenterId() {
    return this.commenter.id;
  }

  int getPostCreatorId() {
    return post.getCreatorId();
  }
}

class PostCommentFactory extends UpdatableModelFactory<PostComment> {
  @override
  SimpleCache<int, PostComment> cache =
      LruCache(storage: UpdatableModelSimpleStorage(size: 200));

  @override
  PostComment makeFromJson(Map json) {
    return PostComment(
        id: json['id'],
        creatorId: json['creator_id'],
        created: parseCreated(json['created']),
        commenter: parseUser(json['commenter']),
        post: parsePost(json['post']),
        isEdited: json['is_edited'],
        text: json['text']);
  }

  Post parsePost(Map post) {
    if (post == null) return null;
    return Post.fromJson(post);
  }

  DateTime parseCreated(String created) {
    if (created == null) return null;
    return DateTime.parse(created).toLocal();
  }

  User parseUser(Map userData) {
    if (userData == null) return null;
    return User.fromJson(userData);
  }
}

enum PostCommentsSortType { asc, dec }
