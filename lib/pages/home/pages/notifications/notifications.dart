import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/models/notifications/notifications_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/lib/poppable_page_controller.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/http_list.dart';
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

class OBNotificationsPageState extends State<OBNotificationsPage> {
  User _user;
  UserService _userService;
  ToastService _toastService;
  OBHttpListController<OBNotification> _notificationsListController;

  @override
  void initState() {
    super.initState();
    _notificationsListController = OBHttpListController();
    if (widget.controller != null)
      widget.controller.attach(state: this, context: context);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(
          title: 'Notifications',
        ),
        child: OBPrimaryColorContainer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: OBHttpList(
                  controller: _notificationsListController,
                  listRefresher: _refreshNotifications,
                  listOnScrollLoader: _loadMoreNotifications,
                  listItemBuilder: _buildNotification,
                  resourceSingularName: 'notification',
                  resourcePluralName: 'notifications',
                ),
              )
            ],
          ),
        ));
  }

  void scrollToTop() {
    _notificationsListController.scrollToTop();
  }

  Widget _buildNotification(BuildContext context, OBNotification notification) {
    return OBNotificationTile(
      notification: notification,
    );
  }

  Future<List<OBNotification>> _refreshNotifications() async {
    NotificationsList notificationsList = await _userService.getNotifications();
    return notificationsList.notifications;
  }

  Future<List<OBNotification>> _loadMoreNotifications(
      List<OBNotification> currentNotifications) async {
    OBNotification lastNotification = currentNotifications.last;
    int lastNotificationId = lastNotification.id;
    NotificationsList moreNotifications =
        await _userService.getNotifications(maxId: lastNotificationId);
    return moreNotifications.notifications;
  }

  void _onPostDeleted(Post deletedPost) {}
}

class OBNotificationsPageController extends PoppablePageController {
  OBNotificationsPageState _state;

  void attach(
      {@required BuildContext context, OBNotificationsPageState state}) {
    super.attach(context: context);
    _state = state;
  }

  void scrollToTop() {
    _state.scrollToTop();
  }
}
