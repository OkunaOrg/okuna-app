import 'package:Okuna/models/user.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:Okuna/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBSubscribeToUserTile extends StatefulWidget {
  final User user;
  final VoidCallback onSubscribedUser;
  final VoidCallback onUnsubscribedUser;

  const OBSubscribeToUserTile({
    Key key,
    @required this.user,
    this.onSubscribedUser,
    this.onUnsubscribedUser,
  }) : super(key: key);

  @override
  OBSubscribeToUserTileState createState() {
    return OBSubscribeToUserTileState();
  }
}

class OBSubscribeToUserTileState extends State<OBSubscribeToUserTile> {
  UserService _userService;
  ToastService _toastService;
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
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _localizationService = openbookProvider.localizationService;

    return StreamBuilder(
      stream: widget.user.updateSubject,
      initialData: widget.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        bool isSubscribed = user.isSubscribed ?? false;

        return OBLoadingTile(
          isLoading: _requestInProgress,
          leading: OBIcon(isSubscribed ? OBIcons.notifications_off : OBIcons.notifications),
          title: OBText(isSubscribed
              ? _localizationService.user__unsubscribe_user
              : _localizationService.user__subscribe_user),
          onTap: isSubscribed ? _unsubscribeUser : _susbcribeUser,
        );
      },
    );
  }

  void _susbcribeUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.subscribeUser(widget.user);
      if (widget.onSubscribedUser != null) widget.onSubscribedUser();
    } catch (e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _unsubscribeUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.unsubscribeUser(widget.user);
      if (widget.onUnsubscribedUser != null) widget.onUnsubscribedUser();
    } catch (e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
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
      _toastService.error(message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
