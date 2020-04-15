import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/fields/toggle_field.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/buttons/button.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OBManageNotifications extends StatefulWidget {
  List<NotificationSetting> notificationSettings;
  OnWantsToSaveSettings onWantsToSaveSettings;
  VoidCallback onWantsToToggleMute;
  VoidCallback onDismissModal;
  bool isMuted;

  OBManageNotifications(
      {Key key,
      @required this.onWantsToSaveSettings,
      @required this.notificationSettings,
      @required this.onWantsToToggleMute,
      @required this.onDismissModal,
      @required this.isMuted})
      : super(key: key);

  @override
  OBManageNotificationsState createState() {
    return OBManageNotificationsState();
  }
}

class OBManageNotificationsState extends State<OBManageNotifications> {
  LocalizationService _localizationService;
  bool _requestInProgress;
  bool _isMuted;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
    _isMuted = widget.isMuted;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _localizationService = openbookProvider.localizationService;

    return CupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            Expanded(child: _buildNotificationSettings()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OBButton(
                      size: OBButtonSize.large,
                      type: OBButtonType.highlight,
                      child: _isMuted
                          ? Text(_localizationService
                              .post__unmute_post_notifications_text)
                          : Text(_localizationService
                              .post__mute_post_notifications_text),
                      onPressed: _onWantsToToggleMute,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: OBButton(
                      size: OBButtonSize.large,
                      child: Text(_localizationService
                          .post__save_post_notifications_text),
                      onPressed: _onWantsToSaveSettings,
                      isLoading: _requestInProgress,
                    ),
                  )
                ],
              ),
            )
          ],
        )));
  }

  void _toggleNotificationSetting(NotificationSetting setting) {
    setState(() {
      setting.value = !setting.value;
    });
  }

  void _toggleLocalStateIsMuted() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
        leading: GestureDetector(
          child: const OBIcon(OBIcons.close),
          onTap: () {
            if (widget.onDismissModal != null) widget.onDismissModal();
            Navigator.pop(context);
          },
        ),
        title: _localizationService.post__post_notifications_title_text);
  }

  Widget _buildNotificationSettings() {
    return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: widget.notificationSettings.length,
        itemBuilder: (BuildContext context, int index) {
          NotificationSetting notificationSetting =
              widget.notificationSettings[index];

          return OBToggleField(
            key: Key(notificationSetting.key),
            value: notificationSetting.value,
            isDisabled: notificationSetting.isDisabled,
            title: notificationSetting.localizedTitle,
            subtitle: OBText(notificationSetting.localizedDesc),
            onChanged: (bool newValue) => notificationSetting.value = newValue,
            onTap: () {
              _toggleNotificationSetting(notificationSetting);
            }, // toggle
            hasDivider: false,
          );
        });
  }

  void _onWantsToSaveSettings() {
    _setRequestInProgress(true);
    Map<String, dynamic> _notificationSettingsMap =
        _getNotificationSettingsMap(widget.notificationSettings);
    widget.onWantsToSaveSettings(_notificationSettingsMap);
    _setRequestInProgress(false);
    // Navigator.pop(context);
  }

  Map<String, dynamic> _getNotificationSettingsMap(
      List<NotificationSetting> notificationSettings) {
    Map<String, dynamic> _map = {};
    notificationSettings.forEach((NotificationSetting setting) {
      _map[setting.key] = setting.value;
    });
    return _map;
  }

  void _onWantsToToggleMute() async {
    widget.onWantsToToggleMute();
    _toggleLocalStateIsMuted();
    setState(() {
      widget.notificationSettings.forEach((NotificationSetting setting) =>
          setting.isDisabled = !setting.isDisabled);
    });
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}

abstract class NotificationSetting {
  String key;
  bool value;
  bool isDisabled;
  String localizedTitle;
  String localizedDesc;
}

typedef void OnWantsToSaveSettings(
    Map<String, dynamic> notificationSettingsMap);
