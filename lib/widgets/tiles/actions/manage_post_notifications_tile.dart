import 'package:Okuna/models/post.dart';
import 'package:Okuna/pages/home/bottom_sheets/manage_notifications/manage_post_notifications.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/bottom_sheet.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBManagePostNotificationsTile extends StatefulWidget {
  final Post post;
  final OnNotificationSettingsSave onNotificationSettingsSave;

  const OBManagePostNotificationsTile({
    Key key,
    @required this.post,
    this.onNotificationSettingsSave,
  }) : super(key: key);

  @override
  OBManagePostNotificationsTileState createState() {
    return OBManagePostNotificationsTileState();
  }
}

class OBManagePostNotificationsTileState
    extends State<OBManagePostNotificationsTile> {
  BottomSheetService _bottomSheetService;
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
    _bottomSheetService = openbookProvider.bottomSheetService;
    _localizationService = openbookProvider.localizationService;

    return StreamBuilder(
      stream: widget.post.updateSubject,
      initialData: widget.post,
      builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
        var post = snapshot.data;

        return ListTile(
          leading: OBIcon(OBIcons.notifications),
          title: OBText(post.postNotificationsSubscription != null
              ? _localizationService.post__manage_post_notifications
              : _localizationService.post__subscribe_post_notifications),
          onTap: _navigateToManagePost,
        );
      },
    );
  }

  void _navigateToManagePost() {
    _bottomSheetService.showManagePostNotifications(
        context: context,
        post: widget.post,
        onNotificationSettingsSave: () {
          if (widget.onNotificationSettingsSave != null)
            widget.onNotificationSettingsSave();
        });
  }
}
