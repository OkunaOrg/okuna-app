import 'dart:async';

import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/models/notifications/notifications_list.dart';
import 'package:Openbook/models/push_notification.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/pages/home/lib/poppable_page_controller.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/push_notifications/push_notifications.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
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
  final OBNotificationsPageTab selectedTab;
  final ValueChanged<OBNotificationsPageTab> onTabSelectionChanged;

  OBNotificationsPage({
    this.controller,
    this.selectedTab = OBNotificationsPageTab.general,
    this.onTabSelectionChanged
  });

  @override
  OBNotificationsPageState createState() {
    return OBNotificationsPageState();
  }
}

class OBNotificationsPageState extends State<OBNotificationsPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  UserService _userService;
  ToastService _toastService;
  NavigationService _navigationService;
  PushNotificationsService _pushNotificationsService;
  OBHttpListController<OBNotification> _notificationsListController;
  StreamSubscription _pushNotificationSubscription;
  OBNotificationsPageController _controller;
  TabController _tabController;

  bool _needsBootstrap;
  bool _isActivePage;

  // Should be the case when the page is visible to the user
  bool _shouldMarkNotificationsAsRead;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notificationsListController = OBHttpListController();
    _controller = widget.controller ?? OBNotificationsPage();
    _controller.attach(state: this, context: context);

    _tabController = TabController(length: 2, vsync: this);
    //_tabController.addListener(_onTabSelectionChanged);
    switch (widget.selectedTab) {
      case OBNotificationsPageTab.general:
        _tabController.index = 0;
        break;
      case OBNotificationsPageTab.connectionRequests:
        _tabController.index = 1;
        break;
      default:
        throw 'Unhandled tab index';
    }
    _needsBootstrap = true;
    _shouldMarkNotificationsAsRead = true;
    if (_isActivePage == null) _isActivePage = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);

    if (_needsBootstrap) {
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _navigationService = openbookProvider.navigationService;
      _pushNotificationsService = openbookProvider.pushNotificationsService;
      _bootstrap();
      _needsBootstrap = false;
    }

    ThemeService themeService = openbookProvider.themeService;
    ThemeValueParserService themeValueParser = openbookProvider.themeValueParserService;
    OBTheme theme = themeService.getActiveTheme();

    Color tabIndicatorColor = themeValueParser.parseGradient(theme.primaryAccentColor).colors[1];
    Color tabLabelColor = themeValueParser.parseColor(theme.primaryTextColor);

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
        child: Column(
          children: <Widget>[
            TabBar(
              controller: _tabController,
              tabs: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Tab(text: 'General'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Tab(text: 'Requests'),
                )
              ],
              isScrollable: false,
              indicatorColor: tabIndicatorColor,
              labelColor: tabLabelColor,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _buildGeneralNotifications(),
                  _buildRequestNotifications(),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralNotifications() {
    return OBHttpList(
      key: Key('notificationsList'),
      controller: _notificationsListController,
      listRefresher: _refreshGeneralNotifications,
      listOnScrollLoader: _loadMoreGeneralNotifications,
      listItemBuilder: _buildNotification,
      resourceSingularName: 'notification',
      resourcePluralName: 'notifications',
      physics: const ClampingScrollPhysics(),
    );
  }

  Widget _buildRequestNotifications() {
    return OBHttpList(
      key: Key('notificationsList'),
      controller: _notificationsListController,
      listRefresher: _refreshRequestNotifications,
      listOnScrollLoader: _loadMoreRequestNotifications,
      listItemBuilder: _buildNotification,
      resourceSingularName: 'notification',
      resourcePluralName: 'notifications',
      physics: const ClampingScrollPhysics(),
    );
  }

  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _pushNotificationSubscription.cancel();
   // _tabController.removeListener(_onTabSelectionChanged);
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

  Future<List<OBNotification>> _refreshGeneralNotifications() async {
    var types = <NotificationType>[
      NotificationType.postReaction,
      NotificationType.postComment,
      NotificationType.connectionConfirmed,
      NotificationType.follow,
      NotificationType.communityInvite
    ];
    return _refreshNotifications(types);
  }

  Future<List<OBNotification>> _refreshRequestNotifications() async {
    return _refreshNotifications([NotificationType.connectionRequest]);
  }

  Future<List<OBNotification>> _refreshNotifications([List<NotificationType> types]) async {
    await _readNotifications(types: types);

    NotificationsList notificationsList = await _userService.getNotifications(types: types);
    return notificationsList.notifications;
  }

  Future _readNotifications({List<NotificationType> types}) async {
    if (_shouldMarkNotificationsAsRead &&
        _notificationsListController.hasItems()) {
      OBNotification firstItem = _notificationsListController.firstItem();
      int maxId = firstItem.id;
      await _userService.readNotifications(maxId: maxId, types: types);
    }
  }

  Future<List<OBNotification>> _loadMoreGeneralNotifications(
      List<OBNotification> currentNotifications) async {
    var types = <NotificationType>[
      NotificationType.postReaction,
      NotificationType.postComment,
      NotificationType.connectionConfirmed,
      NotificationType.follow,
      NotificationType.communityInvite
    ];
    return _loadMoreNotifications(currentNotifications, types);
  }

  Future<List<OBNotification>> _loadMoreRequestNotifications(
      List<OBNotification> currentNotifications) async {
    return _loadMoreNotifications(currentNotifications, [NotificationType.connectionRequest]);
  }

  Future<List<OBNotification>> _loadMoreNotifications(
      List<OBNotification> currentNotifications, [List<NotificationType> types]) async {
    OBNotification lastNotification = currentNotifications.last;
    int lastNotificationId = lastNotification.id;
    NotificationsList moreNotifications =
    await _userService.getNotifications(maxId: lastNotificationId, types: types);
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

  void _onTabSelectionChanged() {
    OBNotificationsPageTab newSelection =
        OBNotificationsPageTab.values[_tabController.previousIndex];
    widget.onTabSelectionChanged(newSelection);
  }

  void _onPushNotification(PushNotification pushNotification) {
    bool isNavigating = _controller.canPop();

    if (!_isActivePage || isNavigating) {
      _triggerRefreshNotifications(shouldScrollToTop: true);
    } else {
      _showRefreshNotificationsToast();
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

enum OBNotificationsPageTab { general, connectionRequests }