import 'dart:io';

import 'package:Openbook/models/category.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/user_notifications_settings.dart';
import 'package:Openbook/services/bottom_sheet.dart';
import 'package:Openbook/services/image_picker.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/avatars/letter_avatar.dart';
import 'package:Openbook/widgets/cover.dart';
import 'package:Openbook/widgets/fields/categories_field.dart';
import 'package:Openbook/widgets/fields/color_field.dart';
import 'package:Openbook/widgets/fields/community_type_field.dart';
import 'package:Openbook/widgets/fields/toggle_field.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/colored_nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/fields/text_form_field.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/theming/divider.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBNotificationsSettingsPage extends StatefulWidget {
  @override
  OBNotificationsSettingsPageState createState() {
    return OBNotificationsSettingsPageState();
  }
}

class OBNotificationsSettingsPageState
    extends State<OBNotificationsSettingsPage> {
  UserService _userService;
  ToastService _toastService;

  bool _needsBootstrap;

  UserNotificationsSettings currentNotificationsSettings;

  bool _notifications;

  bool _postCommentNotifications;
  bool _postReactionNotifications;
  bool _followNotifications;
  bool _connectionRequestNotifications;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _notifications = true;
    _postCommentNotifications = true;
    _postReactionNotifications = true;
    _followNotifications = true;
    _connectionRequestNotifications = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _bootstrap();
      _needsBootstrap = false;
    }

    const Widget listItemSeparator = SizedBox(
      height: 10,
    );

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(
          title: 'Notifications Settings',
        ),
        child: OBPrimaryColorContainer(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40),
                    child: Column(
                      children: <Widget>[
                        OBToggleField(
                          value: _notifications,
                          title: 'Notifications',
                          subtitle:
                              OBText('Be notified when something happens'),
                          onChanged: _setNotifications,
                          onTap: _toggleNotifications,
                          hasDivider: false,
                        ),
                        OBDivider(),
                        OBToggleField(
                          value: _followNotifications,
                          title: 'Follow',
                          subtitle: OBText(
                              'Be notified when someone starts following you'),
                          onChanged: _setFollowNotifications,
                          onTap: _toggleFollowNotifications,
                          hasDivider: false,
                        ),
                        listItemSeparator,
                        OBToggleField(
                          value: _connectionRequestNotifications,
                          title: 'Connection request',
                          subtitle: OBText(
                              'Be notified when someone wants to connect with you'),
                          onChanged: _setConnectionRequestNotifications,
                          onTap: _toggleConnectionRequestNotifications,
                          hasDivider: false,
                        ),
                        listItemSeparator,
                        OBToggleField(
                          value: _postCommentNotifications,
                          title: 'Post comment',
                          subtitle: OBText(
                              'Be notified when someone comments on one of your posts'),
                          onChanged: _setPostCommentNotifications,
                          onTap: _togglePostCommentNotifications,
                          hasDivider: false,
                        ),
                        listItemSeparator,
                        OBToggleField(
                          value: _postReactionNotifications,
                          title: 'Post reaction',
                          subtitle: OBText(
                              'Be notified when someone reactions on one of your posts'),
                          onChanged: _setPostReactionNotifications,
                          onTap: _togglePostReactionNotifications,
                          hasDivider: false,
                        )
                      ],
                    )),
              ],
            ),
          ),
        ));
  }

  void _toggleNotifications() {
    _setNotifications(!_notifications);
  }

  void _setNotifications(bool notifications) {
    setState(() {
      _notifications = notifications;
      _connectionRequestNotifications = notifications;
      _postCommentNotifications = notifications;
      _postReactionNotifications = notifications;
      _followNotifications = notifications;
    });

    _submitNotificationsSettings();
  }

  void _toggleConnectionRequestNotifications() {
    _setConnectionRequestNotifications(!_connectionRequestNotifications);
  }

  void _setConnectionRequestNotifications(bool newValue) {
    setState(() {
      _connectionRequestNotifications = newValue;
      if (newValue) _notifications = true;
    });

    _submitNotificationsSettings();
  }

  void _toggleFollowNotifications() {
    _setFollowNotifications(!_followNotifications);
  }

  void _setFollowNotifications(bool newValue) {
    setState(() {
      _followNotifications = newValue;
      if (newValue) _notifications = true;
    });

    _submitNotificationsSettings();
  }

  void _togglePostCommentNotifications() {
    _setPostCommentNotifications(!_postCommentNotifications);
  }

  void _setPostCommentNotifications(bool newValue) {
    setState(() {
      _postCommentNotifications = newValue;
      if (newValue) _notifications = true;
    });

    _submitNotificationsSettings();
  }

  void _togglePostReactionNotifications() {
    _setPostReactionNotifications(!_postReactionNotifications);
  }

  void _setPostReactionNotifications(bool newValue) {
    setState(() {
      _postReactionNotifications = newValue;
      if (newValue) _notifications = true;
    });

    _submitNotificationsSettings();
  }

  void _submitNotificationsSettings() {
    try {
      _userService.updateAuthenticatedUserNotificationsSettings(
        followNotifications: _followNotifications,
        postCommentNotifications: _postCommentNotifications,
        postReactionNotifications: _postReactionNotifications,
        connectionRequestNotifications: _connectionRequestNotifications,
      );
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    }
  }

  void _bootstrap() {
    _refreshNotificationsSettings();
  }

  Future _refreshNotificationsSettings() async {
    try {
      UserNotificationsSettings notificationsSettings =
          await _userService.getAuthenticatedUserNotificationsSettings();

      _setNotificationsSettings(notificationsSettings);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    }
  }

  void _setNotificationsSettings(
      UserNotificationsSettings notificationSettings) {

    setState(() {
      _connectionRequestNotifications = notificationSettings.connectionRequestNotifications;
      _postCommentNotifications = notificationSettings.postCommentNotifications;
      _postReactionNotifications = notificationSettings.postReactionNotifications;
      _followNotifications = notificationSettings.followNotifications;
      _notifications = _connectionRequestNotifications || _postCommentNotifications || _postReactionNotifications || _followNotifications;
    });
  }
}
