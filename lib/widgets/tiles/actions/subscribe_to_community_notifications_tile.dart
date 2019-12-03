import 'package:Okuna/models/community.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:Okuna/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBSubscribeToCommunityNotificationsTile extends StatefulWidget {
  final Community community;
  final VoidCallback onSubscribed;
  final VoidCallback onUnsubscribed;
  final Widget title;
  final Widget subtitle;

  const OBSubscribeToCommunityNotificationsTile({
    Key key,
    @required this.community,
    this.onSubscribed,
    this.onUnsubscribed,
    this.title,
    this.subtitle
  }) : super(key: key);

  @override
  OBSubscribeToCommunityNotificationsTileState createState() {
    return OBSubscribeToCommunityNotificationsTileState();
  }
}

class OBSubscribeToCommunityNotificationsTileState extends State<OBSubscribeToCommunityNotificationsTile> {
  bool _requestInProgress;
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _localizationService = openbookProvider.localizationService;
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return StreamBuilder(
      stream: widget.community.updateSubject,
      initialData: widget.community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;

        bool isSubscribed = community.isSubscribed ?? false;

        return ListTile(
          enabled: !_requestInProgress,
          leading: OBIcon(isSubscribed ? OBIcons.notifications_off : OBIcons.notifications),
          title: OBText(isSubscribed
              ? _localizationService.community__actions_disable_new_post_notifications_title
              : _localizationService.community__actions_enable_new_post_notifications_title),
          subtitle: isSubscribed ? widget.subtitle : widget.title,
          onTap: isSubscribed ? _unsubscribeCommunity : _subscribeCommunity,
        );
      },
    );
  }

  void _subscribeCommunity() async {
    _setRequestInProgress(true);
    try {
      await _userService.subscribeToCommunityNotifications(widget.community);
      _toastService.success(message: _localizationService.community__actions_enable_new_post_notifications_success, context: context);
    } catch(e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
      if (widget.onSubscribed != null) widget.onSubscribed();
    }
  }

  void _unsubscribeCommunity() async {
    _setRequestInProgress(true);
    try {
      await _userService.unsubscribeFromCommunityNotifications(widget.community);
      _toastService.success(message: _localizationService.community__actions_disable_new_post_notifications_success, context: context);
    } catch(e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
      if (widget.onUnsubscribed != null) widget.onUnsubscribed();
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

}
