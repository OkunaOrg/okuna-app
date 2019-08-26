import 'package:Okuna/models/circle.dart';
import 'package:Okuna/models/circles_list.dart';
import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/emoji.dart';
import 'package:Okuna/models/post_comment.dart';
import 'package:Okuna/models/post_comment_list.dart';
import 'package:Okuna/models/post_image.dart';
import 'package:Okuna/models/post_links_list.dart';
import 'package:Okuna/models/post_media.dart';
import 'package:Okuna/models/post_media_list.dart';
import 'package:Okuna/models/post_preview_link_data.dart';
import 'package:Okuna/models/post_reaction.dart';
import 'package:Okuna/models/post_video.dart';
import 'package:Okuna/models/reactions_emoji_count.dart';
import 'package:Okuna/models/reactions_emoji_count_list.dart';
import 'package:Okuna/models/updatable_model.dart';
import 'package:Okuna/models/user.dart';
import 'package:dcache/dcache.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'language.dart';

class Post extends UpdatableModel<Post> {
  final int id;
  final String uuid;
  final int creatorId;
  DateTime created;
  User creator;
  CirclesList circles;

  ReactionsEmojiCountList reactionsEmojiCounts;
  PostReaction reaction;
  int reactionsCount;
  int commentsCount;
  int mediaHeight;
  int mediaWidth;
  bool areCommentsEnabled;
  bool publicReactions;
  String text;
  Language language;

  // Deprecation incoming
  PostImage image;

  PostMediaList media;
  PostLinksList postLinksList;
  PostPreviewLinkData previewLinkQueryData;
  PostCommentList commentsList;
  Community community;

