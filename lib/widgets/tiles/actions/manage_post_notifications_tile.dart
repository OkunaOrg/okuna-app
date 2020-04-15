import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_notifications_subscription.dart';
import 'package:Okuna/pages/home/modals/manage_notifications/manage_post_notifications.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/modal_service.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:Okuna/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBManagePostNotificationsTile extends StatefulWidget {
  final Post post;
  final OnNotificationSettingsSave onNotificationSettingsSave;
  final VoidCallback onOpenManagePostNotificationsModal;

  const OBManagePostNotificationsTile({
    Key key,
    @required this.post,
    this.onOpenManagePostNotificationsModal,
    this.onNotificationSettingsSave,
  }) : super(key: key);

  @override
  OBManagePostNotificationsTileState createState() {
    return OBManagePostNotificationsTileState();
  }
}

class OBManagePostNotificationsTileState
    extends State<OBManagePostNotificationsTile> {
  ModalService _modalService;
  LocalizationService _localizationService;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _modalService = openbookProvider.modalService;
    _localizationService = openbookProvider.localizationService;

    return StreamBuilder(
      stream: widget.post.updateSubject,
      initialData: widget.post,
      builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
        var post = snapshot.data;

        bool isReported = post.isReported ?? false;

        return OBLoadingTile(
          isLoading: _requestInProgress || isReported,
          leading: OBIcon(OBIcons.notifications),
          title: OBText(widget.post.postNotificationsSubscription != null
              ? _localizationService.post__manage_post_notifications
              : _localizationService.post__subscribe_post_notifications),
          onTap: _navigateToManagePost,
        );
      },
    );
  }

  void _navigateToManagePost() {
    widget.onOpenManagePostNotificationsModal();
    _modalService.openManagePostNotifications(
        context: context,
        post: widget.post,
        onNotificationSettingsSave: () {
          if (widget.onNotificationSettingsSave != null)
            widget.onNotificationSettingsSave();
        });
  }
}
