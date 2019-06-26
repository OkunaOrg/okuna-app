import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment_list.dart';
import 'package:Openbook/models/post_comment_reaction.dart';
import 'package:Openbook/models/reactions_emoji_count.dart';
import 'package:Openbook/models/reactions_emoji_count_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:dcache/dcache.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:Openbook/models/updatable_model.dart';

import 'emoji.dart';

class PostComment extends UpdatableModel<PostComment> {
  final int id;
  int creatorId;
  int repliesCount;
  DateTime created;
  String text;
  User commenter;
  PostComment parentComment;
  PostCommentList replies;
  ReactionsEmojiCountList reactionsEmojiCounts;
  PostCommentReaction reaction;

  Post post;
  bool isEdited;
  bool isReported;

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

  static void clearCache() {
    factory.clearCache();
  }

  PostComment(
      {this.id,
      this.created,
      this.text,
      this.creatorId,
      this.commenter,
      this.post,
      this.isEdited,
      this.isReported,
      this.parentComment,
      this.replies,
      this.repliesCount,
      this.reactionsEmojiCounts,
      this.reaction});

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

    if (json.containsKey('replies_count')) {
      repliesCount = json['replies_count'];
    }

    if (json.containsKey('is_edited')) {
      isEdited = json['is_edited'];
    }

    if (json.containsKey('is_reported')) {
      isReported = json['is_reported'];
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

    if (json.containsKey('parent_comment')) {
      parentComment = factory.parseParentComment(json['parent_comment']);
    }

    if (json.containsKey('replies')) {
      replies = factory.parseCommentReplies(json['replies']);
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

  bool hasReplies() {
    return repliesCount != null && repliesCount > 0 && replies != null;
  }

  List<PostComment> getPostCommentReplies() {
    if (replies == null) return [];
    return replies.comments;
  }

  int getCommenterId() {
    return this.commenter.id;
  }

  int getPostCreatorId() {
    return post.getCreatorId();
  }

  void setIsReported(isReported) {
    this.isReported = isReported;
    notifyUpdate();
  }

  void clearReaction() {
    this.setReaction(null);
  }

  bool isReactionEmoji(Emoji emoji) {
    return hasReaction() && reaction.getEmojiId() == emoji.id;
  }

  void setReaction(PostCommentReaction newReaction) {
    bool hasReaction = this.hasReaction();

    if (!hasReaction && newReaction == null) {
      throw 'Trying to remove no reaction';
    }

    var newEmojiCounts = reactionsEmojiCounts.counts.toList();

    if (hasReaction) {
      var currentReactionEmojiCount = newEmojiCounts.firstWhere((emojiCount) {
        return emojiCount.getEmojiId() == reaction.getEmojiId();
      });

      if (currentReactionEmojiCount.count > 1) {
        // Decrement emoji reaction counts
        currentReactionEmojiCount.count -= 1;
      } else {
        // Remove emoji reaction count
        newEmojiCounts.remove(currentReactionEmojiCount);
      }
    }

    if (newReaction != null) {
      var reactionEmojiCount = newEmojiCounts.firstWhere((emojiCount) {
        return emojiCount.getEmojiId() == newReaction.getEmojiId();
      }, orElse: () {});

      if (reactionEmojiCount != null) {
        // Up existing count
        reactionEmojiCount.count += 1;
      } else {
        // Add new emoji count
        newEmojiCounts
            .add(ReactionsEmojiCount(emoji: newReaction.emoji, count: 1));
      }
    }

    this.reaction = newReaction;
    this._setReactionsEmojiCounts(
        ReactionsEmojiCountList(counts: newEmojiCounts));

    this.notifyUpdate();
  }

  void _setReactionsEmojiCounts(ReactionsEmojiCountList emojiCounts) {
    reactionsEmojiCounts = emojiCounts;
  }

  bool hasReaction() {
    return reaction != null;
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
        repliesCount: json['replies_count'],
        replies: parseCommentReplies(json['replies']),
        parentComment: parseParentComment(json['parent_comment']),
        isEdited: json['is_edited'],
        isReported: json['is_reported'],
        text: json['text'],
        reaction: parseReaction(json['reaction']),
        reactionsEmojiCounts:
            parseReactionsEmojiCounts(json['reactions_emoji_counts']));
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

  PostComment parseParentComment(Map commentData) {
    if (commentData == null) return null;
    return PostComment.fromJSON(commentData);
  }

  PostCommentList parseCommentReplies(List<dynamic> repliesData) {
    if (repliesData == null) return null;
    return PostCommentList.fromJson(repliesData);
  }

  PostCommentReaction parseReaction(Map postCommentReaction) {
    if (postCommentReaction == null) return null;
    return PostCommentReaction.fromJson(postCommentReaction);
  }

  ReactionsEmojiCountList parseReactionsEmojiCounts(List reactionsEmojiCounts) {
    if (reactionsEmojiCounts == null) return null;
    return ReactionsEmojiCountList.fromJson(reactionsEmojiCounts);
  }
}

enum PostCommentsSortType { asc, dec }
