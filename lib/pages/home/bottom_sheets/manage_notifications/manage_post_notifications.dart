import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_notifications_subscription.dart';
import 'package:Okuna/pages/home/bottom_sheets/manage_notifications/widgets/manage_notifications.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

import '../rounded_bottom_sheet.dart';

class OBManagePostNotificationsBottomSheet extends StatefulWidget {
  final Post post;
  final OnNotificationSettingsSave onNotificationSettingsSave;

  OBManagePostNotificationsBottomSheet(
      {Key key, this.onNotificationSettingsSave, this.post})
      : super(key: key);

  @override
  OBManagePostNotificationsBottomSheetState createState() {
    return OBManagePostNotificationsBottomSheetState();
  }
}

class OBManagePostNotificationsBottomSheetState
    extends State<OBManagePostNotificationsBottomSheet> {
  UserService _userService;
  LocalizationService _localizationService;
  ToastService _toastService;
  PostNotificationsSubscription _postNotificationsSubscription;
  CancelableOperation _saveOperation;
  CancelableOperation _muteOperation;

  @override
  void initState() {
    super.initState();
    _postNotificationsSubscription = widget.post.postNotificationsSubscription;
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
            isMuted: widget.post.isMuted,
            mutePostLabelText:
                _localizationService.post__mute_post_notifications_text,
            unmutePostLabelText:
                _localizationService.post__unmute_post_notifications_text,
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
      PostNotificationSetting(
          key: PostNotificationSetting.COMMENT_NOTIFICATIONS,
          value: _postNotificationsSubscription?.commentNotifications ?? false,
          isDisabled: widget.post.isMuted,
          localizedTitle:
              _localizationService.post__manage_notifications_comments_title,
          localizedDesc:
              _localizationService.post__manage_notifications_comments_desc),
      PostNotificationSetting(
          key: PostNotificationSetting.REPLY_NOTIFICATIONS,
          value: _postNotificationsSubscription?.replyNotifications ?? false,
          isDisabled: widget.post.isMuted,
          localizedTitle:
              _localizationService.post__manage_notifications_replies_title,
          localizedDesc:
              _localizationService.post__manage_notifications_replies_desc),
    ];
    // add post reaction setting if user is creator
    if (widget.post.creator == _userService.getLoggedInUser()) {
      _notificationSettings.insert(
          0,
          PostNotificationSetting(
              key: PostNotificationSetting.REACTION_NOTIFICATIONS,
              value: _postNotificationsSubscription?.reactionNotifications ??
                  false,
              isDisabled: widget.post.isMuted,
              localizedTitle: _localizationService
                  .post__manage_notifications_reactions_title,
              localizedDesc: _localizationService
                  .post__manage_notifications_reactions_desc));
    }
    return _notificationSettings;
  }

  void _onWantsToToggleMute() async {
    try {
      if (widget.post.isMuted) {
        _muteOperation = CancelableOperation.fromFuture(
            _userService.unmutePost(widget.post));
        await _muteOperation.value;
        _toastService.success(
            message: _localizationService
                .post__manage_notifications_successfully_unmuted,
            context: context);
      } else {
        _muteOperation =
            CancelableOperation.fromFuture(_userService.mutePost(widget.post));
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
      if (widget.post.postNotificationsSubscription == null) {
        _saveOperation = CancelableOperation.fromFuture(
            _createUserPostNotificationsSubscription(notificationSettingsMap));
        await _saveOperation.value;
      } else {
        _saveOperation = CancelableOperation.fromFuture(
            _updateUserPostNotificationsSubscription(notificationSettingsMap));
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

  Future<Post> _createUserPostNotificationsSubscription(
      Map<String, dynamic> notificationSettingsMap) {
    return _userService.createPostNotificationsSubscription(
      post: widget.post,
      commentNotifications: notificationSettingsMap[
          PostNotificationSetting.COMMENT_NOTIFICATIONS],
      reactionNotifications: notificationSettingsMap[
          PostNotificationSetting.REACTION_NOTIFICATIONS],
      replyNotifications:
          notificationSettingsMap[PostNotificationSetting.REPLY_NOTIFICATIONS],
    );
  }

  Future<Post> _updateUserPostNotificationsSubscription(
      Map<String, dynamic> notificationSettingsMap) {
    return _userService.updatePostNotificationsSubscription(
      post: widget.post,
      commentNotifications: notificationSettingsMap[
          PostNotificationSetting.COMMENT_NOTIFICATIONS],
      reactionNotifications: notificationSettingsMap[
          PostNotificationSetting.REACTION_NOTIFICATIONS],
      replyNotifications:
          notificationSettingsMap[PostNotificationSetting.REPLY_NOTIFICATIONS],
    );
  }
}

class PostNotificationSetting extends NotificationSetting {
  String key;
  bool value;
  bool isDisabled;
  String localizedTitle;
  String localizedDesc;

  static const COMMENT_NOTIFICATIONS = 'commentNotifications';
  static const REPLY_NOTIFICATIONS = 'replyNotifications';
  static const REACTION_NOTIFICATIONS = 'reactionNotifications';
  List<String> _notificationTypes = [
    COMMENT_NOTIFICATIONS,
    REPLY_NOTIFICATIONS,
    REACTION_NOTIFICATIONS
  ];

  PostNotificationSetting(
      {this.key,
      this.value,
      this.isDisabled,
      this.localizedTitle,
      this.localizedDesc}) {
    if (!_notificationTypes.contains(this.key))
      throw PostNotificationSettingKeyError(this.key);
  }
}

class PostNotificationSettingKeyError extends Error {
  final String message;
  PostNotificationSettingKeyError(this.message);
  String toString() =>
      "Unsupported key for post notification setting: $message";
}

typedef void OnNotificationSettingsSave();
