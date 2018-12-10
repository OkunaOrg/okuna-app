import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/post_comment_list.dart';
import 'package:Openbook/models/post_image.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/models/post_reactions_emoji_count.dart';
import 'package:Openbook/models/post_reactions_emoji_count_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:dcache/dcache.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post {
  final int id;
  final int creatorId;
  final DateTime created;
  final User creator;

  PostReactionsEmojiCountList reactionsEmojiCounts;
  PostReaction reaction;
  int reactionsCount;
  int commentsCount;
  bool publicComments;
  bool publicReactions;
  String text;
  PostImage image;
  PostCommentList commentsList;

  Stream<Post> get updateSubject => _updateSubject.stream;
  final _updateSubject = ReplaySubject<Post>(maxSize: 1);

  factory Post.fromJson(Map<String, dynamic> json) {
    int postId = json['id'];

    Post post = getPostWithIdFromCache(postId);

    if (post != null) {
      post.updateFromJson(json);
      return post;
    }

    post = _makeFromJson(json);
    addToCache(post);
    return post;
  }

  static final SimpleCache<int, Post> cache =
      LruCache(storage: SimpleStorage(size: 100));

  static Post getPostWithIdFromCache(int postId) {
    return cache.get(postId);
  }

  static void addToCache(Post post) {
    cache.set(post.id, post);
  }

  static void clearCache() {
    cache.clear();
  }

  static Post _makeFromJson(json) {
    return Post(
        id: json['id'],
        creatorId: json['creator_id'],
        created: _parseCreated(json['created']),
        text: json['text'],
        reactionsCount: json['reactions_count'],
        commentsCount: json['comments_count'],
        publicComments: json['public_comments'],
        publicReactions: json['public_reactions'],
        creator: _parseCreator(json['creator']),
        image: _parseImage(json['image']),
        reaction: _parseReaction(json['reaction']),
        commentsList: _parseCommentList(json['comments']),
        reactionsEmojiCounts:
            _parseReactionsEmojiCounts(json['reactions_emoji_counts']));
  }

  static DateTime _parseCreated(String created) {
    return DateTime.parse(created).toLocal();
  }

  static PostImage _parseImage(Map image) {
    if (image == null) return null;
    return PostImage.fromJSON(image);
  }

  static User _parseCreator(Map creator) {
    if (creator == null) return null;
    return User.fromJson(creator);
  }

  static PostReaction _parseReaction(Map postReaction) {
    if (postReaction == null) return null;
    return PostReaction.fromJson(postReaction);
  }

  static PostReactionsEmojiCountList _parseReactionsEmojiCounts(
      List reactionsEmojiCounts) {
    if (reactionsEmojiCounts == null) return null;
    return PostReactionsEmojiCountList.fromJson(reactionsEmojiCounts);
  }

  static PostCommentList _parseCommentList(List commentList) {
    if (commentList == null) return null;
    return PostCommentList.fromJson(commentList);
  }

  Post(
      {this.id,
      this.created,
      this.text,
      this.creatorId,
      this.image,
      this.creator,
      this.reactionsCount,
      this.commentsCount,
      this.commentsList,
      this.reaction,
      this.reactionsEmojiCounts,
      this.publicComments,
      this.publicReactions}) {
    _updateSubject.add(this);
  }

  void updateFromJson(Map<String, dynamic> json) {
    reactionsEmojiCounts =
        _parseReactionsEmojiCounts(json['reactions_emoji_counts']);
    reaction = _parseReaction(json['reaction']);
    reactionsCount = json['reactions_count'];
    commentsCount = json['comments_count'];
    publicComments = json['public_comments'];
    publicReactions = json['public_reactions'];
    text = json['text'];
    image = _parseImage(json['image']);
    commentsList = _parseCommentList(json['comments']);

    _notifyUpdate();
  }

  void dispose() {
    _updateSubject.close();
  }

  bool hasReaction() {
    return reaction != null;
  }

  bool isReactionEmoji(Emoji emoji) {
    return hasReaction() && reaction.getEmojiId() == emoji.id;
  }

  bool hasPublicInteractions() {
    return publicReactions && publicComments;
  }

  bool hasImage() {
    return image != null;
  }

  bool hasText() {
    return text != null && text.length > 0;
  }

  bool hasComments() {
    return commentsList != null && commentsList.comments.length > 0;
  }

  bool hasCommentsCount() {
    return commentsCount != null && commentsCount > 0;
  }

  List<PostComment> getPostComments() {
    return commentsList.comments;
  }

  List<PostReactionsEmojiCount> getEmojiCounts() {
    return reactionsEmojiCounts.counts.toList();
  }

  String getCreatorUsername() {
    return creator.username;
  }

  int getCreatorId() {
    return creator.id;
  }

  String getCreatorAvatar() {
    return creator.profile.avatar;
  }

  String getImage() {
    return image.image;
  }

  String getText() {
    return text;
  }

  String getRelativeCreated() {
    return timeago.format(created);
  }

  void incrementCommentsCount() {
    this.commentsCount += 1;
    this._notifyUpdate();
  }

  void decreaseCommentsCount() {
    this.commentsCount -= 1;
    this._notifyUpdate();
  }

  void clearReaction() {
    this.setReaction(null);
  }

  void setReaction(PostReaction newReaction) {
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
            .add(PostReactionsEmojiCount(emoji: newReaction.emoji, count: 1));
      }
    }

    this.reaction = newReaction;
    this._setReactionsEmojiCounts(
        PostReactionsEmojiCountList(counts: newEmojiCounts));

    this._notifyUpdate();
  }

  void _setReactionsEmojiCounts(PostReactionsEmojiCountList emojiCounts) {
    reactionsEmojiCounts = emojiCounts;
  }

  void _notifyUpdate() {
    _updateSubject.add(this);
  }
}
