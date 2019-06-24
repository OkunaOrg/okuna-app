import 'dart:async';

import 'package:Okuna/models/notifications/notification.dart';
import 'package:Okuna/models/notifications/notifications_list.dart';
import 'package:Okuna/models/push_notification.dart';
import 'package:Okuna/pages/home/lib/poppable_page_controller.dart';
import 'package:Okuna/pages/home/pages/notifications/widgets/notification_filter.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/services/push_notifications/push_notifications.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/http_list.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/icon_button.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/tiles/notification_tile/notification_tile.dart';
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
  OBNotificationsPageController _controller;

  bool _needsBootstrap;
  bool _isActivePage;

  bool _showFilters = false;
  NotificationFilter _filter = NotificationFilter();

  // Should be the case when the page is visible to the user
  bool _shouldMarkNotificationsAsRead;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notificationsListController = OBHttpListController();
    _controller = widget.controller ?? OBNotificationsPage();
    _controller.attach(state: this, context: context);

    _needsBootstrap = true;
    _shouldMarkNotificationsAsRead = true;
    if (_isActivePage == null) _isActivePage = false;
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
        trailing: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OBIconButton(
              OBIcons.filter,
              themeColor: (_showFilters
                  ? OBIconThemeColor.primaryAccent
                  : OBIconThemeColor.secondaryText),
              onPressed: _toggleNotificationFiltersVisible,
            ),
            Container(
              width: 10,
            ),
            OBIconButton(
              OBIcons.settings,
              themeColor: OBIconThemeColor.primaryAccent,
              onPressed: _onWantsToConfigureNotifications,
            )
          ],
        ),
      ),
      child: OBPrimaryColorContainer(
        child: buildNotificationList(),
      ),
    );
  }

  Widget buildNotificationList() {
    var widgets = <Widget>[];

    if (_showFilters) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: OBNotificationFilter(_filter, _filtersUpdated),
        ),
      );
    }

    widgets.add(
      Expanded(
        child: OBHttpList(
          key: Key('notificationsList'),
          controller: _notificationsListController,
          listRefresher: _refreshNotifications,
          listOnScrollLoader: _loadMoreNotifications,
          listItemBuilder: _buildNotification,
          resourceSingularName: 'notification',
          resourcePluralName: 'notifications',
          physics: const ClampingScrollPhysics(),
        ),
      ),
    );

    return Column(
      children: widgets,
    );
  }

  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _pushNotificationSubscription.cancel();
  }

  void scrollToTop() {
    _notificationsListController.scrollToTop();
  }

  void setIsActivePage(bool isActivePage) {
    setState(() {
      _isActivePage = isActivePage;
    });
  }

  Widget _buildNotification(BuildContext context, OBNotification notification) {
    return OBNotificationTile(
      key: Key(notification.id.toString()),
      notification: notification,
      onNotificationTileDeleted: _onNotificationTileDeleted,
      onPressed: _markNotificationAsRead,
    );
  }

  Future<List<OBNotification>> _refreshNotifications() async {
    await _readNotifications();

    NotificationsList notificationsList =
        await _userService.getNotifications(types: _filter.getActive());
    return notificationsList.notifications;
  }

  Future _readNotifications() async {
    if (_shouldMarkNotificationsAsRead &&
        _notificationsListController.hasItems()) {
      OBNotification firstItem = _notificationsListController.firstItem();
      int maxId = firstItem.id;
      await _userService.readNotifications(
          maxId: maxId, types: _filter.getActive());
    }
  }

  Future<List<OBNotification>> _loadMoreNotifications(
      List<OBNotification> currentNotifications) async {
    OBNotification lastNotification = currentNotifications.last;
    int lastNotificationId = lastNotification.id;
    NotificationsList moreNotifications = await _userService.getNotifications(
        maxId: lastNotificationId, types: _filter.getActive());
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
    bool isNavigating = _controller.canPop();

    if (_pushNotificationTypeVisible(pushNotification.type)) {
      if (!_isActivePage || isNavigating) {
        _triggerRefreshNotifications(shouldScrollToTop: true);
      } else {
        _showRefreshNotificationsToast();
      }
    }
  }

  bool _pushNotificationTypeVisible(PushNotificationType type) {
    switch (type) {
      case PushNotificationType.postReaction:
        return _filter.isActive(NotificationType.postReaction);
      case PushNotificationType.postComment:
        return _filter.isActive(NotificationType.postComment);
      case PushNotificationType.connectionRequest:
        return _filter.isActive(NotificationType.connectionRequest);
      case PushNotificationType.follow:
        return _filter.isActive(NotificationType.follow);
      case PushNotificationType.communityInvite:
        return _filter.isActive(NotificationType.communityInvite);
      default:
        print("Unsupported notification type: $type");
        return true;
    }
  }

  void _showRefreshNotificationsToast() {
    _toastService.info(
        duration: Duration(seconds: 2),
        child: Row(
          children: <Widget>[
            const OBIcon(
              OBIcons.arrowUpward,
              color: Colors.white,
              size: OBIconSize.small,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Load new notifications',
              style: TextStyle(color: Colors.white),
            )
          ],
          mainAxisSize: MainAxisSize.min,
        ),
        context: context,
        onDismissed: () {
          _triggerRefreshNotifications(
              shouldScrollToTop: true,
              shouldUseRefreshIndicator: true,
              shouldMarkNotificationsAsRead: true);
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _triggerRefreshNotifications(
          shouldScrollToTop: true, shouldUseRefreshIndicator: _isActivePage);
    }
  }

  void _triggerRefreshNotifications({
    bool shouldScrollToTop = false,
    bool shouldUseRefreshIndicator = false,
    bool shouldMarkNotificationsAsRead = false,
  }) async {
    _setShouldMarkNotificationsAsRead(shouldMarkNotificationsAsRead);
    await _notificationsListController.refresh(
        shouldScrollToTop: shouldScrollToTop,
        shouldUseRefreshIndicator: shouldUseRefreshIndicator);
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

  void _toggleNotificationFiltersVisible() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  void _filtersUpdated(NotificationFilter filter) {
    setState(() {
      _triggerRefreshNotifications(shouldScrollToTop: true);
    });
  }
}

class OBNotificationsPageController extends PoppablePageController {
  OBNotificationsPageState _state;
  bool _markNotificationsAsRead;
  bool _isActivePage;

  void attach(
      {@required BuildContext context, OBNotificationsPageState state}) {
    super.attach(context: context);
    _state = state;
    if (_markNotificationsAsRead != null)
      _state._setShouldMarkNotificationsAsRead(_markNotificationsAsRead);

    if (_isActivePage != null) _state.setIsActivePage(_isActivePage);
  }

  void scrollToTop() {
    _state.scrollToTop();
  }

  void setIsActivePage(bool isActivePage) {
    if (_state != null) _state.setIsActivePage(isActivePage);
    _isActivePage = isActivePage;
  }

  void setShouldMarkNotificationsAsRead(bool markNotificationsAsRead) {
    if (_state != null)
      _state._setShouldMarkNotificationsAsRead(markNotificationsAsRead);

    _markNotificationsAsRead = markNotificationsAsRead;
  }
}
