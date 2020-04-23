import 'package:Okuna/models/user_notifications_settings.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/push_notifications/push_notifications.dart';
import 'package:Okuna/widgets/fields/toggle_field.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/progress_indicator.dart';
import 'package:Okuna/widgets/theming/divider.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/text.dart';
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
  LocalizationService _localizationService;

  bool _needsBootstrap;
  bool _bootstrapInProgress;

  UserNotificationsSettings currentNotificationsSettings;

  bool _pushNotifications;

  bool _postNotifications;
  bool _followNotifications;
  bool _connectionRequestNotifications;
  bool _communityInviteNotifications;
  bool _communityNewPostNotifications;
  bool _userNewPostNotifications;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _bootstrapInProgress = true;
    _postNotifications = true;
    _followNotifications = true;
    _connectionRequestNotifications = true;
    _communityInviteNotifications = true;
    _communityNewPostNotifications = true;
    _userNewPostNotifications = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _localizationService = openbookProvider.localizationService;
      _pushNotificationsService = openbookProvider.pushNotificationsService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(
          title: _localizationService.trans('notifications__settings_title'),
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
        key: Key('All'),
        value: _pushNotifications,
        title: _localizationService.trans('notifications__general_title'),
        subtitle:
            OBText(_localizationService.trans('notifications__general_desc')),
        onChanged: _setPushNotifications,
        onTap: _togglePushNotifications,
        hasDivider: false,
      ),
    ];

    if (_pushNotifications) {
      toggles.addAll([
        OBDivider(),
        OBToggleField(
          key: Key('Follow'),
          value: _followNotifications,
          title: _localizationService.trans('notifications__follow_title'),
          subtitle:
              OBText(_localizationService.trans('notifications__follow_desc')),
          onChanged: _setFollowNotifications,
          onTap: _toggleFollowNotifications,
          hasDivider: false,
        ),
        listItemSeparator,
        OBToggleField(
          key: Key('Connection request'),
          value: _connectionRequestNotifications,
          title: _localizationService.trans('notifications__connection_title'),
          subtitle: OBText(
              _localizationService.trans('notifications__connection_desc')),
          onChanged: _setConnectionRequestNotifications,
          onTap: _toggleConnectionRequestNotifications,
          hasDivider: false,
        ),
        listItemSeparator,
        OBToggleField(
          key: Key('Post notifications'),
          value: _postNotifications,
          title: _localizationService.notifications__post_notifications_title,
          subtitle: OBText(
            _localizationService.notifications__post_notifications_desc,
          ),
          onChanged: _setPostNotifications,
          onTap: _togglePostNotifications,
          hasDivider: false,
        ),
        OBToggleField(
          key: Key('Community invite'),
          value: _communityInviteNotifications,
          title: _localizationService
              .trans('notifications__community_invite_title'),
          subtitle: OBText(_localizationService
              .trans('notifications__community_invite_desc')),
          onChanged: _setCommunityInviteNotifications,
          onTap: _toggleCommunityInviteNotifications,
          hasDivider: false,
        ),
        OBToggleField(
          key: Key('Community new post'),
          value: _communityNewPostNotifications,
          title: _localizationService.notifications__community_new_post_title,
          subtitle: OBText(
              _localizationService.notifications__community_new_post_desc),
          onChanged: _setCommunityNewPostNotifications,
          onTap: _toggleCommunityNewPostNotifications,
          hasDivider: false,
        ),
        OBToggleField(
          key: Key('User new post'),
          value: _userNewPostNotifications,
          title: _localizationService.notifications__user_new_post_title,
          subtitle:
              OBText(_localizationService.notifications__user_new_post_desc),
          onChanged: _setUserNewPostNotifications,
          onTap: _toggleUserNewPostNotifications,
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
        ? _pushNotificationsService.subscribeToPushNotifications()
        : _pushNotificationsService.unsubscribeFromPushNotifications();
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

  void _toggleCommunityNewPostNotifications() {
    _setCommunityNewPostNotifications(!_communityNewPostNotifications);
  }

  void _setCommunityNewPostNotifications(bool newValue) {
    setState(() {
      _communityNewPostNotifications = newValue;
    });

    _submitNotificationsSettings();
  }

  void _toggleUserNewPostNotifications() {
    _setUserNewPostNotifications(!_userNewPostNotifications);
  }

  void _setUserNewPostNotifications(bool newValue) {
    setState(() {
      _userNewPostNotifications = newValue;
    });

    _submitNotificationsSettings();
  }

  void _togglePostNotifications() {
    _setPostNotifications(!_postNotifications);
  }

  void _setPostNotifications(bool newValue) {
    setState(() {
      _postNotifications = newValue;
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
          postNotifications: _postNotifications,
          connectionRequestNotifications: _connectionRequestNotifications,
          communityNewPostNotifications: _communityNewPostNotifications,
          userNewPostNotifications: _userNewPostNotifications,
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
      _toastService.error(
          message: _localizationService.trans('error__unknown_error'),
          context: context);
      throw error;
    }
  }

  void _setNotificationsSettings(
      UserNotificationsSettings notificationSettings) {
    setState(() {
      _connectionRequestNotifications =
          notificationSettings.connectionRequestNotifications;
      _postNotifications = notificationSettings.postNotifications;
      _followNotifications = notificationSettings.followNotifications;
      _communityInviteNotifications =
          notificationSettings.communityInviteNotifications;
      _communityNewPostNotifications =
          notificationSettings.communityNewPostNotifications;
      _userNewPostNotifications = notificationSettings.userNewPostNotifications;
    });
  }

  void _setBootstrapInProgress(bool bootstrapInProgress) {
    setState(() {
      _bootstrapInProgress = bootstrapInProgress;
    });
  }
}
