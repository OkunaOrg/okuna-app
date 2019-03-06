import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/post_comment_list.dart';
import 'package:Openbook/models/post_image.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/models/post_reactions_emoji_count.dart';
import 'package:Openbook/models/post_reactions_emoji_count_list.dart';
import 'package:Openbook/models/updatable_model.dart';
import 'package:Openbook/models/post_video.dart';
import 'package:Openbook/models/user.dart';
import 'package:dcache/dcache.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends UpdatableModel<Post> {
  final int id;
  final String uuid;
  final int creatorId;
  final DateTime created;
  final User creator;
  CirclesList circles;

  PostReactionsEmojiCountList reactionsEmojiCounts;
  PostReaction reaction;
  int reactionsCount;
  int commentsCount;
  bool publicComments;
  bool publicReactions;
  String text;
  PostImage image;
  PostVideo video;
  PostCommentList commentsList;
  Community community;

  bool isMuted;

  static final factory = PostFactory();

  factory Post.fromJson(Map<String, dynamic> json) {
    return factory.fromJson(json);
  }

  static void clearCache() {
    factory.clearCache();
  }

  Post(
      {this.id,
      this.uuid,
      this.created,
      this.text,
      this.creatorId,
      this.image,
      this.video,
      this.creator,
      this.reactionsCount,
      this.commentsCount,
      this.commentsList,
      this.reaction,
      this.reactionsEmojiCounts,
      this.publicComments,
      this.circles,
      this.community,
      this.publicReactions,
      this.isMuted})
      : super();

  void updateFromJson(Map json) {
    if (json.containsKey('reactions_emoji_counts'))
      reactionsEmojiCounts =
          factory.parseReactionsEmojiCounts(json['reactions_emoji_counts']);
    if (json.containsKey('reaction'))
      reaction = factory.parseReaction(json['reaction']);

    if (json.containsKey('reactions_count'))
      reactionsCount = json['reactions_count'];

    if (json.containsKey('comments_count'))
      commentsCount = json['comments_count'];

    if (json.containsKey('public_comments'))
      publicComments = json['public_comments'];

    if (json.containsKey('public_reactions'))
      publicReactions = json['public_reactions'];

    if (json.containsKey('text')) text = json['text'];

    if (json.containsKey('is_muted')) isMuted = json['is_muted'];

    if (json.containsKey('image')) image = factory.parseImage(json['image']);

    if (json.containsKey('video')) video = factory.parseVideo(json['video']);

    if (json.containsKey('community'))
      community = factory.parseCommunity(json['community']);

    if (json.containsKey('comments'))
      commentsList = factory.parseCommentList(json['comments']);

    if (json.containsKey('circles'))
      circles = factory.parseCircles(json['circles']);
  }

  bool hasReaction() {
    return reaction != null;
  }

  bool hasCommunity() {
    return community != null;
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

  bool isCommunityPost() {
    return community != null;
  }

  bool hasVideo() {
    return video != null;
  }

  bool hasText() {
    return text != null && text.length > 0;
  }

  bool hasComments() {
    return commentsList != null && commentsList.comments.length > 0;
  }

  bool hasCircles() {
    return circles != null && circles.circles.length > 0;
  }

  bool hasCommentsCount() {
    return commentsCount != null && commentsCount > 0;
  }

  List<PostComment> getPostComments() {
    return commentsList.comments;
  }

  List<Circle> getPostCircles() {
    return circles.circles;
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

  double getImageHeight() {
    return image.height;
  }

  double getImageWidth() {
    return image.width;
  }

  String getVideo() {
    return video.video;
  }

  String getText() {
    return text;
  }

  String getRelativeCreated() {
    return timeago.format(created);
  }

  void incrementCommentsCount() {
    this.commentsCount += 1;
    this.notifyUpdate();
  }

  void decreaseCommentsCount() {
    this.commentsCount -= 1;
    this.notifyUpdate();
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

    this.notifyUpdate();
  }

  void _setReactionsEmojiCounts(PostReactionsEmojiCountList emojiCounts) {
    reactionsEmojiCounts = emojiCounts;
  }
}

class PostFactory extends UpdatableModelFactory<Post> {
  @override
  SimpleCache<int, Post> cache =
      SimpleCache(storage: UpdatableModelSimpleStorage(size: 100));

  @override
  Post makeFromJson(Map json) {
    return Post(
        id: json['id'],
        uuid: json['uuid'],
        creatorId: json['creator_id'],
        created: parseCreated(json['created']),
        text: json['text'],
        circles: parseCircles(json['circles']),
        reactionsCount: json['reactions_count'],
        commentsCount: json['comments_count'],
        isMuted: json['is_muted'],
        publicComments: json['public_comments'],
        publicReactions: json['public_reactions'],
        creator: parseCreator(json['creator']),
        image: parseImage(json['image']),
        video: parseVideo(json['video']),
        reaction: parseReaction(json['reaction']),
        community: parseCommunity(json['community']),
        commentsList: parseCommentList(json['comments']),
        reactionsEmojiCounts:
            parseReactionsEmojiCounts(json['reactions_emoji_counts']));
  }

  User parseUser(Map userData) {
    if (userData == null) return null;
    return User.fromJson(userData);
  }

  DateTime parseCreated(String created) {
    if (created == null) return null;
    return DateTime.parse(created).toLocal();
  }

  PostImage parseImage(Map image) {
    if (image == null) return null;
    return PostImage.fromJSON(image);
  }

  PostVideo parseVideo(Map video) {
    if (video == null) return null;
    return PostVideo.fromJSON(video);
  }

  User parseCreator(Map creator) {
    if (creator == null) return null;
    return User.fromJson(creator);
  }

  PostReaction parseReaction(Map postReaction) {
    if (postReaction == null) return null;
    return PostReaction.fromJson(postReaction);
  }

  Community parseCommunity(Map communityData) {
    if (communityData == null) return null;
    return Community.fromJSON(communityData);
  }

  PostReactionsEmojiCountList parseReactionsEmojiCounts(
      List reactionsEmojiCounts) {
    if (reactionsEmojiCounts == null) return null;
    return PostReactionsEmojiCountList.fromJson(reactionsEmojiCounts);
  }

  PostCommentList parseCommentList(List commentList) {
    if (commentList == null) return null;
    return PostCommentList.fromJson(commentList);
  }

  CirclesList parseCircles(List circlesData) {
    if (circlesData == null) return null;
    return CirclesList.fromJson(circlesData);
  }
}