  bool isMuted;
  bool isEncircled;
  bool isEdited;
  bool isClosed;
  bool isReported;

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
      this.media,
      this.postLinksList,
      this.creator,
      this.language,
      this.reactionsCount,
      this.commentsCount,
      this.mediaHeight,
      this.mediaWidth,
      this.commentsList,
      this.reaction,
      this.reactionsEmojiCounts,
      this.areCommentsEnabled,
      this.circles,
      this.community,
      this.publicReactions,
      this.isMuted,
      this.isEncircled,
      this.isClosed,
      this.isReported,
      this.isEdited})
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

    if (json.containsKey('comments_enabled'))
      areCommentsEnabled = json['comments_enabled'];

    if (json.containsKey('public_reactions'))
      publicReactions = json['public_reactions'];

    if (json.containsKey('media_height')) mediaHeight = json['media_height'];

    if (json.containsKey('media_width')) mediaWidth = json['media_width'];

    if (json.containsKey('language')) {
      language = factory.parseLanguage(json['language']);
    }

    if (json.containsKey('text')) {
      text = json['text'];
      previewLinkQueryData = null;
    }

    if (json.containsKey('is_muted')) isMuted = json['is_muted'];

    if (json.containsKey('is_encircled')) isEncircled = json['is_encircled'];

    if (json.containsKey('is_edited')) isEdited = json['is_edited'];

    if (json.containsKey('is_closed')) isClosed = json['is_closed'];

    if (json.containsKey('is_reported')) isReported = json['is_reported'];

    if (json.containsKey('image')) image = factory.parseImage(json['image']);

    if (json.containsKey('media')) media = factory.parseMedia(json['media']);

    if (json.containsKey('post_links'))
      postLinksList = factory.parsePostLinksList(json['post_links']);

    if (json.containsKey('community'))
      community = factory.parseCommunity(json['community']);

    if (json.containsKey('creator'))
      creator = factory.parseUser(json['creator']);

    if (json.containsKey('created'))
      created = factory.parseCreated(json['created']);

    if (json.containsKey('comments'))
      commentsList = factory.parseCommentList(json['comments']);

    if (json.containsKey('circles'))
      circles = factory.parseCircles(json['circles']);
  }

  void updatePreviewDataFromJson(Map json) {
    previewLinkQueryData = PostPreviewLinkData();
    if (json.containsKey('title')) previewLinkQueryData.title = json['title'];
    if (json.containsKey('description'))
      previewLinkQueryData.description = json['description'];
    if (json.containsKey('image_url'))
      previewLinkQueryData.imageUrl = json['image_url'];
    if (json.containsKey('favicon_url'))
      previewLinkQueryData.faviconUrl = json['favicon_url'];
    if (json.containsKey('domain_url'))
      previewLinkQueryData.domainUrl = json['domain_url'];
    notifyUpdate();
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
    return publicReactions && areCommentsEnabled;
  }

  bool isCommunityPost() {
    return community != null;
  }

  bool hasMedia() {
    return media != null;
  }

  bool hasPreviewLink() {
    return postLinksList != null && postLinksList.links.length > 0;
  }

  bool hasPreviewQueryData() {
    return previewLinkQueryData != null;
  }

  bool hasText() {
    return text != null && text.length > 0;
  }

  bool hasLanguage() {
    return language != null;
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

  bool isEncircledPost() {
    return isEncircled || false;
  }

  List<PostComment> getPostComments() {
    return commentsList.comments;
  }

  List<Circle> getPostCircles() {
    return circles.circles;
  }

  List<ReactionsEmojiCount> getEmojiCounts() {
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

  List<PostMedia> getMedia() {
    return media.postMedia;
  }

  PostMedia getFirstMedia() {
    return media.postMedia.first;
  }

  String getMediaPreviewImage() {
    PostMedia firstMedia = getFirstMedia();
    String mediaPreviewImage;
    switch (firstMedia.contentObject.runtimeType) {
      case PostVideo:
        mediaPreviewImage = firstMedia.contentObject.thumbnail;
        break;
      case PostImage:
        mediaPreviewImage = firstMedia.contentObject.image;
        break;
      default:
    }

    return mediaPreviewImage;
  }

  String getPreviewLink() {
    return postLinksList.links[0].link;
  }

  Language getLanguage() {
    return language;
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
            .add(ReactionsEmojiCount(emoji: newReaction.emoji, count: 1));
      }
    }

    this.reaction = newReaction;
    this._setReactionsEmojiCounts(
        ReactionsEmojiCountList(counts: newEmojiCounts));

    this.notifyUpdate();
  }

  void setIsReported(isReported) {
    this.isReported = isReported;
    notifyUpdate();
  }

  void _setReactionsEmojiCounts(ReactionsEmojiCountList emojiCounts) {
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
        language: parseLanguage(json['language']),
        circles: parseCircles(json['circles']),
        reactionsCount: json['reactions_count'],
        commentsCount: json['comments_count'],
        mediaHeight: json['media_height'],
        mediaWidth: json['media_width'],
        isMuted: json['is_muted'],
        isReported: json['is_reported'],
        areCommentsEnabled: json['comments_enabled'],
        publicReactions: json['public_reactions'],
        creator: parseCreator(json['creator']),
        image: parseImage(json['image']),
        media: parseMedia(json['media']),
        postLinksList: parsePostLinksList(json['post_links']),
        reaction: parseReaction(json['reaction']),
        community: parseCommunity(json['community']),
        commentsList: parseCommentList(json['comments']),
        isEncircled: json['is_encircled'],
        isEdited: json['is_edited'],
        isClosed: json['is_closed'],
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

  PostMediaList parseMedia(List mediaRawData) {
    if (mediaRawData == null) return null;
    return PostMediaList.fromJson(mediaRawData);
  }

  PostLinksList parsePostLinksList(List linksList) {
    if (linksList == null) return null;
    return PostLinksList.fromJson(linksList);
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

  ReactionsEmojiCountList parseReactionsEmojiCounts(List reactionsEmojiCounts) {
    if (reactionsEmojiCounts == null) return null;
    return ReactionsEmojiCountList.fromJson(reactionsEmojiCounts);
  }

  PostCommentList parseCommentList(List commentList) {
    if (commentList == null) return null;
    return PostCommentList.fromJson(commentList);
  }

  CirclesList parseCircles(List circlesData) {
    if (circlesData == null) return null;
    return CirclesList.fromJson(circlesData);
  }

  Language parseLanguage(Map languageData) {
    if (languageData == null) return null;
    return Language.fromJson(languageData);
  }
}
