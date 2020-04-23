import 'package:Okuna/widgets/fields/toggle_field.dart';
import 'package:Okuna/widgets/buttons/button.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBManageNotifications extends StatefulWidget {
  List<NotificationSetting> notificationSettings;
  OnWantsToSaveSettings onWantsToSaveSettings;
  String mutePostLabelText;
  String unmutePostLabelText;
  VoidCallback onWantsToToggleMute;
  bool isMuted;

  OBManageNotifications(
      {Key key,
      @required this.onWantsToSaveSettings,
      @required this.notificationSettings,
      @required this.mutePostLabelText,
      @required this.unmutePostLabelText,
      @required this.onWantsToToggleMute,
      @required this.isMuted})
      : super(key: key);

  @override
  OBManageNotificationsState createState() {
    return OBManageNotificationsState();
  }
}

class OBManageNotificationsState extends State<OBManageNotifications> {
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
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Opacity(
            opacity: _requestInProgress ? 0.5 : 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildNotificationSettings(),
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

  List<Widget> _buildNotificationSettings() {
    List<Widget> _settings = [];

    widget.notificationSettings
        .forEach((NotificationSetting notificationSetting) => {
              _settings.add(OBToggleField(
                key: Key(notificationSetting.key),
                value: notificationSetting.value,
                isDisabled: notificationSetting.isDisabled,
                title: notificationSetting.localizedTitle,
                subtitle: OBText(notificationSetting.localizedDesc),
                onChanged: (bool newValue) =>
                    notificationSetting.value = newValue,
                onTap: () {
                  _toggleNotificationSetting(notificationSetting);
                  _onWantsToSaveSettings();
                }, // toggle
                hasDivider: false,
              ))
            });

    _settings.add(_buildMuteButtonRow());

    return _settings;
  }

  Widget _buildMuteButtonRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: OBButton(
              size: OBButtonSize.large,
              type: OBButtonType.highlight,
              child: _isMuted
                  ? Text(widget.unmutePostLabelText)
                  : Text(widget.mutePostLabelText),
              onPressed: _onWantsToToggleMute,
            ),
          ),
        ],
      ),
    );
  }

  void _onWantsToSaveSettings() {
    _setRequestInProgress(true);
    Map<String, dynamic> _notificationSettingsMap =
        _getNotificationSettingsMap(widget.notificationSettings);
    widget.onWantsToSaveSettings(_notificationSettingsMap);
    _setRequestInProgress(false);
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
    try {
      widget.onWantsToToggleMute();
      _toggleLocalStateIsMuted();
    } catch (error) {
      print('Manage Notifications Error while toggling mute');
    }

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
