import 'package:Openbook/models/user_notifications_settings.dart';
import 'package:Openbook/services/push_notifications/push_notifications.dart';
import 'package:Openbook/widgets/fields/toggle_field.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/theming/divider.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBNotificationsSettingsPage extends StatefulWidget {
  @override
  OBNotificationsSettingsPageState createState() {
    return OBNotificationsSettingsPageState();
  }
}

class OBNotificationsSettingsPageState
    extends State<OBNotificationsSettingsPage> {
  UserService _userService;
  PushNotificationsService _pushNotificationsService;
  ToastService _toastService;

  bool _needsBootstrap;
  bool _bootstrapInProgress;

  UserNotificationsSettings currentNotificationsSettings;

  bool _pushNotifications;

  bool _postCommentNotifications;
  bool _postReactionNotifications;
  bool _followNotifications;
  bool _connectionRequestNotifications;
  bool _communityInviteNotifications;

  @override
  void initState() {
    super.initState();
    _pushNotifications = true;
    _needsBootstrap = true;
    _bootstrapInProgress = true;
    _pushNotifications = true;
    _postCommentNotifications = true;
    _postReactionNotifications = true;
    _followNotifications = true;
    _connectionRequestNotifications = true;
    _communityInviteNotifications = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _pushNotificationsService = openbookProvider.pushNotificationsService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(
          title: 'Notifications settings',
        ),
        child: OBPrimaryColorContainer(
          child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: _bootstrapInProgress
                  ? _buildBootstrapInProgressIndicator()
                  : _buildToggles()),
        ));
  }

  Widget _buildBootstrapInProgressIndicator() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: const EdgeInsets.all(20),
              child: const OBProgressIndicator(),
            )
          ],
        )
      ],
    );
  }

  Widget _buildToggles() {
    const Widget listItemSeparator = SizedBox(
      height: 10,
    );

    List<Widget> toggles = [
      OBToggleField(
        value: _pushNotifications,
        title: 'Notifications',
        subtitle: OBText('Be notified when something happens'),
        onChanged: _setPushNotifications,
        onTap: _togglePushNotifications,
        hasDivider: false,
      ),
    ];

    if (_pushNotifications) {
      toggles.addAll([
        OBDivider(),
        OBToggleField(
          value: _followNotifications,
          title: 'Follow',
          subtitle: OBText('Be notified when someone starts following you'),
          onChanged: _setFollowNotifications,
          onTap: _toggleFollowNotifications,
          hasDivider: false,
        ),
        listItemSeparator,
        OBToggleField(
          value: _connectionRequestNotifications,
          title: 'Connection request',
          subtitle:
              OBText('Be notified when someone wants to connect with you'),
          onChanged: _setConnectionRequestNotifications,
          onTap: _toggleConnectionRequestNotifications,
          hasDivider: false,
        ),
        listItemSeparator,
        OBToggleField(
          value: _postCommentNotifications,
          title: 'Post comment',
          subtitle:
              OBText('Be notified when someone comments on one of your posts or one you also commented.'),
          onChanged: _setPostCommentNotifications,
          onTap: _togglePostCommentNotifications,
          hasDivider: false,
        ),
        listItemSeparator,
        OBToggleField(
          value: _postReactionNotifications,
          title: 'Post reaction',
          subtitle:
              OBText('Be notified when someone reacts on one of your posts'),
          onChanged: _setPostReactionNotifications,
          onTap: _togglePostReactionNotifications,
          hasDivider: false,
        ),
        OBToggleField(
          value: _communityInviteNotifications,
          title: 'Community invite',
          subtitle: OBText(
              'Be notified when someone invites you to join a community'),
          onChanged: _setCommunityInviteNotifications,
          onTap: _toggleCommunityInviteNotifications,
          hasDivider: false,
        )
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40),
            child: Column(children: toggles)),
      ],
    );
  }

  void _togglePushNotifications() {
    _setPushNotifications(!_pushNotifications);
  }

  Future _setPushNotifications(bool pushNotifications) async {
    setState(() {
      _pushNotifications = pushNotifications;
    });

    return pushNotifications
        ? _pushNotificationsService.enablePushNotifications()
        : _pushNotificationsService.disablePushNotifications();
  }

  void _toggleConnectionRequestNotifications() {
    _setConnectionRequestNotifications(!_connectionRequestNotifications);
  }

  void _setConnectionRequestNotifications(bool newValue) {
    setState(() {
      _connectionRequestNotifications = newValue;
    });

    _submitNotificationsSettings();
  }

  void _toggleFollowNotifications() {
    _setFollowNotifications(!_followNotifications);
  }

  void _setFollowNotifications(bool newValue) {
    setState(() {
      _followNotifications = newValue;
    });

    _submitNotificationsSettings();
  }

  void _toggleCommunityInviteNotifications() {
    _setCommunityInviteNotifications(!_communityInviteNotifications);
  }

  void _setCommunityInviteNotifications(bool newValue) {
    setState(() {
      _communityInviteNotifications = newValue;
    });

    _submitNotificationsSettings();
  }

  void _togglePostCommentNotifications() {
    _setPostCommentNotifications(!_postCommentNotifications);
  }

  void _setPostCommentNotifications(bool newValue) {
    setState(() {
      _postCommentNotifications = newValue;
    });

    _submitNotificationsSettings();
  }

  void _togglePostReactionNotifications() {
    _setPostReactionNotifications(!_postReactionNotifications);
  }

  void _setPostReactionNotifications(bool newValue) {
    setState(() {
      _postReactionNotifications = newValue;
    });

    _submitNotificationsSettings();
  }

  void _bootstrap() async {
    await Future.wait([
      _refreshNotificationsSettings(),
      _refreshPushNotifications(),
    ]);
    _setBootstrapInProgress(false);
  }

  Future _refreshPushNotifications() async {
    bool isSubscribedToPushNotifications =
        await _pushNotificationsService.isSubscribedToPushNotifications();

    setState(() {
      _pushNotifications = isSubscribedToPushNotifications;
    });
  }

  Future _refreshNotificationsSettings() async {
    try {
      UserNotificationsSettings notificationsSettings =
          await _userService.getAuthenticatedUserNotificationsSettings();

      _setNotificationsSettings(notificationsSettings);
    } catch (error) {
      _onError(error);
    }
  }

  void _submitNotificationsSettings() {
    try {
      _userService.updateAuthenticatedUserNotificationsSettings(
          followNotifications: _followNotifications,
          postCommentNotifications: _postCommentNotifications,
          postReactionNotifications: _postReactionNotifications,
          connectionRequestNotifications: _connectionRequestNotifications,
          communityInviteNotifications: _communityInviteNotifications);
    } catch (error) {
      _onError(error);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }

  void _setNotificationsSettings(
      UserNotificationsSettings notificationSettings) {
    setState(() {
      _connectionRequestNotifications =
          notificationSettings.connectionRequestNotifications;
      _postCommentNotifications = notificationSettings.postCommentNotifications;
      _postReactionNotifications =
          notificationSettings.postReactionNotifications;
      _followNotifications = notificationSettings.followNotifications;
      _communityInviteNotifications =
          notificationSettings.communityInviteNotifications;
    });
  }

  void _setBootstrapInProgress(bool bootstrapInProgress) {
    setState(() {
      _bootstrapInProgress = bootstrapInProgress;
    });
  }
}
