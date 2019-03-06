import 'dart:convert';

import 'package:Openbook/models/device.dart';
import 'package:Openbook/models/push_notifications/push_notification.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/services/user.dart';
import 'package:onesignal/onesignal.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationsService {
  static const String oneSignalAppId = '66074bf4-9943-4504-a011-531c2635698b';

  UserService _userService;

  Stream<PushNotification> get pushNotification =>
      _pushNotificationSubject.stream;
  final _pushNotificationSubject = PublishSubject<PushNotification>();

  PushNotificationsService() {
    OneSignal.shared.init(oneSignalAppId, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: true
    });

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared.setNotificationReceivedHandler(_onNotificationReceived);
    OneSignal.shared.setNotificationOpenedHandler(_onNotificationOpened);
    OneSignal.shared.setSubscriptionObserver(_onSubscriptionChanged);
  }

  Future<bool> isSubscribedToPushNotifications() async {
    OSPermissionSubscriptionState osPermissionSubscriptionState =
        await OneSignal.shared.getPermissionSubscriptionState();

    OSSubscriptionState subscriptionState =
        osPermissionSubscriptionState.subscriptionStatus;

    return subscriptionState.subscribed;
  }

  Future enablePushNotifications() async {
    OSPermissionSubscriptionState osPermissionSubscriptionState =
        await OneSignal.shared.getPermissionSubscriptionState();
    OSPermissionState permissionStatus =
        osPermissionSubscriptionState.permissionStatus;

    OSSubscriptionState subscriptionState =
        osPermissionSubscriptionState.subscriptionStatus;

    if (subscriptionState.subscribed) {
      _onSubscribedToPushNotifications();
    } else if (!permissionStatus.hasPrompted) {
      promptUserForPushNotificationPermission();
    }

    return OneSignal.shared.setSubscription(true);
  }

  Future disablePushNotifications() async {
    // This will trigger the _onUnsubscribedFromPushNotifications
    return OneSignal.shared.setSubscription(false);
  }

  void promptUserForPushNotificationPermission() async {
    OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  void setUserService(UserService userService) {
    _userService = userService;
  }

  void _onNotificationReceived(OSNotification notification) {
    Map<String, dynamic> notificationData =
        _parseAdditionalData(notification.payload.additionalData);
    PushNotification pushNotification =
        PushNotification.fromJson(notificationData);
    _pushNotificationSubject.add(pushNotification);
  }

  void _onNotificationOpened(OSNotificationOpenedResult result) {
    print('Notification opened');
  }

  void _onSubscriptionChanged(OSSubscriptionStateChanges changes) {
    OSSubscriptionState toState = changes.to;
    OSSubscriptionState fromState = changes.from;
    if (!fromState.subscribed && toState.subscribed) {
      // User just subscribed for notifications
      _onSubscribedToPushNotifications();
    } else if (fromState.subscribed && !toState.subscribed) {
      // User just unsubscribed for notifications
      _onUnsubscribedFromPushNotifications();
    }
  }

  Future _onSubscribedToPushNotifications() async {
    return _tagDeviceForPushNotifications();
  }

  Future _onUnsubscribedFromPushNotifications() async {
    await _untagDeviceFromPushNotifications();
  }

  Future _tagDeviceForPushNotifications() async {
    User loggedInUser = _userService.getLoggedInUser();
    Device currentDevice = await _userService.getOrCreateCurrentDevice();

    return Future.wait([
      OneSignal.shared.sendTag('user_id', loggedInUser.id),
      OneSignal.shared.sendTag('device_uuid', currentDevice.uuid),
    ]);
  }

  Future _untagDeviceFromPushNotifications() {
    return Future.wait([
      OneSignal.shared.deleteTag('user_id'),
      OneSignal.shared.deleteTag('user_uuid')
    ]);
  }

  void dispose() {
    _pushNotificationSubject.close();
  }

  Map<String, dynamic> _parseAdditionalData(
      Map<dynamic, dynamic> additionalData) {
    String jsonAdditionalData = json.encode(additionalData);
    return json.decode(jsonAdditionalData);
  }
}
