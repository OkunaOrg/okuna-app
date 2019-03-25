import 'dart:async';

import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/models/notifications/notifications_list.dart';
import 'package:Openbook/models/push_notifications/push_notification.dart';
import 'package:Openbook/pages/home/lib/poppable_page_controller.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/push_notifications/push_notifications.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/http_list.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/icon_button.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/tiles/notification_tile/notification_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBNotificationsPage extends StatefulWidget {
  final OBNotificationsPageController controller;

  OBNotificationsPage({
    this.controller,
  });

  @override
  OBNotificationsPageState createState() {
    return OBNotificationsPageState();
  }
}

class OBNotificationsPageState extends State<OBNotificationsPage>
    with WidgetsBindingObserver {
  UserService _userService;
  ToastService _toastService;
  NavigationService _navigationService;
  PushNotificationsService _pushNotificationsService;
  OBHttpListController<OBNotification> _notificationsListController;
  StreamSubscription _pushNotificationSubscription;

  bool _needsBootstrap;
  bool _isFirstNotificationsRefresh;

  // Should be the case when the page is visible to the user
  bool _shouldMarkNotificationsAsRead;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notificationsListController = OBHttpListController();
    if (widget.controller != null)
      widget.controller.attach(state: this, context: context);

    _needsBootstrap = true;
    _shouldMarkNotificationsAsRead = true;
    _isFirstNotificationsRefresh = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _navigationService = openbookProvider.navigationService;
      _pushNotificationsService = openbookProvider.pushNotificationsService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(
          title: 'Notifications',
          trailing: OBIconButton(
            OBIcons.settings,
            themeColor: OBIconThemeColor.primaryAccent,
            onPressed: _onWantsToConfigureNotifications,
          ),
        ),
        child: OBPrimaryColorContainer(
          child: OBHttpList(
            controller: _notificationsListController,
            listRefresher: _refreshNotifications,
            listOnScrollLoader: _loadMoreNotifications,
            listItemBuilder: _buildNotification,
            resourceSingularName: 'notification',
            resourcePluralName: 'notifications',
            physics: const AlwaysScrollableScrollPhysics(),
          ),
        ));
  }

  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _pushNotificationSubscription.cancel();
  }

  void scrollToTop() {
    _notificationsListController.scrollToTop();
  }

  Widget _buildNotification(BuildContext context, OBNotification notification) {
    return OBNotificationTile(
      notification: notification,
      onNotificationTileDeleted: _onNotificationTileDeleted,
      onPressed: _markNotificationAsRead,
    );
  }

  Future<List<OBNotification>> _refreshNotifications() async {
    await _readNotifications();

    NotificationsList notificationsList = await _userService.getNotifications();
    return notificationsList.notifications;
  }

  Future _readNotifications() async {
    if (_shouldMarkNotificationsAsRead &&
        _notificationsListController.hasItems()) {
      OBNotification firstItem = _notificationsListController.firstItem();
      int maxId = firstItem.id;
      await _userService.readNotifications(maxId: maxId);
    }
  }

  Future<List<OBNotification>> _loadMoreNotifications(
      List<OBNotification> currentNotifications) async {
    OBNotification lastNotification = currentNotifications.last;
    int lastNotificationId = lastNotification.id;
    NotificationsList moreNotifications =
        await _userService.getNotifications(maxId: lastNotificationId);
    return moreNotifications.notifications;
  }

  void _onNotificationTileDeleted(OBNotification notification) async {
    await _deleteNotification(notification);
    _notificationsListController.removeListItem(notification);
  }

  Future _deleteNotification(OBNotification notification) async {
    try {
      await _userService.deleteNotification(notification);
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

  void _onWantsToConfigureNotifications() {
    _navigationService.navigateToNotificationsSettings(context: context);
  }

  void _bootstrap() {
    _pushNotificationSubscription =
        _pushNotificationsService.pushNotification.listen(_onPushNotification);
  }

  void _onPushNotification(PushNotification pushNotification) {
    _triggeRefreshNotifications();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _triggeRefreshNotifications();
    }
  }

  void _triggeRefreshNotifications() async {
    _setShouldMarkNotificationsAsRead(false);
    await _notificationsListController.refresh();
    _setShouldMarkNotificationsAsRead(true);
  }

  void _setShouldMarkNotificationsAsRead(bool shouldMarkNotificationsAsRead) {
    setState(() {
      _shouldMarkNotificationsAsRead = shouldMarkNotificationsAsRead;
    });
  }

  void _markNotificationAsRead(OBNotification notification) {
    try {
      _userService.readNotification(notification);
      notification.markNotificationAsRead();
    } on HttpieRequestError {
      // Nothing
    } catch (error) {
      print(
          'Couldnt mark notification as read with error: ' + error.toString());
    }
  }
}

class OBNotificationsPageController extends PoppablePageController {
  OBNotificationsPageState _state;
  bool _markNotificationsAsRead;

  void attach(
      {@required BuildContext context, OBNotificationsPageState state}) {
    super.attach(context: context);
    _state = state;
    if (_markNotificationsAsRead != null)
      _state._setShouldMarkNotificationsAsRead(_markNotificationsAsRead);
  }

  void scrollToTop() {
    _state.scrollToTop();
  }

  void setShouldMarkNotificationsAsRead(bool markNotificationsAsRead) {
    if (_state != null)
      _state._setShouldMarkNotificationsAsRead(markNotificationsAsRead);

    _markNotificationsAsRead = markNotificationsAsRead;
  }
}
