import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_comment.dart';
import 'package:Okuna/models/post_comment_notifications_subscription.dart';
import 'package:Okuna/pages/home/bottom_sheets/manage_notifications/widgets/manage_notifications.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

import '../rounded_bottom_sheet.dart';

class OBManagePostCommentNotificationsBottomSheet extends StatefulWidget {
  final Post post;
  final PostComment postComment;
  final OnNotificationSettingsSave onNotificationSettingsSave;

  OBManagePostCommentNotificationsBottomSheet(
      {Key key,
      @required this.post,
      @required this.postComment,
      this.onNotificationSettingsSave})
      : super(key: key);

  @override
  OBManagePostCommentNotificationsBottomSheetState createState() {
    return OBManagePostCommentNotificationsBottomSheetState();
  }
}

class OBManagePostCommentNotificationsBottomSheetState
    extends State<OBManagePostCommentNotificationsBottomSheet> {
  UserService _userService;
  LocalizationService _localizationService;
  ToastService _toastService;
  PostCommentNotificationsSubscription postCommentNotificationsSubscription;
  CancelableOperation _saveOperation;
  CancelableOperation _muteOperation;

  @override
  void initState() {
    super.initState();
    postCommentNotificationsSubscription =
        widget.postComment.postCommentNotificationsSubscription;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _localizationService = openbookProvider.localizationService;
    _toastService = openbookProvider.toastService;

    return OBRoundedBottomSheet(
        child: OBManageNotifications(
            notificationSettings: _getNotificationSettingsList(),
            onWantsToSaveSettings: _onWantsToSaveSettings,
            mutePostLabelText:
                _localizationService.post__mute_post_comment_notifications_text,
            unmutePostLabelText: _localizationService
                .post__unmute_post_comment_notifications_text,
            isMuted: widget.postComment.isMuted,
            onWantsToToggleMute: _onWantsToToggleMute));
  }

  @override
  void dispose() {
    super.dispose();
    if (_saveOperation != null) _saveOperation.cancel();
    if (_muteOperation != null) _muteOperation.cancel();
  }

  List<NotificationSetting> _getNotificationSettingsList() {
    List<NotificationSetting> _notificationSettings = [
      PostCommentNotificationSetting(
          key: PostCommentNotificationSetting.REPLY_NOTIFICATIONS,
          value:
              postCommentNotificationsSubscription?.replyNotifications ?? false,
          isDisabled: widget.postComment.isMuted,
          localizedTitle:
              _localizationService.post__manage_notifications_replies_title,
          localizedDesc: _localizationService
              .post__manage_notifications_replies_post_comment_desc),
    ];
    // add post reaction setting if user is creator
    if (widget.postComment.commenter == _userService.getLoggedInUser()) {
      _notificationSettings.insert(
          0,
          PostCommentNotificationSetting(
              key: PostCommentNotificationSetting.REACTION_NOTIFICATIONS,
              value:
                  postCommentNotificationsSubscription?.reactionNotifications ??
                      false,
              isDisabled: widget.postComment.isMuted,
              localizedTitle: _localizationService
                  .post__manage_notifications_reactions_title,
              localizedDesc: _localizationService
                  .post__manage_notifications_reactions_post_comment_desc));
    }
    return _notificationSettings;
  }

  void _onWantsToToggleMute() async {
    try {
      if (widget.postComment.isMuted) {
        _muteOperation = CancelableOperation.fromFuture(
            _userService.unmutePostComment(
                post: widget.post, postComment: widget.postComment));
        await _muteOperation.value;
        _toastService.success(
            message: _localizationService
                .post__manage_notifications_successfully_unmuted,
            context: context);
      } else {
        _muteOperation = CancelableOperation.fromFuture(
            _userService.mutePostComment(
                post: widget.post, postComment: widget.postComment));
        await _muteOperation.value;
        _toastService.success(
            message: _localizationService
                .post__manage_notifications_successfully_muted,
            context: context);
      }
    } catch (error) {
      _onError(error);
    }
  }

  void _onWantsToSaveSettings(
      Map<String, dynamic> notificationSettingsMap) async {
    try {
      if (widget.postComment.postCommentNotificationsSubscription == null) {
        _saveOperation = CancelableOperation.fromFuture(
            createUserPostCommentNotificationsSubscription(
                notificationSettingsMap));
        await _saveOperation.value;
      } else {
        _saveOperation = CancelableOperation.fromFuture(
            _updateUserPostCommentNotificationsSubscription(
                notificationSettingsMap));
        await _saveOperation.value;
      }
    } catch (error) {
      _onError(error);
    }
    if (widget.onNotificationSettingsSave != null)
      widget.onNotificationSettingsSave();
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(
          message: _localizationService.trans('error__unknown_error'),
          context: context);
      throw error;
    }
  }

  Future<Post> createUserPostCommentNotificationsSubscription(
      Map<String, dynamic> notificationSettingsMap) {
    return _userService.createPostCommentNotificationsSubscription(
      post: widget.post,
      postComment: widget.postComment,
      reactionNotifications: notificationSettingsMap[
          PostCommentNotificationSetting.REACTION_NOTIFICATIONS],
      replyNotifications: notificationSettingsMap[
          PostCommentNotificationSetting.REPLY_NOTIFICATIONS],
    );
  }

  Future<Post> _updateUserPostCommentNotificationsSubscription(
      Map<String, dynamic> notificationSettingsMap) {
    return _userService.updatePostCommentNotificationsSubscription(
      post: widget.post,
      postComment: widget.postComment,
      reactionNotifications: notificationSettingsMap[
          PostCommentNotificationSetting.REACTION_NOTIFICATIONS],
      replyNotifications: notificationSettingsMap[
          PostCommentNotificationSetting.REPLY_NOTIFICATIONS],
    );
  }
}

class PostCommentNotificationSetting extends NotificationSetting {
  String key;
  bool value;
  bool isDisabled;
  String localizedTitle;
  String localizedDesc;

  static const REPLY_NOTIFICATIONS = 'replyNotifications';
  static const REACTION_NOTIFICATIONS = 'reactionNotifications';
  List<String> _notificationTypes = [
    REPLY_NOTIFICATIONS,
    REACTION_NOTIFICATIONS
  ];

  PostCommentNotificationSetting(
      {this.key,
      this.value,
      this.isDisabled,
      this.localizedTitle,
      this.localizedDesc}) {
    if (!_notificationTypes.contains(this.key))
      throw PostCommentNotificationSettingKeyError(this.key);
  }
}

class PostCommentNotificationSettingKeyError extends Error {
  final String message;
  PostCommentNotificationSettingKeyError(this.message);
  String toString() =>
      "Unsupported key for post comment notification setting: $message";
}

typedef void OnNotificationSettingsSave();
