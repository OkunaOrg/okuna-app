import 'dart:convert';

import 'package:Openbook/models/device.dart';
import 'package:Openbook/models/push_notification.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/services/user.dart';
import 'package:crypto/crypto.dart';
import 'package:onesignalflutter/onesignalflutter.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationsService {
  static const String oneSignalAppId = '66074bf4-9943-4504-a011-531c2635698b';

  UserService _userService;

  Stream<PushNotification> get pushNotification =>
      _pushNotificationSubject.stream;
  final _pushNotificationSubject = PublishSubject<PushNotification>();

  Stream<PushNotificationOpenedResult> get pushNotificationOpened =>
      _pushNotificationOpenedSubject.stream;
  final _pushNotificationOpenedSubject =
      PublishSubject<PushNotificationOpenedResult>();

  void bootstrap() {
    OneSignal.shared.init(oneSignalAppId, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: true
    });

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.setLocationShared(false);
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
    print('Notification received');
    Map<String, dynamic> notificationData =
        _parseAdditionalData(notification.payload.additionalData);
    PushNotification pushNotification =
        PushNotification.fromJson(notificationData);
    _pushNotificationSubject.add(pushNotification);
  }

  void _onNotificationOpened(OSNotificationOpenedResult result) {
    print('Notification opened');
    OSNotification notification = result.notification;
    PushNotification pushNotification = _makePushNotification(notification);
    _pushNotificationOpenedSubject.add(PushNotificationOpenedResult(
        pushNotification: pushNotification, action: result.action));
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

    String userId = _makeUserId(loggedInUser);

    return Future.wait([
      OneSignal.shared.sendTag('user_id', userId),
      OneSignal.shared.sendTag('device_uuid', currentDevice.uuid),
    ]);
  }

  Future _untagDeviceFromPushNotifications() {
    return Future.wait([
      OneSignal.shared.deleteTag('user_id'),
      OneSignal.shared.deleteTag('user_uuid')
    ]);
  }

  String _makeUserId(User user) {
    var bytes = utf8.encode(user.uuid + user.id.toString());
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void dispose() {
    _pushNotificationSubject.close();
    _pushNotificationOpenedSubject.close();
  }

  PushNotification _makePushNotification(OSNotification notification) {
    Map<String, dynamic> notificationData =
        _parseAdditionalData(notification.payload.additionalData);
    return PushNotification.fromJson(notificationData);
  }

  Map<String, dynamic> _parseAdditionalData(
      Map<dynamic, dynamic> additionalData) {
    String jsonAdditionalData = json.encode(additionalData);
    return json.decode(jsonAdditionalData);
  }
}

class PushNotificationOpenedResult {
  final PushNotification pushNotification;
  final OSNotificationAction action;

  const PushNotificationOpenedResult({this.pushNotification, this.action});
}
